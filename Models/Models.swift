//
//  Models.swift
//  All the app data structures
//
//  Created by Jennifer Shi on 2026-02-07.
//

import Foundation

// MARK: - User
struct User: Codable, Identifiable {
    let id: String
    let email: String
    let name: String?
    let createdAt: Date
    let preferences: UserPreferences?
    
    enum CodingKeys: String, CodingKey {
        case id
        case email
        case name
        case createdAt = "created_at"
        case preferences
    }
}

// MARK: - User Preferences
struct UserPreferences: Codable {
    let chatTone: ChatTone
    let currency: String
    let notificationsEnabled: Bool
    
    enum CodingKeys: String, CodingKey {
        case chatTone = "chat_tone"
        case currency
        case notificationsEnabled = "notifications_enabled"
    }
}

enum ChatTone: String, Codable, CaseIterable {
    case supportive
    case direct
    case neutral
    
    var displayName: String {
        switch self {
        case .supportive: return "Supportive"
        case .direct: return "Direct"
        case .neutral: return "Neutral"
        }
    }
}

// MARK: - Transaction
struct Transaction: Codable, Identifiable {
    let id: String
    let accountId: String
    let amount: Double
    let name: String
    let merchantName: String?
    let category: [String]
    let date: Date
    let pending: Bool
    let transactionType: TransactionType?
    
    enum CodingKeys: String, CodingKey {
        case id
        case accountId = "account_id"
        case amount
        case name
        case merchantName = "merchant_name"
        case category
        case date
        case pending
        case transactionType = "transaction_type"
    }
}

enum TransactionType: String, Codable {
    case income
    case expense
    case transfer
}

// MARK: - Account
struct Account: Codable, Identifiable {
    let id: String
    let name: String
    let officialName: String?
    let type: String
    let subtype: String?
    let currentBalance: Double?
    let availableBalance: Double?
    let institution: String?
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case officialName = "official_name"
        case type
        case subtype
        case currentBalance = "current_balance"
        case availableBalance = "available_balance"
        case institution
    }
}

// MARK: - Budget
struct Budget: Codable, Identifiable {
    let id: String
    let userId: String
    let category: String
    let allocatedAmount: Double
    let spentAmount: Double
    let period: BudgetPeriod
    let startDate: Date
    let endDate: Date
    
    var remainingAmount: Double {
        allocatedAmount - spentAmount
    }
    
    var percentageUsed: Double {
        guard allocatedAmount > 0 else { return 0 }
        return (spentAmount / allocatedAmount) * 100
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case category
        case allocatedAmount = "allocated_amount"
        case spentAmount = "spent_amount"
        case period
        case startDate = "start_date"
        case endDate = "end_date"
    }
}

enum BudgetPeriod: String, Codable {
    case weekly
    case biweekly
    case monthly
    case yearly
}

// MARK: - Financial Goal
struct FinancialGoal: Codable, Identifiable {
    let id: String
    let userId: String
    let name: String
    let targetAmount: Double
    let currentAmount: Double
    let targetDate: Date?
    let category: GoalCategory
    let createdAt: Date
    
    var progress: Double {
        guard targetAmount > 0 else { return 0 }
        return (currentAmount / targetAmount) * 100
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case userId = "user_id"
        case name
        case targetAmount = "target_amount"
        case currentAmount = "current_amount"
        case targetDate = "target_date"
        case category
        case createdAt = "created_at"
    }
}

enum GoalCategory: String, Codable, CaseIterable {
    case emergency
    case vacation
    case purchase
    case debtPayoff = "debt_payoff"
    case investment
    case other
    
    var displayName: String {
        switch self {
        case .emergency: return "Emergency Fund"
        case .vacation: return "Vacation"
        case .purchase: return "Major Purchase"
        case .debtPayoff: return "Debt Payoff"
        case .investment: return "Investment"
        case .other: return "Other"
        }
    }
    
    var icon: String {
        switch self {
        case .emergency: return "shield.fill"
        case .vacation: return "airplane"
        case .purchase: return "cart.fill"
        case .debtPayoff: return "creditcard.fill"
        case .investment: return "chart.line.uptrend.xyaxis"
        case .other: return "star.fill"
        }
    }
}

// MARK: - Chat Message
struct ChatMessage: Identifiable, Equatable {
    let id: String
    let content: String
    let sender: MessageSender
    let timestamp: Date
    let isStreaming: Bool
    
    init(id: String = UUID().uuidString, content: String, sender: MessageSender, timestamp: Date = Date(), isStreaming: Bool = false) {
        self.id = id
        self.content = content
        self.sender = sender
        self.timestamp = timestamp
        self.isStreaming = isStreaming
    }
}

enum MessageSender: Equatable {
    case user
    case ai
}

// MARK: - Insight
struct Insight: Identifiable {
    let id: String
    let title: String
    let description: String
    let category: InsightCategory
    let actionable: Bool
    let createdAt: Date
    
    init(id: String = UUID().uuidString, title: String, description: String, category: InsightCategory, actionable: Bool = false, createdAt: Date = Date()) {
        self.id = id
        self.title = title
        self.description = description
        self.category = category
        self.actionable = actionable
        self.createdAt = createdAt
    }
}

enum InsightCategory: String, CaseIterable {
    case spending
    case saving
    case budget
    case goal
    case warning
    
    var color: String {
        switch self {
        case .spending: return "orange"
        case .saving: return "green"
        case .budget: return "blue"
        case .goal: return "purple"
        case .warning: return "red"
        }
    }
    
    var icon: String {
        switch self {
        case .spending: return "cart.fill"
        case .saving: return "banknote.fill"
        case .budget: return "chart.pie.fill"
        case .goal: return "target"
        case .warning: return "exclamationmark.triangle.fill"
        }
    }
}
