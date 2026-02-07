//
//  ContentView.swift
//  Main tab navigation.
//
//  Created by Jennifer Shi on 2026-02-07.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @State private var selectedTab: Tab = .dashboard
    
    var body: some View {
        Group {
            if !appState.isAuthenticated {
                AuthenticationView()
            } else if !appState.hasCompletedOnboarding {
                OnboardingView()
            } else {
                MainTabView(selectedTab: $selectedTab)
            }
        }
    }
}

// MARK: - Main Tab View
struct MainTabView: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        TabView(selection: $selectedTab) {
            DashboardView()
                .tabItem {
                    Label("Dashboard", systemImage: "chart.bar.fill")
                }
                .tag(Tab.dashboard)
            
            TransactionsView()
                .tabItem {
                    Label("Transactions", systemImage: "list.bullet.rectangle")
                }
                .tag(Tab.transactions)
            
            BudgetView()
                .tabItem {
                    Label("Budget", systemImage: "dollarsign.circle.fill")
                }
                .tag(Tab.budget)
            
            ChatView()
                .tabItem {
                    Label("Coach", systemImage: "message.fill")
                }
                .tag(Tab.chat)
            
            ProfileView()
                .tabItem {
                    Label("Profile", systemImage: "person.fill")
                }
                .tag(Tab.profile)
        }
        .accentColor(.michiPrimary)
    }
}

// MARK: - Tab Enum
enum Tab {
    case dashboard
    case transactions
    case budget
    case chat
    case profile
}

// MARK: - Preview
#Preview {
    ContentView()
        .environmentObject(AppState())
}
