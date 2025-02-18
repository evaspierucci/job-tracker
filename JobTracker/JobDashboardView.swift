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
                
                // Scrollable Table Container
                ScrollView(.horizontal, showsIndicators: true) {
                    VStack(spacing: 0) {
                        // Header
                        HeaderRow(viewModel: viewModel)
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
                                    viewModel: viewModel,
                                    widthManager: viewModel.widthManager
                                ) {
                                    viewModel.deleteApplication(id: application.id)
                                }
                                .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .listStyle(.plain)
                    }
                    .frame(minWidth: totalWidth)
                }
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
    
    private var totalWidth: CGFloat {
        TableLayout.jobTitle +
        TableLayout.company +
        TableLayout.date +
        TableLayout.status +
        TableLayout.location +
        TableLayout.link +
        TableLayout.notes +
        TableLayout.actions +
        (TableLayout.spacing * 7) +
        (TableLayout.contentPadding * 4)
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
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var showingJobTitleFilter = false
    @State private var showingCompanyFilter = false
    @State private var showingDateFilter = false
    @State private var showingStatusFilter = false
    @State private var showingLocationFilter = false
    @State private var showingLinkFilter = false
    @State private var showingNotesFilter = false
    
    var body: some View {
        HStack(spacing: TableLayout.spacing) {
            // Job Title
            ResizableColumnHeader(id: "jobTitle", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Job Title",
                    sortOption: .jobTitle,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "jobTitle"),
                    onSort: { viewModel.toggleSort(.jobTitle) },
                    showingFilter: $showingJobTitleFilter
                ) {
                    JobTitleFilterView(viewModel: viewModel)
                }
            }
            
            // Company
            ResizableColumnHeader(id: "company", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Company",
                    sortOption: .company,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "company"),
                    onSort: { viewModel.toggleSort(.company) },
                    showingFilter: $showingCompanyFilter
                ) {
                    CompanyFilterView(viewModel: viewModel)
                }
            }
            
            // Application Date
            ResizableColumnHeader(id: "date", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Application\nDate",
                    sortOption: .date,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "date"),
                    onSort: { viewModel.toggleSort(.date) },
                    showingFilter: $showingDateFilter
                ) {
                    DateFilterView(viewModel: viewModel)
                }
            }
            
            // Status
            ResizableColumnHeader(id: "status", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Status",
                    sortOption: .status,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "status"),
                    onSort: { viewModel.toggleSort(.status) },
                    showingFilter: $showingStatusFilter
                ) {
                    StatusFilterView(viewModel: viewModel)
                }
            }
            
            // Location
            ResizableColumnHeader(id: "location", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Location",
                    sortOption: .location,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "location"),
                    onSort: { viewModel.toggleSort(.location) },
                    showingFilter: $showingLocationFilter
                ) {
                    LocationFilterView(viewModel: viewModel)
                }
            }
            
            // Link
            ResizableColumnHeader(id: "link", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Link",
                    sortOption: .link,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "link"),
                    onSort: { viewModel.toggleSort(.link) },
                    showingFilter: $showingLinkFilter
                ) {
                    LinkFilterView(viewModel: viewModel)
                }
            }
            
            // Notes
            ResizableColumnHeader(id: "notes", minWidth: TableLayout.minimumWidth, widthManager: viewModel.widthManager) {
                ColumnHeader(
                    title: "Notes",
                    sortOption: .notes,
                    currentSort: viewModel.currentSort,
                    sortOrder: viewModel.sortOrder,
                    width: viewModel.widthManager.width(for: "notes"),
                    onSort: { viewModel.toggleSort(.notes) },
                    showingFilter: $showingNotesFilter
                ) {
                    NotesFilterView(viewModel: viewModel)
                }
            }
            
            // Actions
            Spacer()
                .frame(width: TableLayout.actions)
        }
        .frame(height: 32)  // Fixed header height
        .padding(.horizontal, TableLayout.contentPadding)
    }
}

