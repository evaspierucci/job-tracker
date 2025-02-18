import Foundation
import CoreData

@objc(JobApplicationEntity)
public class JobApplicationEntity: NSManagedObject {
    @NSManaged public var id: UUID?
    @NSManaged public var jobTitle: String?
    @NSManaged public var companyName: String?
    @NSManaged public var applicationDate: Date?
    @NSManaged public var status: String?
    @NSManaged public var applicationLink: String?
    @NSManaged public var notes: String?
    @NSManaged public var location: String?
    @NSManaged public var locationType: String? // "remote", "city", or "other"
}

extension JobApplicationEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<JobApplicationEntity> {
        return NSFetchRequest<JobApplicationEntity>(entityName: "JobApplicationEntity")
    }
} 