//
//  NetworkManager.swift
//  API client (Actor)
//
//  Created by Jennifer Shi on 2026-02-07.
//

import Foundation
import Combine

enum NetworkError: LocalizedError {
    case invalidURL
    case noData
    case decodingError(Error)
    case serverError(statusCode: Int, message: String?)
    case unauthorized
    case unknown(Error)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "Invalid URL"
        case .noData:
            return "No data received from server"
        case .decodingError(let error):
            return "Failed to decode response: \(error.localizedDescription)"
        case .serverError(let statusCode, let message):
            return message ?? "Server error with status code: \(statusCode)"
        case .unauthorized:
            return "Unauthorized. Please log in again."
        case .unknown(let error):
            return error.localizedDescription
        }
    }
}

actor NetworkManager {
    static let shared = NetworkManager()
    
    private let session: URLSession
    private let decoder: JSONDecoder
    private let encoder: JSONEncoder
    
    private init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = Config.API.timeout
        configuration.waitsForConnectivity = true
        self.session = URLSession(configuration: configuration)
        
        // Configure decoder
        self.decoder = JSONDecoder()
        self.decoder.keyDecodingStrategy = .convertFromSnakeCase
        self.decoder.dateDecodingStrategy = .iso8601
        
        // Configure encoder
        self.encoder = JSONEncoder()
        self.encoder.keyEncodingStrategy = .convertToSnakeCase
        self.encoder.dateEncodingStrategy = .iso8601
    }
    
    // MARK: - GET Request
    func fetch<T: Decodable>(
        from endpoint: String,
        requiresAuth: Bool = true
    ) async throws -> T {
        guard let url = buildURL(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        
        if requiresAuth {
            try await addAuthHeaders(to: &request)
        }
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response, data: data)
        
        do {
            return try decoder.decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - POST Request
    func post<T: Encodable, R: Decodable>(
        to endpoint: String,
        body: T,
        requiresAuth: Bool = true
    ) async throws -> R {
        guard let url = buildURL(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            try await addAuthHeaders(to: &request)
        }
        
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response, data: data)
        
        do {
            return try decoder.decode(R.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - PUT Request
    func put<T: Encodable, R: Decodable>(
        to endpoint: String,
        body: T,
        requiresAuth: Bool = true
    ) async throws -> R {
        guard let url = buildURL(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        if requiresAuth {
            try await addAuthHeaders(to: &request)
        }
        
        request.httpBody = try encoder.encode(body)
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response, data: data)
        
        do {
            return try decoder.decode(R.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }
    
    // MARK: - DELETE Request
    func delete(
        from endpoint: String,
        requiresAuth: Bool = true
    ) async throws {
        guard let url = buildURL(from: endpoint) else {
            throw NetworkError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        if requiresAuth {
            try await addAuthHeaders(to: &request)
        }
        
        let (data, response) = try await session.data(for: request)
        
        try validateResponse(response, data: data)
    }
    
    // MARK: - Streaming Request (for AI Chat)
    func stream(
        from endpoint: String,
        body: [String: Any],
        requiresAuth: Bool = true
    ) -> AsyncThrowingStream<String, Error> {
        AsyncThrowingStream { continuation in
            Task {
                do {
                    guard let url = buildURL(from: endpoint) else {
                        throw NetworkError.invalidURL
                    }
                    
                    var request = URLRequest(url: url)
                    request.httpMethod = "POST"
                    request.setValue("application/json", forHTTPHeaderField: "Content-Type")
                    request.setValue("text/event-stream", forHTTPHeaderField: "Accept")
                    request.timeoutInterval = Config.API.streamingTimeout
                    
                    if requiresAuth {
                        try await addAuthHeaders(to: &request)
                    }
                    
                    let jsonData = try JSONSerialization.data(withJSONObject: body)
                    request.httpBody = jsonData
                    
                    let (bytes, response) = try await session.bytes(for: request)
                    
                    guard let httpResponse = response as? HTTPURLResponse else {
                        throw NetworkError.noData
                    }
                    
                    guard (200...299).contains(httpResponse.statusCode) else {
                        throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: nil)
                    }
                    
                    for try await line in bytes.lines {
                        if line.hasPrefix("data: ") {
                            let data = String(line.dropFirst(6))
                            if data == "[DONE]" {
                                continuation.finish()
                                break
                            }
                            continuation.yield(data)
                        }
                    }
                    
                    continuation.finish()
                } catch {
                    continuation.finish(throwing: error)
                }
            }
        }
    }
    
    // MARK: - Helper Methods
    private func buildURL(from endpoint: String) -> URL? {
        if endpoint.hasPrefix("http") {
            return URL(string: endpoint)
        }
        return URL(string: Config.API.baseURL + endpoint)
    }
    
    private func addAuthHeaders(to request: inout URLRequest) async throws {
        if let token = KeychainManager.shared.getAccessToken() {
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        } else {
            throw NetworkError.unauthorized
        }
    }
    
    private func validateResponse(_ response: URLResponse, data: Data) throws {
        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.noData
        }
        
        switch httpResponse.statusCode {
        case 200...299:
            return
        case 401:
            throw NetworkError.unauthorized
        default:
            let message = try? JSONSerialization.jsonObject(with: data) as? [String: Any]
            let errorMessage = message?["message"] as? String ?? message?["error"] as? String
            throw NetworkError.serverError(statusCode: httpResponse.statusCode, message: errorMessage)
        }
    }
}

// MARK: - Response Models
struct APIResponse<T: Decodable>: Decodable {
    let data: T
    let message: String?
    let success: Bool
}

struct EmptyResponse: Decodable {}
