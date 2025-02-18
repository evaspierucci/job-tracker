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
                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach($viewModel.applications) { $application in
                            JobApplicationRow(application: $application)
                                .padding(.horizontal)
                                .transition(.scale.combined(with: .opacity))
                        }
                    }
                    .padding(.vertical)
                }
                .background(
                    LinearGradient(
                        gradient: Gradient(colors: [
                            Color.dashboardGradientStart,
                            Color.dashboardGradientEnd
                        ]),
                        startPoint: .top,
                        endPoint: .bottom
                    )
                )
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
            Spacer()
                .frame(width: 24) // Space for delete button
        }
        .padding(.vertical, 12)
        .padding(.horizontal, 10)
        .font(.headline)
        .foregroundColor(Color.primaryText)
    }
}

struct JobApplicationRow: View {
    @Binding var application: JobApplication
    @State private var isHovered = false
    
    var body: some View {
        VStack {
            HStack(spacing: 16) {
                TextField("Job Title", text: $application.jobTitle)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                TextField("Company", text: $application.companyName)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.headline)
                    .frame(width: 150, alignment: .leading)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                DatePicker("", selection: $application.applicationDate, displayedComponents: .date)
                    .frame(width: 100)
                    .labelsHidden()
                    .font(.subheadline)
                
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
                
                ProgressBar(progress: application.progress)
                    .frame(width: 100, height: 8)
                
                TextField("Notes", text: $application.notes)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                    .font(.subheadline)
                    .frame(minWidth: 100)
                    .lineLimit(1)
                    .minimumScaleFactor(0.8)
                
                Button(action: {}) {
                    Image(systemName: "trash.fill")
                        .foregroundColor(Color.deleteButton)
                        .opacity(isHovered ? 1 : 0)
                }
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
        .animation(.easeInOut(duration: 0.2), value: isHovered)
        #if os(macOS)
        .onHover { hovering in
            isHovered = hovering
        }
        #endif
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
