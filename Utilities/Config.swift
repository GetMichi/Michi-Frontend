//
//  Config.swift
//  App configuration
//  Contains: API endpoints, Supabase config, Plaid config, UI constants, Feature flags
//
//  Created by Jennifer Shi on 2026-02-07.
//

import Foundation

enum Config {
    // MARK: - App Information
    static let appName = "Michi"
    static let appVersion = "1.0.0"
    static let bundleIdentifier = "com.michi.app"
    
    // MARK: - API Configuration
    enum API {
        static let baseURL: String = {
            #if DEBUG
            return "http://localhost:8000"  // Local development
            #else
            return "https://api.michi.app"  // Production
            #endif
        }()
        
        static let timeout: TimeInterval = 30
        static let streamingTimeout: TimeInterval = 120
        
        #if DEBUG
        static let isDebugMode = true
        #else
        static let isDebugMode = false
        #endif
    }
    
    // MARK: - Supabase Configuration
    enum Supabase {
        static let url = "YOUR_SUPABASE_URL"
        static let anonKey = "YOUR_SUPABASE_ANON_KEY"
    }
    
    // MARK: - Plaid Configuration
    enum Plaid {
        static let environment: String = {
            #if DEBUG
            return "sandbox"
            #else
            return "production"
            #endif
        }()
        
        static let clientName = "Michi"
        static let products = ["transactions"]
        static let countryCodes = ["US"]
        static let language = "en"
    }
    
    // MARK: - UI Configuration
    enum UI {
        static let animationDuration: Double = 0.3
        static let cornerRadius: CGFloat = 12
        static let defaultPadding: CGFloat = 16
        static let cardShadowRadius: CGFloat = 5
        static let maxChatBubbleWidth: CGFloat = 280
    }
    
    // MARK: - Feature Flags
    enum Features {
        static let chatbotEnabled = true
        static let goalsEnabled = true
        static let investmentsEnabled = false  // Future feature
        static let familySharingEnabled = false  // Future feature
    }
    
    // MARK: - Keychain Keys
    enum Keychain {
        static let accessTokenKey = "michi.access_token"
        static let refreshTokenKey = "michi.refresh_token"
        static let plaidTokenKey = "michi.plaid_token"
    }
}
