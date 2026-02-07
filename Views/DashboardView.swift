//
//  DashboardView.swift
//
//  Created by Jennifer Shi on 2026-02-07.
//

import SwiftUI
import Charts

struct DashboardView: View {
    @StateObject private var viewModel = DashboardViewModel()
    
    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    // Account Summary Card
                    AccountSummaryCard(
                        totalBalance: viewModel.totalBalance,
                        monthlyIncome: viewModel.monthlyIncome,
                        monthlyExpenses: viewModel.monthlyExpenses
                    )
                    
                    // Budget Overview
                    if !viewModel.budgets.isEmpty {
                        BudgetOverviewCard(budgets: viewModel.budgets)
                    }
                    
                    // Spending Chart
                    SpendingChartCard(
                        spendingData: viewModel.spendingData,
                        period: $viewModel.selectedPeriod
                    )
                    
                    // Quick Insights
                    if !viewModel.insights.isEmpty {
                        InsightsCard(insights: viewModel.insights)
                    }
                    
                    // Recent Transactions
                    RecentTransactionsCard(
                        transactions: viewModel.recentTransactions
                    )
                }
                .padding()
            }
            .navigationTitle("Dashboard")
            .refreshable {
                await viewModel.refresh()
            }
            .task {
                await viewModel.loadData()
            }
        }
    }
}

// MARK: - Account Summary Card
struct AccountSummaryCard: View {
    let totalBalance: Double
    let monthlyIncome: Double
    let monthlyExpenses: Double
    
    var body: some View {
        VStack(spacing: 16) {
            // Total Balance
            VStack(spacing: 4) {
                Text("Total Balance")
                    .font(.subheadline)
                    .foregroundColor(.michiTextSecondary)
                Text(totalBalance.asCurrency())
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.michiTextPrimary)
            }
            
            Divider()
            
            // Income and Expenses
            HStack(spacing: 40) {
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.down.circle.fill")
                            .foregroundColor(.michiSuccess)
                        Text("Income")
                            .font(.caption)
                            .foregroundColor(.michiTextSecondary)
                    }
                    Text(monthlyIncome.asCurrency())
                        .font(.headline)
                        .foregroundColor(.michiTextPrimary)
                }
                
                VStack(spacing: 4) {
                    HStack(spacing: 4) {
                        Image(systemName: "arrow.up.circle.fill")
                            .foregroundColor(.michiError)
                        Text("Expenses")
                            .font(.caption)
                            .foregroundColor(.michiTextSecondary)
                    }
                    Text(monthlyExpenses.asCurrency())
                        .font(.headline)
                        .foregroundColor(.michiTextPrimary)
                }
            }
        }
        .michiPadding()
        .michiCardStyle()
    }
}

// MARK: - Budget Overview Card
struct BudgetOverviewCard: View {
    let budgets: [Budget]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Budget Overview")
                    .font(.headline)
                    .foregroundColor(.michiTextPrimary)
                Spacer()
                NavigationLink(destination: BudgetView()) {
                    Text("View All")
                        .font(.caption)
                        .foregroundColor(.michiPrimary)
                }
            }
            
            ForEach(budgets.prefix(3)) { budget in
                BudgetProgressRow(budget: budget)
            }
        }
        .michiPadding()
        .michiCardStyle()
    }
}

struct BudgetProgressRow: View {
    let budget: Budget
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack {
                Text(budget.category)
                    .font(.subheadline)
                    .foregroundColor(.michiTextPrimary)
                Spacer()
                Text("\(budget.spentAmount.asCurrency()) / \(budget.allocatedAmount.asCurrency())")
                    .font(.caption)
                    .foregroundColor(.michiTextSecondary)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.michiTextTertiary.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor(for: budget.percentageUsed))
                        .frame(width: geometry.size.width * min(budget.percentageUsed / 100, 1.0), height: 8)
                }
            }
            .frame(height: 8)
        }
    }
    
    private func progressColor(for percentage: Double) -> Color {
        switch percentage {
        case 0..<70: return .michiSuccess
        case 70..<90: return .michiWarning
        default: return .michiError
        }
    }
}

