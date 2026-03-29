import SwiftUI

enum AppTheme {
    static let accent = Color(red: 0.93, green: 0.36, blue: 0.20)
    static let accentSoft = Color(red: 0.98, green: 0.56, blue: 0.34)
    static let cream = Color(red: 0.99, green: 0.96, blue: 0.90)
    static let ink = Color(red: 0.16, green: 0.12, blue: 0.10)
    static let card = Color.white.opacity(0.8)
    static let muted = Color(red: 0.43, green: 0.36, blue: 0.32)

    static let background = LinearGradient(
        colors: [
            Color(red: 1.00, green: 0.97, blue: 0.88),
            Color(red: 0.98, green: 0.86, blue: 0.72),
            Color(red: 0.96, green: 0.72, blue: 0.56)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )

    static let hero = LinearGradient(
        colors: [
            Color(red: 0.26, green: 0.18, blue: 0.14),
            Color(red: 0.46, green: 0.22, blue: 0.12),
            Color(red: 0.86, green: 0.35, blue: 0.18)
        ],
        startPoint: .topLeading,
        endPoint: .bottomTrailing
    )
}
