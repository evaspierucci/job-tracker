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