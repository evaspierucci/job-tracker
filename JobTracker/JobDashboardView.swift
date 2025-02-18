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
                // Search and Filter Controls
                SearchFilterView(viewModel: viewModel)
                
                // Header
                HeaderRow()
                    .padding(.horizontal)
                    .background(colorScheme == .dark ? Color(white: 0.1) : .tableBackground)
                
                // Job Applications List
                List {
                    ForEach(viewModel.filteredApplications) { application in
                        JobApplicationRow(
                            application: Binding(
                                get: { application },
                                set: { newValue in
                                    if let index = viewModel.applications.firstIndex(where: { $0.id == application.id }) {
                                        viewModel.applications[index] = newValue
                                        viewModel.updateApplication(newValue)
                                    }
                                }
                            ),
                            viewModel: viewModel
                        ) {
                            viewModel.deleteApplication(id: application.id)
                        }
                        .padding(.horizontal)
                        .transition(.opacity.combined(with: .scale))
                    }
                }
                .listStyle(.plain)
                .background(colorScheme == .dark ? Color(white: 0.1) : .tableBackground)
            }
            .navigationTitle("Job Applications")
            .toolbar {
                ToolbarItem(placement: .primaryAction) {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.2)) {
                            viewModel.addApplication()
                        }
                    }) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.addButton)
                    }
                }
            }
        }
    }
}

struct StatusView: View {
    let status: JobApplication.ApplicationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.subheadline)
            .foregroundColor(status.color)
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(getBackgroundColor(for: status))
            )
    }
    
    private func getBackgroundColor(for status: JobApplication.ApplicationStatus) -> Color {
        switch status {
        case .offerReceived: return Color.statusOfferBg
        case .interviewing: return Color.statusInterviewingBg
        case .applied: return Color.statusAppliedBg
        case .rejected: return Color.statusRejectedBg
        }
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
                .padding(.leading, 8)
            
            Text("Company")
                .frame(width: 150, alignment: .leading)
                .padding(.leading, 8)
            
            Text("Date")
                .frame(width: 100, alignment: .leading)
                .padding(.leading, 8)
            
            Text("Status")
                .frame(width: 120, alignment: .leading)
                .padding(.leading, 8)
            
            Text("Location")
                .frame(width: 150, alignment: .leading)
                .padding(.leading, 8)
            
            Text("Link")
                .frame(width: 150, alignment: .leading)
                .padding(.leading, 8)
            
            Text("Notes")
                .frame(minWidth: 100, alignment: .leading)
                .padding(.leading, 8)
            
            Spacer()
                .frame(width: 24)
        }
        .padding(.vertical, 12)
        .font(.headline)
        .foregroundColor(Color.primaryText)
    }
}

