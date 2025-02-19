import SwiftUI

struct ImportJobView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var jobLink: String = ""
    @State private var isLoading = false
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
            
            if isLoading {
                ProgressView()
                    .scaleEffect(0.8)
            }
            
            HStack(spacing: 12) {
                Button("Cancel") {
                    jobLink = ""
                    dismiss()
                }
                .keyboardShortcut(.escape)
                
                Button("Import") {
                    Task {
                        await importJob()
                    }
                }
                .keyboardShortcut(.return)
                .disabled(jobLink.isEmpty || isLoading)
            }
        }
        .padding()
        .frame(width: 450)
    }
    
    private func importJob() async {
        guard !jobLink.isEmpty else { return }
        
        isLoading = true
        errorMessage = nil
        
        do {
            _ = try await WebScrapingService.shared.fetchWebpage(url: jobLink)
            // For now, just create job with link (we'll parse HTML in next step)
            viewModel.addApplicationWithLink(jobLink)
            dismiss()
        } catch let error as ScrapingError {
            errorMessage = error.description
        } catch {
            errorMessage = "An unexpected error occurred"
        }
        
        isLoading = false
    }
} 
