//
//  PlaceholderViews.swift
//  
//
//  Created by Jennifer Shi on 2026-02-07.
//

import SwiftUI

// MARK: - Transactions View
struct TransactionsView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Transactions View")
                    .font(.title)
                    .padding()
            }
            .navigationTitle("Transactions")
        }
    }
}

// MARK: - Budget View
struct BudgetView: View {
    var body: some View {
        NavigationStack {
            ScrollView {
                Text("Budget View")
                    .font(.title)
                    .padding()
            }
            .navigationTitle("Budget")
        }
    }
}

// MARK: - Profile View
struct ProfileView: View {
    var body: some View {
        NavigationStack {
            List {
                Section("Account") {
                    NavigationLink("Personal Information") {
                        Text("Personal Info")
                    }
                    NavigationLink("Preferences") {
                        Text("Preferences")
                    }
                    NavigationLink("Connected Accounts") {
                        Text("Accounts")
                    }
                }
                
                Section("App") {
                    NavigationLink("Notifications") {
                        Text("Notifications")
                    }
                    NavigationLink("Privacy & Security") {
                        Text("Privacy")
                    }
                    NavigationLink("About") {
                        Text("About Michi")
                    }
                }
                
                Section {
                    Button("Sign Out") {
                        // Sign out action
                    }
                    .foregroundColor(.michiError)
                }
            }
            .navigationTitle("Profile")
        }
    }
}

// MARK: - Authentication View
struct AuthenticationView: View {
    @State private var email = ""
    @State private var password = ""
    @State private var isLogin = true
    
    var body: some View {
        VStack(spacing: 24) {
            Spacer()
            
            // Logo
            Image(systemName: "dollarsign.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(.michiPrimary)
            
            Text("Michi")
                .font(.system(size: 42, weight: .bold, design: .rounded))
                .foregroundColor(.michiTextPrimary)
            
            Text("Your AI-powered financial coach")
                .font(.subheadline)
                .foregroundColor(.michiTextSecondary)
            
            Spacer()
            
            // Form
            VStack(spacing: 16) {
                TextField("Email", text: $email)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.michiSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .textContentType(.emailAddress)
                    .autocapitalization(.none)
                
                SecureField("Password", text: $password)
                    .textFieldStyle(.plain)
                    .padding()
                    .background(Color.michiSurface)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .textContentType(.password)
                
                Button(action: {}) {
                    Text(isLogin ? "Sign In" : "Sign Up")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.michiPrimary)
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                }
                
                Button(action: { isLogin.toggle() }) {
                    Text(isLogin ? "Don't have an account? Sign Up" : "Already have an account? Sign In")
                        .font(.subheadline)
                        .foregroundColor(.michiPrimary)
                }
            }
            .padding(.horizontal, 32)
            
            Spacer()
        }
        .background(Color.michiBackground.ignoresSafeArea())
    }
}

// MARK: - Onboarding View
struct OnboardingView: View {
    @State private var currentPage = 0
    
    var body: some View {
        TabView(selection: $currentPage) {
            OnboardingPage(
                icon: "chart.bar.fill",
                title: "Track Your Spending",
                description: "See where your money goes with automatic transaction tracking"
            )
            .tag(0)
            
            OnboardingPage(
                icon: "dollarsign.circle.fill",
                title: "Smart Budgets",
                description: "AI-powered budget recommendations based on your spending patterns"
            )
            .tag(1)
            
            OnboardingPage(
                icon: "message.fill",
                title: "Financial Coach",
                description: "Chat with your AI coach for personalized advice and insights"
            )
            .tag(2)
        }
        .tabViewStyle(.page(indexDisplayMode: .always))
        .indexViewStyle(.page(backgroundDisplayMode: .always))
    }
}

struct OnboardingPage: View {
    let icon: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 32) {
            Spacer()
            
            Image(systemName: icon)
                .font(.system(size: 100))
                .foregroundColor(.michiPrimary)
            
            VStack(spacing: 16) {
                Text(title)
                    .font(.title)
                    .fontWeight(.bold)
                    .foregroundColor(.michiTextPrimary)
                
                Text(description)
                    .font(.body)
                    .foregroundColor(.michiTextSecondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
            
            Spacer()
            
            Button(action: {}) {
                Text("Get Started")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.michiPrimary)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            }
            .padding(.horizontal, 32)
            .padding(.bottom, 50)
        }
        .background(Color.michiBackground.ignoresSafeArea())
    }
}
