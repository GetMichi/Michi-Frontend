//
//  Config.swift
//  MyApp
//
//  Created on 2/1/26.
//

import Foundation

enum Config {
    // MARK: - App Information
    static let appName = "MyApp"
    static let appVersion = "1.0.0"
    static let bundleIdentifier = "com.yourcompany.myapp"
    
    // MARK: - API Configuration
    enum API {
        static let baseURL = "https://api.example.com"
        static let timeout: TimeInterval = 30
        
        #if DEBUG
        static let isDebugMode = true
        #else
        static let isDebugMode = false
        #endif
    }
    
    // MARK: - UI Configuration
    enum UI {
        static let animationDuration: Double = 0.3
        static let cornerRadius: CGFloat = 12
        static let defaultPadding: CGFloat = 16
    }
}
