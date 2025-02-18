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
        
        // Add the new application with proper animation timing
        withAnimation(.easeInOut(duration: 0.2)) {
            applications.append(newApplication)
        }
    }
    
    // Update the delete method to handle animations properly
    func deleteApplication(at offsets: IndexSet) {
        withAnimation(.easeInOut(duration: 0.2)) {
            applications.remove(atOffsets: offsets)
        }
    }
    
    // Add safety check method
    func isValidIndex(_ index: Int) -> Bool {
        return applications.indices.contains(index)
    }
} 