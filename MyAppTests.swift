//
//  ContentViewTests.swift
//  MyAppTests
//
//  Created on 2/1/26.
//

import Testing
@testable import MyApp

@Suite("ContentView Tests")
struct ContentViewTests {
    
    @Test("Example test")
    func exampleTest() async throws {
        // Given
        let expectedValue = 42
        
        // When
        let actualValue = 42
        
        // Then
        #expect(actualValue == expectedValue, "Values should match")
    }
    
    @Test("Network Manager exists")
    func networkManagerExists() async throws {
        // Test that NetworkManager is accessible
        let manager = await NetworkManager.shared
        #expect(manager != nil)
    }
}

// MARK: - Model Tests
@Suite("Model Tests")
struct ModelTests {
    
    @Test("Post model can be decoded")
    func postDecoding() async throws {
        // Given
        let json = """
        {
            "id": 1,
            "userId": 1,
            "title": "Test Title",
            "body": "Test Body"
        }
        """
        
        // When
        let data = json.data(using: .utf8)!
        let decoder = JSONDecoder()
        let post = try decoder.decode(Post.self, from: data)
        
        // Then
        #expect(post.id == 1)
        #expect(post.title == "Test Title")
        #expect(post.body == "Test Body")
    }
}

// MARK: - Extension Tests
@Suite("Extension Tests")
struct ExtensionTests {
    
    @Test("Email validation works correctly")
    func emailValidation() {
        #expect("test@example.com".isValidEmail == true)
        #expect("invalid-email".isValidEmail == false)
        #expect("".isValidEmail == false)
    }
}
