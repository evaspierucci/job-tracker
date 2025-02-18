import Foundation
import SwiftUI

@MainActor
class JobApplicationViewModel: ObservableObject {
    @Published var applications: [JobApplication] = []
    
    init() {
        loadApplications()
    }
    
    private func loadApplications() {
        // TODO: Implement data loading from persistence
        // For now, adding sample data
        applications = [
            JobApplication(jobTitle: "iOS Developer", 
                         companyName: "Tech Corp", 
                         applicationDate: Date(), 
                         status: .applied,
                         applicationLink: "https://techcorp.com/jobs",
                         notes: "Initial application submitted")
        ]
    }
    
    func addApplication() {
        let newApplication = JobApplication(jobTitle: "", 
                                          companyName: "", 
                                          applicationDate: Date(), 
                                          status: .applied,
                                          applicationLink: "",
                                          notes: "")
        applications.append(newApplication)
    }
    
    func deleteApplication(at offsets: IndexSet) {
        applications.remove(atOffsets: offsets)
    }
} 