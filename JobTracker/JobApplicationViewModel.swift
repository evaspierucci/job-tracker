import Foundation
import CoreData
import SwiftUI

@MainActor
class JobApplicationViewModel: ObservableObject {
    private let viewContext: NSManagedObjectContext
    @Published var applications: [JobApplication] = []
    
    init(context: NSManagedObjectContext = PersistenceController.shared.container.viewContext) {
        self.viewContext = context
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
                    status: JobApplication.ApplicationStatus(rawValue: entity.status ?? "Applied") ?? .applied,
                    applicationLink: entity.applicationLink ?? "",
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
        entity.status = JobApplication.ApplicationStatus.applied.rawValue
        entity.applicationLink = ""
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
                save()
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
        } catch {
            print("Error saving context: \(error)")
        }
    }
    
    func isValidIndex(_ index: Int) -> Bool {
        return applications.indices.contains(index)
    }
} 