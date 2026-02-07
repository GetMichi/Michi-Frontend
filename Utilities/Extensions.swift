//
//  Extensions.swift
//  Contains all Swift extensions
//
//  Created by Jennifer Shi on 2026-02-07.
//

import SwiftUI

// MARK: - View Extensions
extension View {
    /// Applies Michi card style with shadow and rounded corners
    func michiCardStyle() -> some View {
        self
            .background(Color.michiCardBackground)
            .clipShape(RoundedRectangle(cornerRadius: Config.UI.cornerRadius))
            .shadow(color: Color.black.opacity(0.2), radius: Config.UI.cardShadowRadius, x: 0, y: 2)
    }
    
    /// Applies standard Michi padding
    func michiPadding() -> some View {
        self.padding(Config.UI.defaultPadding)
    }
    
    /// Hide keyboard
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

// MARK: - Color Extensions
extension Color {
    // Primary brand colors
    static let michiPrimary = Color("Primary")
    static let michiSecondary = Color("Secondary")
    static let michiAccent = Color("Accent")
    
    // Background colors
    static let michiBackground = Color("Background")
    static let michiCardBackground = Color("CardBackground")
    static let michiSurface = Color("Surface")
    
    // Semantic colors
    static let michiSuccess = Color("Success")
    static let michiWarning = Color("Warning")
    static let michiError = Color("Error")
    static let michiInfo = Color("Info")
    
    // Text colors
    static let michiTextPrimary = Color("TextPrimary")
    static let michiTextSecondary = Color("TextSecondary")
    static let michiTextTertiary = Color("TextTertiary")
    
    // Chart colors
    static let michiChartBlue = Color("ChartBlue")
    static let michiChartGreen = Color("ChartGreen")
    static let michiChartOrange = Color("ChartOrange")
    static let michiChartPurple = Color("ChartPurple")
    static let michiChartRed = Color("ChartRed")
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
    
    /// Truncates string to specified length with ellipsis
    func truncated(to length: Int, trailing: String = "...") -> String {
        if self.count > length {
            return String(self.prefix(length)) + trailing
        }
        return self
    }
}

// MARK: - Date Extensions
extension Date {
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
    
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
    
    var endOfDay: Date {
        var components = DateComponents()
        components.day = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfDay) ?? self
    }
    
    var startOfMonth: Date {
        let components = Calendar.current.dateComponents([.year, .month], from: self)
        return Calendar.current.date(from: components) ?? self
    }
    
    var endOfMonth: Date {
        var components = DateComponents()
        components.month = 1
        components.second = -1
        return Calendar.current.date(byAdding: components, to: startOfMonth) ?? self
    }
    
    func isInSameDay(as date: Date) -> Bool {
        Calendar.current.isDate(self, inSameDayAs: date)
    }
    
    func isInSameMonth(as date: Date) -> Bool {
        Calendar.current.isDate(self, equalTo: date, toGranularity: .month)
    }
}

// MARK: - Double Extensions
extension Double {
    /// Formats as currency with proper symbol
    func asCurrency(code: String = "USD") -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = code
        return formatter.string(from: NSNumber(value: self)) ?? "$\(String(format: "%.2f", self))"
    }
    
    /// Formats as percentage
    func asPercentage(decimals: Int = 1) -> String {
        String(format: "%.\(decimals)f%%", self)
    }
    
    /// Rounds to specified decimal places
    func rounded(toPlaces places: Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return (self * divisor).rounded() / divisor
    }
}

// MARK: - Array Extensions
extension Array where Element == Transaction {
    /// Groups transactions by date
    func groupedByDate() -> [Date: [Transaction]] {
        Dictionary(grouping: self) { transaction in
            transaction.date.startOfDay
        }
    }
    
    /// Groups transactions by category
    func groupedByCategory() -> [String: [Transaction]] {
        Dictionary(grouping: self) { transaction in
            transaction.category.first ?? "Other"
        }
    }
    
    /// Calculates total amount
    var totalAmount: Double {
        reduce(0) { $0 + $1.amount }
    }
}

// MARK: - Binding Extensions
extension Binding {
    /// Creates a binding with a custom onChange handler
    func onChange(_ handler: @escaping (Value) -> Void) -> Binding<Value> {
        Binding(
            get: { self.wrappedValue },
            set: { newValue in
                self.wrappedValue = newValue
                handler(newValue)
            }
        )
    }
}
