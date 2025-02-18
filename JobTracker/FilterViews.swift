import SwiftUI

struct StatusFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Status")
                .font(.headline)
            
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
            
            Button("Clear") {
                viewModel.selectedStatuses.removeAll()
            }
            .padding(.top)
        }
    }
}

struct DateFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var startDate: Date
    @State private var endDate: Date
    
    init(viewModel: JobApplicationViewModel) {
        self.viewModel = viewModel
        let range = viewModel.dateRange ?? (Date()...Date())
        _startDate = State(initialValue: range.lowerBound)
        _endDate = State(initialValue: range.upperBound)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Date")
                .font(.headline)
            
            DatePicker("Start Date", selection: $startDate, displayedComponents: .date)
                .onChange(of: startDate) { _, newValue in
                    if newValue <= endDate {
                        viewModel.dateRange = newValue...endDate
                    } else {
                        startDate = endDate // Prevent invalid range
                    }
                }
            
            DatePicker("End Date", selection: $endDate, displayedComponents: .date)
                .onChange(of: endDate) { _, newValue in
                    if newValue >= startDate {
                        viewModel.dateRange = startDate...newValue
                    } else {
                        endDate = startDate // Prevent invalid range
                    }
                }
            
            Button("Clear") {
                viewModel.dateRange = nil
                startDate = Date()
                endDate = Date()
            }
            .padding(.top)
        }
    }
}

struct LocationFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Location")
                .font(.headline)
            
            ForEach(Array(viewModel.uniqueLocations), id: \.self) { location in
                Toggle(location, isOn: Binding(
                    get: { viewModel.selectedLocations.contains(location) },
                    set: { isSelected in
                        if isSelected {
                            viewModel.selectedLocations.insert(location)
                        } else {
                            viewModel.selectedLocations.remove(location)
                        }
                    }
                ))
            }
            
            Button("Clear") {
                viewModel.selectedLocations.removeAll()
            }
            .padding(.top)
        }
    }
}

struct JobTitleFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var searchText = ""
    
    var uniqueJobTitles: [String] {
        Array(Set(viewModel.applications.map { $0.jobTitle })).sorted()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Job Title")
                .font(.headline)
            
            TextField("Search job titles", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(uniqueJobTitles.filter { 
                        searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self) { title in
                        Toggle(title, isOn: Binding(
                            get: { viewModel.selectedJobTitles.contains(title) },
                            set: { isSelected in
                                if isSelected {
                                    viewModel.selectedJobTitles.insert(title)
                                } else {
                                    viewModel.selectedJobTitles.remove(title)
                                }
                            }
                        ))
                    }
                }
            }
            .frame(maxHeight: 200)
            
            Button("Clear") {
                viewModel.selectedJobTitles.removeAll()
            }
            .padding(.top)
        }
    }
}

struct CompanyFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    @State private var searchText = ""
    
    var uniqueCompanies: [String] {
        Array(Set(viewModel.applications.map { $0.companyName })).sorted()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Company")
                .font(.headline)
            
            TextField("Search companies", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            ScrollView {
                VStack(alignment: .leading, spacing: 4) {
                    ForEach(uniqueCompanies.filter { 
                        searchText.isEmpty || $0.localizedCaseInsensitiveContains(searchText)
                    }, id: \.self) { company in
                        Toggle(company, isOn: Binding(
                            get: { viewModel.selectedCompanies.contains(company) },
                            set: { isSelected in
                                if isSelected {
                                    viewModel.selectedCompanies.insert(company)
                                } else {
                                    viewModel.selectedCompanies.remove(company)
                                }
                            }
                        ))
                    }
                }
            }
            .frame(maxHeight: 200)
            
            Button("Clear") {
                viewModel.selectedCompanies.removeAll()
            }
            .padding(.top)
        }
    }
}

struct LinkFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Link")
                .font(.headline)
            
            // For now, just show a placeholder since we haven't implemented link filtering
            Text("Link filtering coming soon")
                .foregroundColor(.gray)
        }
        .padding()
    }
}

struct NotesFilterView: View {
    @ObservedObject var viewModel: JobApplicationViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Filter by Notes")
                .font(.headline)
            
            // For now, just show a placeholder since we haven't implemented notes filtering
            Text("Notes filtering coming soon")
                .foregroundColor(.gray)
        }
        .padding()
    }
} 