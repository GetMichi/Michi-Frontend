//
//  DashboardViewModel.swift
//  Dashboard state & logic
//
//  Created by Jennifer Shi on 2026-02-07.
//

import Foundation
import Combine

@MainActor
class DashboardViewModel: ObservableObject {
    @Published var totalBalance: Double = 0
    @Published var monthlyIncome: Double = 0
    @Published var monthlyExpenses: Double = 0
    @Published var budgets: [Budget] = []
    @Published var spendingData: [SpendingDataPoint] = []
    @Published var insights: [Insight] = []
    @Published var recentTransactions: [Transaction] = []
    @Published var selectedPeriod: TimePeriod = .month
    @Published var isLoading: Bool = false
    @Published var error: Error?
    
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        setupObservers()
    }
    
    private func setupObservers() {
        // Reload spending data when period changes
        $selectedPeriod
            .dropFirst()
            .sink { [weak self] _ in
                Task {
                    await self?.loadSpendingData()
                }
            }
            .store(in: &cancellables)
    }
    
    func loadData() async {
        isLoading = true
        defer { isLoading = false }
        
        async let accounts = loadAccounts()
        async let budgets = loadBudgets()
        async let transactions = loadRecentTransactions()
        async let insights = loadInsights()
        
        await loadSpendingData()
        
        do {
            let _ = try await (accounts, budgets, transactions, insights)
        } catch {
            self.error = error
            print("Error loading dashboard data: \(error)")
        }
    }
    
    func refresh() async {
        await loadData()
    }
    
    private func loadAccounts() async throws {
        // TODO: Replace with actual API call
        let response: APIResponse<[Account]> = try await NetworkManager.shared.fetch(from: "/accounts")
        
        // Calculate total balance
        totalBalance = response.data.reduce(0) { $0 + ($1.currentBalance ?? 0) }
    }
    
    private func loadBudgets() async throws {
        // TODO: Replace with actual API call
        let response: APIResponse<[Budget]> = try await NetworkManager.shared.fetch(from: "/budgets")
        budgets = response.data
    }
    
    private func loadRecentTransactions() async throws {
        // TODO: Replace with actual API call
        let response: APIResponse<[Transaction]> = try await NetworkManager.shared.fetch(from: "/transactions/recent")
        recentTransactions = response.data
        
        // Calculate monthly income and expenses
        let currentMonth = Date().startOfMonth
        let monthTransactions = response.data.filter { $0.date >= currentMonth }
        
        monthlyIncome = monthTransactions
            .filter { $0.amount < 0 }
            .reduce(0) { $0 + abs($1.amount) }
        
        monthlyExpenses = monthTransactions
            .filter { $0.amount > 0 }
            .reduce(0) { $0 + $1.amount }
    }
    
    private func loadInsights() async throws {
        // TODO: Replace with actual API call
        let response: APIResponse<[Insight]> = try await NetworkManager.shared.fetch(from: "/insights")
        insights = response.data
    }
    
    private func loadSpendingData() async {
        do {
            // TODO: Replace with actual API call
            let endpoint = "/analytics/spending?period=\(selectedPeriod.rawValue.lowercased())"
            let response: APIResponse<[SpendingDataPoint]> = try await NetworkManager.shared.fetch(from: endpoint)
            spendingData = response.data
        } catch {
            self.error = error
            print("Error loading spending data: \(error)")
        }
    }
}

// MARK: - SpendingDataPoint Codable
extension SpendingDataPoint: Codable {
    enum CodingKeys: String, CodingKey {
        case date
        case amount
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        date = try container.decode(Date.self, forKey: .date)
        amount = try container.decode(Double.self, forKey: .amount)
    }
    
    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(date, forKey: .date)
        try container.encode(amount, forKey: .amount)
    }
}
