import SwiftUI

extension Color {
    static let tableBackground = Color(white: 0.98)
    static let statusDone = Color("StatusDone", default: Color(red: 0.3, green: 0.85, blue: 0.4))
    static let statusWorking = Color("StatusWorking", default: Color(red: 0.95, green: 0.7, blue: 0.3))
    static let statusStuck = Color("StatusStuck", default: Color(red: 0.95, green: 0.3, blue: 0.3))
    static let progressBar = Color.blue.opacity(0.3)
    static let progressBarBackground = Color(white: 0.9)
} 