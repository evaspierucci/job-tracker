import Foundation

class CityLookupService: ObservableObject {
    @Published var suggestions: [String] = []
    private var cities: [String]
    
    init() {
        // Initialize with a list of major cities
        cities = [
            "New York", "San Francisco", "Los Angeles", "Chicago", "Boston",
            "Seattle", "Austin", "Denver", "Miami", "Portland", "San Diego",
            "San Jose", "San Antonio", "Santa Monica", "Santa Barbara",
            "London", "Berlin", "Paris", "Tokyo", "Sydney",
            "Toronto", "Vancouver", "Amsterdam", "Stockholm", "Singapore"
        ].sorted()
    }
    
    func getSuggestions(for input: String) -> [String] {
        guard !input.isEmpty else { return [] }
        return cities.filter { city in
            city.localizedCaseInsensitiveContains(input)
        }
    }
} 