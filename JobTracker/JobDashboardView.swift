import SwiftUI
#if os(macOS)
import AppKit
#else
import UIKit
#endif

struct JobDashboardView: View {
    @StateObject private var viewModel = JobApplicationViewModel()
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Header
                HeaderRow()
                    .padding(.horizontal)
                    .background(colorScheme == .dark ? Color(white: 0.1) : .tableBackground)
                
                // Job Applications List
                List {
                    ForEach($viewModel.applications) { $application in
                        JobApplicationRow(application: $application)
                            .listRowInsets(EdgeInsets(top: 4, leading: 8, bottom: 4, trailing: 8))
                            .listRowBackground(colorScheme == .dark ? Color(white: 0.15) : .white)
                    }
                    .onDelete(perform: viewModel.deleteApplication)
                }
                .listStyle(.plain)
                .background(colorScheme == .dark ? Color(white: 0.1) : .tableBackground)
            }
            .navigationTitle("Job Applications")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.addApplication) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                #else
                ToolbarItem {
                    Button(action: viewModel.addApplication) {
                        Image(systemName: "plus.circle.fill")
                            .foregroundColor(.blue)
                    }
                }
                #endif
            }
        }
    }
}

struct StatusView: View {
    let status: JobApplication.ApplicationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.subheadline)
            .foregroundColor(.white)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(status.color)
            .cornerRadius(6)
    }
}

struct ProgressBar: View {
    let progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .fill(Color.progressBarBackground)
                
                Rectangle()
                    .fill(Color.progressBar)
                    .frame(width: geometry.size.width * progress)
            }
        }
        .frame(height: 8)
        .cornerRadius(4)
    }
}

struct HeaderRow: View {
    var body: some View {
        HStack(spacing: 16) {
            Text("Job Title")
                .frame(width: 150, alignment: .leading)
            Text("Company")
                .frame(width: 150, alignment: .leading)
            Text("Date")
                .frame(width: 100, alignment: .leading)
            Text("Status")
                .frame(width: 120, alignment: .leading)
            Text("Progress")
                .frame(width: 100, alignment: .leading)
            Text("Notes")
                .frame(minWidth: 100, alignment: .leading)
        }
        .padding(.vertical, 12)
        .font(.headline)
    }
}

struct JobApplicationRow: View {
    @Binding var application: JobApplication
    
    var body: some View {
        HStack(spacing: 16) {
            TextField("Job Title", text: $application.jobTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150, alignment: .leading)
            
            TextField("Company", text: $application.companyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: 150, alignment: .leading)
            
            DatePicker("", selection: $application.applicationDate, displayedComponents: .date)
                .frame(width: 100)
                .labelsHidden()
            
            Menu {
                ForEach(JobApplication.ApplicationStatus.allCases, id: \.self) { status in
                    Button(action: { application.status = status }) {
                        Text(status.rawValue)
                    }
                }
            } label: {
                StatusView(status: application.status)
                    .frame(width: 120, alignment: .leading)
            }
            
            ProgressBar(progress: 0.6)
                .frame(width: 100, height: 8)
            
            TextField("Notes", text: $application.notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(minWidth: 100)
        }
        .padding(.vertical, 8)
    }
    
    private func openURL(_ urlString: String) {
        guard let url = URL(string: urlString) else { return }
        #if os(iOS)
        UIApplication.shared.open(url)
        #else
        NSWorkspace.shared.open(url)
        #endif
    }
} 