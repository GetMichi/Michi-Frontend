//
//  ChatViewModel.swift
//  Chat state & streaming
//
//  Created by Jennifer Shi on 2026-02-07.
//

import Foundation
import Combine

@MainActor
class ChatViewModel: ObservableObject {
    @Published var messages: [ChatMessage] = []
    @Published var isLoading: Bool = false
    @Published var currentTone: ChatTone = .supportive
    @Published var error: Error?
    
    private var streamingMessageId: String?
    private var cancellables = Set<AnyCancellable>()
    
    func loadConversationHistory() async {
        do {
            // TODO: Load from local storage or API
            let response: APIResponse<[ChatMessage]> = try await NetworkManager.shared.fetch(from: "/chat/history")
            messages = response.data
        } catch {
            print("Error loading conversation history: \(error)")
            // Start with welcome message if no history
            if messages.isEmpty {
                addWelcomeMessage()
            }
        }
    }
    
    func sendMessage(_ text: String) async {
        // Add user message
        let userMessage = ChatMessage(content: text, sender: .user)
        messages.append(userMessage)
        
        // Start streaming AI response
        isLoading = true
        streamingMessageId = UUID().uuidString
        
        do {
            var fullResponse = ""
            let aiMessageId = streamingMessageId!
            
            // Create initial AI message
            let aiMessage = ChatMessage(
                id: aiMessageId,
                content: "",
                sender: .ai,
                isStreaming: true
            )
            messages.append(aiMessage)
            
            // Stream the response
            let stream = await NetworkManager.shared.stream(
                from: "/chat/stream",
                body: [
                    "message": text,
                    "tone": currentTone.rawValue,
                    "conversation_history": messages.dropLast().map { msg in
                        ["role": msg.sender == .user ? "user" : "assistant", "content": msg.content]
                    }
                ]
            )
            
            for try await chunk in stream {
                fullResponse += chunk
                
                // Update the streaming message
                if let index = messages.firstIndex(where: { $0.id == aiMessageId }) {
                    messages[index] = ChatMessage(
                        id: aiMessageId,
                        content: fullResponse,
                        sender: .ai,
                        timestamp: messages[index].timestamp,
                        isStreaming: true
                    )
                }
            }
            
            // Finalize the message
            if let index = messages.firstIndex(where: { $0.id == aiMessageId }) {
                messages[index] = ChatMessage(
                    id: aiMessageId,
                    content: fullResponse,
                    sender: .ai,
                    timestamp: messages[index].timestamp,
                    isStreaming: false
                )
            }
            
            // Save conversation to backend
            await saveConversation()
            
        } catch {
            self.error = error
            print("Error streaming message: \(error)")
            
            // Add error message
            let errorMessage = ChatMessage(
                content: "I'm having trouble connecting right now. Please try again.",
                sender: .ai
            )
            
            // Remove streaming message and add error
            messages.removeAll { $0.id == streamingMessageId }
            messages.append(errorMessage)
        }
        
        isLoading = false
        streamingMessageId = nil
    }
    
    func updateTone(_ tone: ChatTone) {
        currentTone = tone
        
        // Save preference to backend
        Task {
            do {
                let _: EmptyResponse = try await NetworkManager.shared.put(
                    to: "/user/preferences",
                    body: ["chat_tone": tone.rawValue]
                )
            } catch {
                print("Error updating tone preference: \(error)")
            }
        }
    }
    
    func clearConversation() {
        messages.removeAll()
        addWelcomeMessage()
        
        Task {
            do {
                try await NetworkManager.shared.delete(from: "/chat/history")
            } catch {
                print("Error clearing conversation: \(error)")
            }
        }
    }
    
    private func addWelcomeMessage() {
        let welcomeMessage = ChatMessage(
            content: "Hi! I'm your financial coach. I'm here to help you understand your spending, stay on budget, and reach your financial goals. What would you like to know?",
            sender: .ai
        )
        messages.append(welcomeMessage)
    }
    
    private func saveConversation() async {
        do {
            let _: EmptyResponse = try await NetworkManager.shared.post(
                to: "/chat/save",
                body: ["messages": messages.map { msg in
                    [
                        "content": msg.content,
                        "sender": msg.sender == .user ? "user" : "assistant",
                        "timestamp": msg.timestamp
                    ]
                }]
            )
        } catch {
            print("Error saving conversation: \(error)")
        }
    }
}

// MARK: - ChatMessage Codable
extension ChatMessage: Codable {
    enum CodingKeys: String, CodingKey {
        case id
        case content
        case sender
        case timestamp
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        content = try container.decode(String.self, forKey: .content)
        let senderString = try container.decode(String.self, forKey: .sender)
        sender = senderString == "user" ? .user : .ai
        timestamp = try container.decode(Date.self, forKey: .timestamp)
        isStreaming = false
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(content, forKey: .content)
        try container.encode(sender == .user ? "user" : "assistant", forKey: .sender)
        try container.encode(timestamp, forKey: .timestamp)
    }
}
