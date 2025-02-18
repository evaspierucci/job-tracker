import Foundation

enum SortOrder {
    case ascending
    case descending
    
    var systemImageName: String {
        switch self {
        case .ascending: return "chevron.up"
        case .descending: return "chevron.down"
        }
    }
    
    mutating func toggle() {
        self = self == .ascending ? .descending : .ascending
    }
}

enum SortOption: String {
    case jobTitle = "Job Title"
    case company = "Company"
    case date = "Date"
    case status = "Status"
    case location = "Location"
    
    func compare(_ a: JobApplication, _ b: JobApplication, order: SortOrder) -> Bool {
        switch self {
        case .jobTitle:
            return order == .ascending ? 
                a.jobTitle.localizedCompare(b.jobTitle) == .orderedAscending :
                a.jobTitle.localizedCompare(b.jobTitle) == .orderedDescending
        case .company:
            return order == .ascending ? 
                a.companyName.localizedCompare(b.companyName) == .orderedAscending :
                a.companyName.localizedCompare(b.companyName) == .orderedDescending
        case .date:
            return order == .ascending ? 
                a.applicationDate < b.applicationDate :
                a.applicationDate > b.applicationDate
        case .status:
            return order == .ascending ? 
                a.status.sortOrder < b.status.sortOrder :
                a.status.sortOrder > b.status.sortOrder
        case .location:
            return order == .ascending ? 
                a.location.displayString.localizedCompare(b.location.displayString) == .orderedAscending :
                a.location.displayString.localizedCompare(b.location.displayString) == .orderedDescending
        }
    }
} 