// MARK: - Spending Chart Card
struct SpendingChartCard: View {
    let spendingData: [SpendingDataPoint]
    @Binding var period: TimePeriod
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Spending Trends")
                    .font(.headline)
                    .foregroundColor(.michiTextPrimary)
                Spacer()
                Picker("Period", selection: $period) {
                    ForEach(TimePeriod.allCases, id: \.self) { period in
                        Text(period.rawValue).tag(period)
                    }
                }
                .pickerStyle(.segmented)
                .frame(width: 200)
            }
            
            if spendingData.isEmpty {
                Text("No data available")
                    .font(.subheadline)
                    .foregroundColor(.michiTextSecondary)
                    .frame(height: 200)
                    .frame(maxWidth: .infinity)
            } else {
                Chart(spendingData) { dataPoint in
                    LineMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Amount", dataPoint.amount)
                    )
                    .foregroundStyle(.michiPrimary)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", dataPoint.date),
                        y: .value("Amount", dataPoint.amount)
                    )
                    .foregroundStyle(
                        .linearGradient(
                            colors: [.michiPrimary.opacity(0.3), .michiPrimary.opacity(0.0)],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 200)
                .chartXAxis {
                    AxisMarks(values: .automatic) { _ in
                        AxisGridLine()
                        AxisValueLabel(format: .dateTime.month().day())
                    }
                }
                .chartYAxis {
                    AxisMarks(values: .automatic) { value in
                        AxisGridLine()
                        AxisValueLabel {
                            if let amount = value.as(Double.self) {
                                Text(amount.asCurrency())
                            }
                        }
                    }
                }
            }
        }
        .michiPadding()
        .michiCardStyle()
    }
}

enum TimePeriod: String, CaseIterable {
    case week = "Week"
    case month = "Month"
    case year = "Year"
}

struct SpendingDataPoint: Identifiable {
    let id = UUID()
    let date: Date
    let amount: Double
}

// MARK: - Insights Card
struct InsightsCard: View {
    let insights: [Insight]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Insights")
                .font(.headline)
                .foregroundColor(.michiTextPrimary)
            
            ForEach(insights.prefix(3)) { insight in
                InsightRow(insight: insight)
            }
        }
        .michiPadding()
        .michiCardStyle()
    }
}

struct InsightRow: View {
    let insight: Insight
    
    var body: some View {
        HStack(alignment: .top, spacing: 12) {
            Image(systemName: insight.category.icon)
                .foregroundColor(Color(insight.category.color))
                .frame(width: 24, height: 24)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(insight.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                    .foregroundColor(.michiTextPrimary)
                Text(insight.description)
                    .font(.caption)
                    .foregroundColor(.michiTextSecondary)
            }
            
            Spacer()
        }
    }
}

// MARK: - Recent Transactions Card
struct RecentTransactionsCard: View {
    let transactions: [Transaction]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack {
                Text("Recent Transactions")
                    .font(.headline)
                    .foregroundColor(.michiTextPrimary)
                Spacer()
                NavigationLink(destination: TransactionsView()) {
                    Text("View All")
                        .font(.caption)
                        .foregroundColor(.michiPrimary)
                }
            }
            
            if transactions.isEmpty {
                Text("No transactions yet")
                    .font(.subheadline)
                    .foregroundColor(.michiTextSecondary)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
            } else {
                ForEach(transactions.prefix(5)) { transaction in
                    TransactionRow(transaction: transaction)
                }
            }
        }
        .michiPadding()
        .michiCardStyle()
    }
}

struct TransactionRow: View {
    let transaction: Transaction
    
    var body: some View {
        HStack(spacing: 12) {
            // Category icon
            Image(systemName: "creditcard.fill")
                .foregroundColor(.michiPrimary)
                .frame(width: 32, height: 32)
            
            // Transaction details
            VStack(alignment: .leading, spacing: 2) {
                Text(transaction.name)
                    .font(.subheadline)
                    .foregroundColor(.michiTextPrimary)
                Text(transaction.date.formatted(as: "MMM d, yyyy"))
                    .font(.caption)
                    .foregroundColor(.michiTextSecondary)
            }
            
            Spacer()
            
            // Amount
            Text(transaction.amount.asCurrency())
                .font(.subheadline)
                .fontWeight(.medium)
                .foregroundColor(transaction.amount < 0 ? .michiSuccess : .michiError)
        }
        .padding(.vertical, 4)
    }
}

// MARK: - Preview
#Preview {
    DashboardView()
}