struct JobApplicationRow: View {
    @Binding var application: JobApplication
    @ObservedObject var viewModel: JobApplicationViewModel
    @ObservedObject var widthManager: ColumnWidthManager
    @State private var isHovered = false
    @State private var showingDeleteAlert = false
    let onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: TableLayout.spacing) {
            // Job Title
            TextField("Job Title", text: $application.jobTitle)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: viewModel.widthManager.width(for: "jobTitle"))
                .padding(.leading, TableLayout.contentPadding)
            
            // Company
            TextField("Company", text: $application.companyName)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: viewModel.widthManager.width(for: "company"))
                .padding(.leading, TableLayout.contentPadding)
            
            // Date
            DatePicker("", selection: $application.applicationDate, displayedComponents: .date)
                .frame(width: viewModel.widthManager.width(for: "date"))
                .padding(.leading, TableLayout.contentPadding)
            
            // Status
            Menu {
                ForEach(JobApplication.ApplicationStatus.allCases, id: \.self) { status in
                    Button(action: { 
                        withAnimation(.easeInOut(duration: 0.2)) {
                            application.status = status
                            viewModel.updateApplication(application)
                        }
                    }) {
                        HStack {
                            Circle()
                                .fill(status.iconColor)
                                .frame(width: 8, height: 8)
                            Text(status.rawValue)
                                .foregroundColor(status.iconColor)
                        }
                    }
                }
            } label: {
                StatusView(status: application.status)
            }
            .frame(width: viewModel.widthManager.width(for: "status"))
            .padding(.leading, TableLayout.contentPadding)
            
            // Location
            LocationField(location: $application.location)
                .frame(width: viewModel.widthManager.width(for: "location"))
                .padding(.leading, TableLayout.contentPadding)
            
            // Link
            HStack(spacing: 4) {
                TextField("Enter application link", text: $application.applicationLink)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                if !application.applicationLink.isEmpty {
                    Button(action: { openURL(application.applicationLink) }) {
                        Image(systemName: "arrow.up.right.circle")
                            .foregroundColor(.blue)
                    }
                    .buttonStyle(.plain)
                }
            }
            .frame(width: viewModel.widthManager.width(for: "link"))
            .padding(.leading, TableLayout.contentPadding)
            
            // Notes
            TextField("Notes", text: $application.notes)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .frame(width: viewModel.widthManager.width(for: "notes"))
                .padding(.leading, TableLayout.contentPadding)
            
            // Delete button
            Button(action: { showingDeleteAlert = true }) {
                Image(systemName: "trash.fill")
                    .foregroundColor(Color.deleteButton)
                    .opacity(isHovered ? 1 : 0)
            }
            .frame(width: TableLayout.actions)
            .padding(.horizontal, TableLayout.contentPadding)
        }
        .padding(.vertical, 5)
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
        .alert("Delete Job Application", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                withAnimation(.easeInOut(duration: 0.2)) {
                    onDelete()
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
    @State private var showingFilters = false
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 16) {
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Search by job title or company", text: $viewModel.searchText)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                Menu {
                    Menu("Status") {
                        ForEach(JobApplication.ApplicationStatus.allCases, id: \.self) { status in
                            Toggle(status.rawValue, isOn: Binding(
                                get: { viewModel.selectedStatuses.contains(status) },
                                set: { isSelected in
                                    if isSelected {
                                        viewModel.selectedStatuses.insert(status)
                                    } else {
                                        viewModel.selectedStatuses.remove(status)
                                    }
                                }
                            ))
                        }
                    }
                    
                    DatePicker(
                        "Start Date",
                        selection: Binding(
                            get: { viewModel.dateRange?.lowerBound ?? Date() },
                            set: { date in
                                if let upper = viewModel.dateRange?.upperBound {
                                    viewModel.dateRange = date...upper
                                } else {
                                    viewModel.dateRange = date...Date()
                                }
                            }
                        ),
                        displayedComponents: .date
                    )
                    
                    DatePicker(
                        "End Date",
                        selection: Binding(
                            get: { viewModel.dateRange?.upperBound ?? Date() },
                            set: { date in
                                if let lower = viewModel.dateRange?.lowerBound {
                                    viewModel.dateRange = lower...date
                                } else {
                                    viewModel.dateRange = Date()...date
                                }
                            }
                        ),
                        displayedComponents: .date
                    )
                    
                    Button("Clear Filters") {
                        viewModel.resetFilters()
                    }
                } label: {
                    Label("Filters", systemImage: "line.3.horizontal.decrease.circle")
                        .foregroundColor(.blue)
                }
            }
            .padding(.horizontal)
            
            if !viewModel.selectedStatuses.isEmpty || viewModel.dateRange != nil {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(Array(viewModel.selectedStatuses), id: \.self) { status in
                            FilterTag(text: "Status: \(status.rawValue)") {
                                viewModel.selectedStatuses.remove(status)
                            }
                        }
                        
                        if viewModel.dateRange != nil {
                            FilterTag(text: "Date Range") {
                                viewModel.dateRange = nil
                            }
                        }
                    }
                    .padding(.horizontal)
                }
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
