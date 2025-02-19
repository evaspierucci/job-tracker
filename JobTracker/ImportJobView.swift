import SwiftUI

struct ImportJobView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var jobLink: String = ""
    @State private var isProcessing = false
    @State private var errorMessage: String?
    
    var body: some View {
        VStack(spacing: 16) {
            Text("Import Job Posting")
                .font(.headline)
            
            TextField("Paste job posting URL", text: $jobLink)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 400)
            
            if let error = errorMessage {
                Text(error)
                    .foregroundColor(.red)
                    .font(.caption)
            }
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Import") {
                    createJobFromLink()
                }
                .keyboardShortcut(.return)
                .disabled(jobLink.isEmpty || isProcessing)
            }
        }
        .padding()
        .frame(width: 450)
    }
    
    private func createJobFromLink() {
        guard !jobLink.isEmpty else { return }
        
        // For now, just create a new job with the link
        viewModel.addApplicationWithLink(jobLink)
        dismiss()
    }
} 