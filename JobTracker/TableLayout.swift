import SwiftUI

enum TableLayout {
    static let defaultWidth: CGFloat = 150
    static let minimumWidth: CGFloat = 60
    
    // Default column widths
    static let jobTitle: CGFloat = 220    // Wider for job titles
    static let company: CGFloat = 180     // Good width for company names
    static let date: CGFloat = 140        // Enough for "Application\nDate"
    static let status: CGFloat = 85       // Narrower, just fits status text
    static let location: CGFloat = 220    // Wider for full city names
    static let link: CGFloat = 160        // Adequate for URLs
    static let notes: CGFloat = 200       // Wide for notes
    static let actions: CGFloat = 40      // Fixed width for delete button
    
    static let spacing: CGFloat = 16
    static let contentPadding: CGFloat = 8
} 