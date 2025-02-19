import Foundation
import CoreData
import SwiftUI

@MainActor
class JobApplicationViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    @Published var applications: [JobApplication] = []
    @Published var searchText = ""
    @Published var selectedStatus: JobApplication.ApplicationStatus?
    
    @Published var currentSort: SortOption = .date
    @Published var sortOrder: SortOrder = .descending
    @Published var selectedStatuses: Set<JobApplication.ApplicationStatus>
    @Published var selectedLocations: Set<String> = []
    @Published var dateRange: ClosedRange<Date>?
    
    @Published var selectedJobTitles: Set<String> = []
    @Published var selectedCompanies: Set<String> = []
    
    var filteredApplications: [JobApplication] {
        applications
            .filter { application in
                let matchesSearch = searchText.isEmpty || 
                    application.jobTitle.localizedCaseInsensitiveContains(searchText) ||
                    application.companyName.localizedCaseInsensitiveContains(searchText)
                
                let matchesStatus = (!selectedStatuses.isEmpty && selectedStatuses.contains(application.status)) ||
                    (selectedStatuses.isEmpty && isActiveStatus(application.status))
                
                let matchesLocation = selectedLocations.isEmpty || 
                    selectedLocations.contains(application.location.displayString)
                
                let matchesJobTitle = selectedJobTitles.isEmpty || 
                    selectedJobTitles.contains(application.jobTitle)
                
                let matchesCompany = selectedCompanies.isEmpty || 
                    selectedCompanies.contains(application.companyName)
                
                let matchesDate = dateRange.map { range in
                    range.contains(application.applicationDate)
                } ?? true
                
                return matchesSearch && matchesStatus && matchesLocation && 
                       matchesJobTitle && matchesCompany && matchesDate
            }
            .sorted { a, b in
                currentSort.compare(a, b, order: sortOrder)
            }
    }
    
    var uniqueLocations: Set<String> {
        Set(applications.map { $0.location.displayString })
    }
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
        self.selectedStatuses = Set(JobApplication.ApplicationStatus.allCases.filter { 
            [.identified, .applied, .interviewing, .accepted].contains($0)
        })
        loadApplications()
    }
    
    private func loadApplications() {
        let request = NSFetchRequest<JobApplicationEntity>(entityName: "JobApplicationEntity")
        request.sortDescriptors = [NSSortDescriptor(keyPath: \JobApplicationEntity.applicationDate, ascending: false)]
        
        do {
            let entities = try viewContext.fetch(request)
            applications = entities.map { entity in
                JobApplication(
                    id: entity.id ?? UUID(),
                    jobTitle: entity.jobTitle ?? "",
                    companyName: entity.companyName ?? "",
                    applicationDate: entity.applicationDate ?? Date(),
                    status: JobApplication.ApplicationStatus(rawValue: entity.status ?? "") ?? .applied,
                    applicationLink: entity.applicationLink ?? "",
                    location: JobApplication.Location.fromString(entity.location ?? "Remote"),
                    notes: entity.notes ?? ""
                )
            }
        } catch {
            print("Error fetching applications: \(error)")
        }
    }
    
    func addApplication() {
        let entity = JobApplicationEntity(context: viewContext)
        entity.id = UUID()
        entity.jobTitle = ""
        entity.companyName = ""
        entity.applicationDate = Date()
        entity.status = JobApplication.ApplicationStatus.identified.rawValue
        entity.applicationLink = ""
        entity.location = "Remote"
        entity.locationType = "remote"
        entity.notes = ""
        
        save()
        loadApplications()
    }
    
    func updateApplication(_ application: JobApplication) {
        let request = NSFetchRequest<JobApplicationEntity>(entityName: "JobApplicationEntity")
        request.predicate = NSPredicate(format: "id == %@", application.id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entity = entities.first {
                entity.jobTitle = application.jobTitle
                entity.companyName = application.companyName
                entity.applicationDate = application.applicationDate
                entity.status = application.status.rawValue
                entity.applicationLink = application.applicationLink
                entity.notes = application.notes
                
                switch application.location {
                case .remote:
                    entity.location = "Remote"
                    entity.locationType = "remote"
                case .city(let name):
                    entity.location = name
                    entity.locationType = "city"
                case .other(let custom):
                    entity.location = custom
                    entity.locationType = "other"
                }
                
                save()
                loadApplications()
            }
        } catch {
            print("Error updating application: \(error)")
        }
    }
    
    func deleteApplication(id: UUID) {
        let request = NSFetchRequest<JobApplicationEntity>(entityName: "JobApplicationEntity")
        request.predicate = NSPredicate(format: "id == %@", id as CVarArg)
        
        do {
            let entities = try viewContext.fetch(request)
            if let entity = entities.first {
                viewContext.delete(entity)
                save()
                loadApplications()
            }
        } catch {
            print("Error deleting application: \(error)")
        }
    }
    
    private func save() {
        do {
            try viewContext.save()
            print("Successfully saved context with status updates")
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return applications.indices.contains(index)
    }
    
    func toggleSort(_ option: SortOption) {
        if currentSort == option {
            sortOrder.toggle()
        } else {
            currentSort = option
            sortOrder = .ascending
        }
    }
    
    func resetFilters() {
        searchText = ""
        selectedStatuses = Set(JobApplication.ApplicationStatus.allCases.filter { 
            [.identified, .applied, .interviewing, .accepted].contains($0)
        })
        selectedLocations.removeAll()
        selectedJobTitles.removeAll()
        selectedCompanies.removeAll()
        dateRange = nil
    }
    
    private func isActiveStatus(_ status: JobApplication.ApplicationStatus) -> Bool {
        return [.identified, .applied, .interviewing, .accepted].contains(status)
    }
} 