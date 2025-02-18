import Foundation
import SwiftUI

@MainActor
class JobApplicationViewModel: ObservableObject {
    @Published var applications: [JobApplication] = []
    
    init() {
        loadApplications()
    }
    
    private func loadApplications() {
        // Initialize with an empty array if no data exists
        applications = [
            JobApplication(
                jobTitle: "", 
                companyName: "", 
                applicationDate: Date(), 
                status: .applied,
                applicationLink: "",
                notes: ""
            )
        ]
    }
    
    func addApplication() {
        let newApplication = JobApplication(
            jobTitle: "", 
            companyName: "", 
            applicationDate: Date(), 
            status: .applied,
            applicationLink: "",
            notes: ""
        )
        withAnimation {
            applications.append(newApplication)
        }
    }
    
    func deleteApplication(at offsets: IndexSet) {
        withAnimation {
            applications.remove(atOffsets: offsets)
        }
    }
    
    // Add safety check method
    func isValidIndex(_ index: Int) -> Bool {
        return applications.indices.contains(index)
    }
} 