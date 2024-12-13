import SwiftUI

extension Color {
    static let theme = ColorTheme()
}

struct ColorTheme {
    // Base Colors
    let background = Color(red: 0.98, green: 0.98, blue: 0.98) // Light gray background
    let cardBackground = Color.white
    
    // Brand Colors
    let primary = Color(red: 0.33, green: 0.46, blue: 0.37) // Dark green
    
    // Text Colors
    let textPrimary = Color(red: 0.2, green: 0.2, blue: 0.2)
    let textSecondary = Color(red: 0.6, green: 0.6, blue: 0.6)
    
    // UI Elements
    let border = Color(red: 0.93, green: 0.93, blue: 0.93) // Light gray border
    
    // Shadows
    let shadowColor = Color.black.opacity(0.04)
    let shadowRadius: CGFloat = 24
    let shadowY: CGFloat = 2
} 