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
                    .background(colorScheme == .dark ? Color(white: 0.1) : Color(white: 0.95))
                
                // Job Applications List
                List {
                    ForEach($viewModel.applications) { $application in
                        JobApplicationRow(application: $application)
                    }
                    .onDelete(perform: viewModel.deleteApplication)
                }
                .listStyle(.plain)
            }
            .navigationTitle("Job Applications")
            .toolbar {
                #if os(iOS)
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: viewModel.addApplication) {
                        Image(systemName: "plus")
                    }
                }
                #else
                ToolbarItem {
                    Button(action: viewModel.addApplication) {
                        Image(systemName: "plus")
                    }
                }
                #endif
            }
        }
    }
}

struct HeaderRow: View {
    var body: some View {
        HStack {
            Text("Job Title")
                .frame(width: 150, alignment: .leading)
            Text("Company")
                .frame(width: 150, alignment: .leading)
            Text("Date")
                .frame(width: 100, alignment: .leading)
            Text("Status")
                .frame(width: 120, alignment: .leading)
            Text("Link")
                .frame(width: 100, alignment: .leading)
            Text("Notes")
                .frame(minWidth: 100, alignment: .leading)
        }
        .padding(.vertical, 10)
        .font(.headline)
    }
}

struct JobApplicationRow: View {
    @Binding var application: JobApplication
    
    var body: some View {
        HStack {
            TextField("Job Title", text: $application.jobTitle)
                .frame(width: 150, alignment: .leading)
            
            TextField("Company", text: $application.companyName)
                .frame(width: 150, alignment: .leading)
            
            DatePicker("", selection: $application.applicationDate, displayedComponents: .date)
                .frame(width: 100)
                .labelsHidden()
            
            Picker("Status", selection: $application.status) {
                ForEach(JobApplication.ApplicationStatus.allCases, id: \.self) { status in
                    Text(status.rawValue)
                        .tag(status)
                }
            }
            .frame(width: 120)
            
            Button(action: {
                openURL(application.applicationLink)
            }) {
                TextField("Link", text: $application.applicationLink)
            }
            .frame(width: 100)
            
            TextField("Notes", text: $application.notes)
                .frame(minWidth: 100)
        }
        .padding(.vertical, 5)
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
