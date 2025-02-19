import SwiftUI

struct ImportJobView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var jobLink: String = ""
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Import Job Posting")
                .font(.headline)
            
            TextField("Paste job posting URL", text: $jobLink)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 400)
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    jobLink = ""
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Import") {
                    createJobFromLink()
                }
                .keyboardShortcut(.return)
                .disabled(jobLink.isEmpty)
            }
        }
        .padding()
        .frame(width: 450)
    }
    
    private func createJobFromLink() {
        guard !jobLink.isEmpty else { return }
        viewModel.addApplicationWithLink(jobLink)
        dismiss()
    }
} 