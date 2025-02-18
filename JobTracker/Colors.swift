import SwiftUI
#if os(iOS)
import UIKit
#else
import AppKit
#endif

extension Color {
    // Base colors for application status
    static let statusDone = Color(red: 0.3, green: 0.85, blue: 0.4)
    static let statusWorking = Color(red: 0.95, green: 0.7, blue: 0.3)
    static let statusStuck = Color(red: 0.95, green: 0.3, blue: 0.3)
    
    // Progress and background colors
    static let progressBar = Color.blue.opacity(0.3)
    static let progressBarBackground = Color(white: 0.9)
    static let tableBackground = Color(white: 0.98)
    
    // New color definitions for enhanced UI
    #if os(iOS)
    static let rowBackground = Color(UIColor.systemGray6)
    static let darkRowBackground = Color(UIColor.systemGray4)
    #else
    static let rowBackground = Color(NSColor.windowBackgroundColor)
    static let darkRowBackground = Color(NSColor.darkGray)
    #endif
    
    static let gradientStart = Color.white
    static let gradientEnd = Color.gray.opacity(0.1)
    
    // Status colors for job applications
    static let statusOffer = Color.green.opacity(0.85)
    static let statusInterviewing = Color.yellow.opacity(0.85)
    static let statusApplied = Color.blue.opacity(0.85)
    static let statusRejected = Color.red.opacity(0.85)
    
    // Background colors for status pills
    static let statusOfferBg = Color.green.opacity(0.2)
    static let statusInterviewingBg = Color.yellow.opacity(0.2)
    static let statusAppliedBg = Color.blue.opacity(0.2)
    static let statusRejectedBg = Color.red.opacity(0.2)
    
    // Row styling
    static let rowFill = Color.white.opacity(0.95)
    #if os(iOS)
    static let rowShadow = Color.black.opacity(0.1)
    static let rowHover = Color(UIColor.systemGray6)
    #else
    static let rowShadow = Color.black.opacity(0.08)
    static let rowHover = Color(NSColor.selectedControlColor).opacity(0.3)
    #endif
    
    // Text colors
    static let primaryText = Color.primary
    static let secondaryText = Color.secondary
    
    // Button and interactive elements
    static let addButton = Color.blue
    static let deleteButton = Color.red.opacity(0.8)
    
    // Dashboard background gradient
    static let dashboardGradientStart = Color.white
    static let dashboardGradientEnd = Color.gray.opacity(0.05)
}

// End of file. No additional code.
