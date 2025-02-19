import SwiftUI

enum TableLayout {
    static let jobTitle: CGFloat = 220    // Wider for job titles
    static let company: CGFloat = 160     // Good width for company names
    static let date: CGFloat = 140        // Enough for "Application\nDate"
    static let status: CGFloat = 100       // Narrower, just enough for status pills
    static let location: CGFloat = 120    // Wider for longer city names
    static let link: CGFloat = 160        // Adequate for URLs
    static let jobDescription: CGFloat = 300    // Wide for detailed descriptions
    static let datePosted: CGFloat = 140       // Same as application date
    static let salaryRange: CGFloat = 160      // Enough for salary formats
    static let qualifications: CGFloat = 300    // Wide for requirement lists
    static let companyDescription: CGFloat = 300 // Wide for company details
    static let notes: CGFloat = 200       // Wide for notes
    static let actions: CGFloat = 40      // Delete button
    
    static let spacing: CGFloat = 2       // Space between columns
    static let horizontalPadding: CGFloat = 2
    static let scrollbarPadding: CGFloat = 16  // Added padding for scrollbar
} 