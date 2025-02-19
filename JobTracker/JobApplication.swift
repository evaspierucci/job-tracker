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
    var location: Location
    var notes: String
    
    // New optional fields
    var jobDescription: String?
    var datePosted: Date?
    var salaryRange: String?
    var requiredQualifications: String?
    var companyDescription: String?
    
    enum Location: Equatable {
        case remote
        case city(String)
        case other(String)
        
        var displayString: String {
            switch self {
            case .remote: return "Remote"
            case .city(let name): return name
            case .other(let custom): return custom
            }
        }
        
        static func fromString(_ string: String) -> Location {
            if string == "Remote" { return .remote }
            return .city(string)
        }
    }
    
    enum ApplicationStatus: String, CaseIterable {
        case identified = "Identified"
        case applied = "Applied"
        case interviewing = "Interviewing"
        case accepted = "Accepted"
        case rejected = "Rejected"
        case archived = "Archived"
        
        var sortOrder: Int {
            switch self {
            case .identified: return 0
            case .applied: return 1
            case .interviewing: return 2
            case .accepted: return 3
            case .rejected: return 4
            case .archived: return 5
            }
        }
        
        var backgroundColor: Color {
            switch self {
            case .applied: return Color(red: 0.9, green: 0.95, blue: 1.0)    // Light blue
            case .identified: return Color(red: 0.95, green: 0.95, blue: 0.95) // Light gray
            case .interviewing: return Color(red: 1.0, green: 0.95, blue: 0.8) // Light yellow
            case .accepted: return Color(red: 0.9, green: 1.0, blue: 0.9)    // Light green
            case .rejected: return Color(red: 1.0, green: 0.9, blue: 0.9)    // Light red
            case .archived: return Color(red: 0.92, green: 0.92, blue: 0.92) // Light gray for archived
            }
        }
        
        var iconColor: Color {
            switch self {
            case .applied: return Color.blue
            case .identified: return Color.gray
            case .interviewing: return Color.orange
            case .accepted: return Color.green
            case .rejected: return Color.red
            case .archived: return Color(white: 0.5)  // Medium gray for archived
            }
        }
    }
    
    init(entity: JobApplicationEntity) {
        self.id = entity.id ?? UUID()
        self.jobTitle = entity.jobTitle ?? ""
        self.companyName = entity.companyName ?? ""
        self.applicationDate = entity.applicationDate ?? Date()
        self.status = ApplicationStatus(rawValue: entity.status ?? "") ?? .applied
        self.applicationLink = entity.applicationLink ?? ""
        self.location = Location.fromString(entity.location ?? "Remote")
        self.notes = entity.notes ?? ""
        
        // Initialize new fields from entity
        self.jobDescription = entity.jobDescription
        self.datePosted = entity.datePosted
        self.salaryRange = entity.salaryRange
        self.requiredQualifications = entity.requiredQualifications
        self.companyDescription = entity.companyDescription
    }
    
    init(id: UUID = UUID(), 
         jobTitle: String, 
         companyName: String, 
         applicationDate: Date, 
         status: ApplicationStatus, 
         applicationLink: String,
         location: Location,
         notes: String) {
        self.id = id
        self.jobTitle = jobTitle
        self.companyName = companyName
        self.applicationDate = applicationDate
        self.status = status
        self.applicationLink = applicationLink
        self.location = location
        self.notes = notes
    }
}

extension JobApplication.Location {
    var isRemote: Bool {
        if case .remote = self {
            return true
        }
        return false
    }
}
