import Foundation
import SwiftUI

struct JobApplication: Identifiable, Codable {
    var id = UUID()
    var jobTitle: String
    var companyName: String
    var applicationDate: Date
    var status: ApplicationStatus
    var applicationLink: String
    var notes: String
    
    enum ApplicationStatus: String, Codable, CaseIterable {
        case applied = "Applied"
        case interviewing = "Interviewing"
        case offerReceived = "Offer Received"
        case rejected = "Rejected"
        
        var color: Color {
            switch self {
            case .applied: return .blue
            case .interviewing: return .orange
            case .offerReceived: return .green
            case .rejected: return .red
            }
        }
    }
} 