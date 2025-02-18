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
        self.location = Location.fromString(entity.location ?? "Remote")
        self.notes = entity.notes ?? ""
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
