import SwiftUI

enum TableLayout {
    static let jobTitle: CGFloat = 220    // Wider for job titles
    static let company: CGFloat = 180     // Good width for company names
    static let date: CGFloat = 150        // Increased for "Application Date"
    static let status: CGFloat = 100      // Narrower for status pills
    static let location: CGFloat = 200    // Wider for location field (no icon)
    static let link: CGFloat = 160        // Adjusted for links
    static let notes: CGFloat = 200       // Wide for notes
    static let actions: CGFloat = 40      // Delete button
    
    static let spacing: CGFloat = 16
    static let horizontalPadding: CGFloat = 8
} 