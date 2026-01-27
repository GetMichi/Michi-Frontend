//
//  Extensions.swift
//  MyApp
//
//  Created on 2/1/26.
//

import SwiftUI

// MARK: - View Extensions
extension View {
    /// Applies a card style with shadow and rounded corners
    func cardStyle() -> some View {
        self
            .background(Color(.systemBackground))
            .clipShape(RoundedRectangle(cornerRadius: Config.UI.cornerRadius))
            .shadow(color: .black.opacity(0.1), radius: 5, x: 0, y: 2)
    }
}

// MARK: - Color Extensions
extension Color {
    static let customBackground = Color(.systemGroupedBackground)
    static let customPrimary = Color.blue
    static let customSecondary = Color.gray
}

// MARK: - String Extensions
extension String {
    var isValidEmail: Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: self)
    }
}

// MARK: - Date Extensions
extension Date {
    func formatted(as format: String) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        return formatter.string(from: self)
    }
}
