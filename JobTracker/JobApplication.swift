import Foundation
import SwiftUI
import CoreData

struct JobApplication: Identifiable {
    let id: UUID
    var jobTitle: String
    var companyName: String
    var applicationDate: Date
    var status: ApplicationStatus
    var applicationLink: String
    var notes: String
    
    enum ApplicationStatus: String, CaseIterable {
        case applied = "Applied"
        case interviewing = "Interviewing"
        case offerReceived = "Offer Received"
        case rejected = "Rejected"
        
        var color: Color {
            switch self {
            case .applied: return .blue
            case .interviewing: return .yellow
            case .offerReceived: return .green
            case .rejected: return .red
            }
        }
    }
    
    init(entity: JobApplicationEntity) {
        self.id = entity.id ?? UUID()
        self.jobTitle = entity.jobTitle ?? ""
        self.companyName = entity.companyName ?? ""
        self.applicationDate = entity.applicationDate ?? Date()
        self.status = ApplicationStatus(rawValue: entity.status ?? "Applied") ?? .applied
        self.applicationLink = entity.applicationLink ?? ""
        self.notes = entity.notes ?? ""
    }
    
    init(id: UUID = UUID(), jobTitle: String, companyName: String, applicationDate: Date, 
         status: ApplicationStatus, applicationLink: String, notes: String) {
        self.id = id
        self.jobTitle = jobTitle
        self.companyName = companyName
        self.applicationDate = applicationDate
        self.status = status
        self.applicationLink = applicationLink
        self.notes = notes
    }
}