struct JobApplicationRow: View {
    @Binding var application: JobApplication
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var isHovered = false
    @State private var showingDeleteAlert = false
    @State private var isVisible = false  // New state to control appearance
    var onDelete: () -> Void
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                TextField("Job Title", text: $application.jobTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .onChange(of: application.jobTitle) { oldValue, newValue in
                        viewModel.updateApplication(application)
                    }
                
                TextField("Company", text: $application.companyName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .onChange(of: application.companyName) { oldValue, newValue in
                        viewModel.updateApplication(application)
                    }
                
                DatePicker("", selection: $application.applicationDate, displayedComponents: .date)
                    .frame(width: 100)
                    .labelsHidden()
                    .onChange(of: application.applicationDate) { oldValue, newValue in
                        viewModel.updateApplication(application)
                    }
                
                Menu {
                    ForEach(JobApplication.ApplicationStatus.allCases, id: \.self) { status in
                        Button(action: { 
                            withAnimation(.easeInOut(duration: 0.2)) {
                                application.status = status 
                            }
                        }) {
                            Label(status.rawValue, systemImage: "circle.fill")
                                .foregroundColor(status.color)
                        }
                    }
                } label: {
                    HStack {
                        Image(systemName: "checkmark.circle.fill")
                            .foregroundColor(application.status.color)
                            .opacity(application.status == .offerReceived ? 1 : 0)
                        StatusView(status: application.status)
                    }
                    .frame(width: 120, alignment: .leading)
                }
                
                LocationField(location: $application.location)
                    .onChange(of: application.location) { oldValue, newValue in
                        viewModel.updateApplication(application)
                    }
                
                HStack(spacing: 4) {
                    TextField("Enter application link", text: $application.applicationLink)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                        .frame(width: 120, alignment: .leading)
                        .lineLimit(1)
                        .minimumScaleFactor(0.8)
                        #if os(iOS)
                        .keyboardType(.URL)
                        .autocapitalization(.none)
                        #endif
                        .onChange(of: application.applicationLink) { oldValue, newValue in
                            viewModel.updateApplication(application)
                        }
                    
                    if let _ = URL(string: application.applicationLink),
                       !application.applicationLink.isEmpty {
                        Button(action: {
                            openURL(application.applicationLink)
                        }) {
                            Image(systemName: "arrow.up.right.circle")
                                .foregroundColor(.blue)
                                .font(.system(size: 16))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .frame(width: 150, alignment: .leading)
                
                TextField("Notes", text: $application.notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .frame(minWidth: 100)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                    .onChange(of: application.notes) { oldValue, newValue in
                        viewModel.updateApplication(application)
                    }
                
                Button(action: {
                    showingDeleteAlert = true
                }) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color.deleteButton)
                        .opacity(isHovered || isVisible ? 1 : 0)
                }
                .frame(width: 24, height: 24)
            }
            .padding(.horizontal, 10)
            .padding(.vertical, 5)
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.rowFill)
                .shadow(color: Color.rowShadow, radius: 4, x: 0, y: 2)
        )
        .scaleEffect(isHovered ? 1.02 : 1.0)
        #if os(macOS)
        .onHover { hovering in
            isHovered = hovering
        }
        #endif
        .onAppear {
            // Ensure the row is fully rendered before showing hover effects
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    isVisible = true
                }
            }
        }
        .alert("Delete Job Application", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    viewModel.deleteApplication(id: application.id)
                }
            }
        } message: {
            Text("Are you sure you want to delete this job application for \(application.jobTitle) at \(application.companyName)?")
        }
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

struct SearchFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                // Search Bar
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by job title or company", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                // Status Filter
                Picker("Status", selection: $viewModel.selectedStatus) {
                    Text("All")
                        .tag(nil as JobApplication.ApplicationStatus?)
                    ForEach(JobApplication.ApplicationStatus.allCases, id: \.self) { status in
                        Text(status.rawValue)
                            .tag(status as JobApplication.ApplicationStatus?)
                    }
                }
                .frame(width: 150)
                
                // Reset Button
                Button(action: {
                    withAnimation {
                        viewModel.resetFilters()
                    }
                }) {
                    Label("Reset", systemImage: "xmark.circle.fill")
                }
                .buttonStyle(.borderless)
                .opacity(
                    !viewModel.searchText.isEmpty || viewModel.selectedStatus != nil ? 1 : 0
                )
            }
            .padding(.horizontal)
            
            // Filter Tags
            if !viewModel.searchText.isEmpty || viewModel.selectedStatus != nil {
                HStack(spacing: 8) {
                    if !viewModel.searchText.isEmpty {
                        FilterTag(text: "Search: \(viewModel.searchText)") {
                            viewModel.searchText = ""
                        }
                    }
                    
                    if let status = viewModel.selectedStatus {
                        FilterTag(text: "Status: \(status.rawValue)") {
                            viewModel.selectedStatus = nil
                        }
                    }
                }
                .padding(.horizontal)
            }
        }
        .padding(.vertical, 8)
        .background(Color.tableBackground)
    }
}

struct FilterTag: View {
    let text: String
    let onRemove: () -> Void
    
    var body: some View {
        HStack(spacing: 4) {
            Text(text)
                .font(.subheadline)
            
            Button(action: onRemove) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(.gray)
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(Color.gray.opacity(0.1))
        )
    }
} 
