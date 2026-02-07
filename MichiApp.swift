//
//  MichiApp.swift
//  Main entrypoint for app.
//
//  Created by Jennifer Shi on 2026-02-07.
//


import SwiftUI

@main
struct MichiApp: App {
    @StateObject private var appState = AppState()
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(appState)
                .preferredColorScheme(.dark) // iOS-first dark mode
        }
    }
}

// MARK: - App State
/// Central app state management
/// This is the "traffic controller" that decides what screen to show based on whether user is logged in and has completed onboarding. Controls session state
class AppState: ObservableObject {
    @Published var isAuthenticated: Bool = false
    @Published var user: User?
    @Published var hasCompletedOnboarding: Bool = false
    
    init() {
        // Load persisted state
        checkAuthenticationState()
    }
    
    private func checkAuthenticationState() {
        // TODO: Check Keychain for auth tokens
        // TODO: Load user data from Supabase
    }
}
