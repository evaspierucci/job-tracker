import SwiftUI

enum TableLayout {
    static let jobTitle: CGFloat = 220    // Wider for job titles
    static let company: CGFloat = 160     // Good width for company names
    static let date: CGFloat = 140        // Enough for "Application\nDate"
    static let status: CGFloat = 100       // Narrower, just enough for status pills
    static let location: CGFloat = 120    // Wider for longer city names
    static let link: CGFloat = 160        // Adequate for URLs
    static let notes: CGFloat = 200       // Wide for notes
    static let actions: CGFloat = 40      // Delete button
    
    static let spacing: CGFloat = 2       // Space between columns
    static let horizontalPadding: CGFloat = 2
    static let scrollbarPadding: CGFloat = 16  // Added padding for scrollbar
} 