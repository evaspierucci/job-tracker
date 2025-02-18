import SwiftUI

struct LocationField: View {
    @Binding var location: JobApplication.Location
    @StateObject private var cityService = CityLookupService()
    @State private var searchText = ""
    @State private var isCustom = false
    
    var body: some View {
        HStack(spacing: 4) {
            TextField("Location", text: $searchText)
                .textFieldStyle(RoundedBorderTextFieldStyle())
                .disabled(location.isRemote)
                .onChange(of: searchText) { _, newValue in
                    if case .remote = location {
                        return
                    }
                    
                    if isCustom {
                        location = .other(newValue)
                    } else {
                        cityService.suggestions = cityService.getSuggestions(for: newValue)
                        location = .city(newValue)
                    }
                }
            
            Menu {
                // Remote option
                Button(action: {
                    location = .remote
                    searchText = "Remote"
                    isCustom = false
                }) {
                    Label("Remote", systemImage: "house.fill")
                }
                
                Divider()
                
                // Common cities
                ForEach(cityService.suggestions, id: \.self) { city in
                    Button(action: {
                        location = .city(city)
                        searchText = city
                        isCustom = false
                    }) {
                        Label(city, systemImage: "building.2.fill")
                    }
                }
                
                Divider()
                
                // Other option
                Button(action: {
                    isCustom = true
                    searchText = ""
                    location = .other("")
                }) {
                    Label("Custom Location", systemImage: "pencil")
                }
            } label: {
                Image(systemName: getMenuIcon())
                    .foregroundColor(.blue)
                    .font(.system(size: 14))
            }
            .menuStyle(.borderlessButton)
        }
        .frame(width: 150)
        .onAppear {
            // Initialize text field with current location
            switch location {
            case .remote:
                searchText = "Remote"
                isCustom = false
            case .city(let name):
                searchText = name
                isCustom = false
            case .other(let custom):
                searchText = custom
                isCustom = true
            }
        }
    }
    
    private func getMenuIcon() -> String {
        if case .remote = location {
            return "house.fill"
        } else if isCustom {
            return "pencil"
        } else {
            return "chevron.down.circle.fill"
        }
    }
} 