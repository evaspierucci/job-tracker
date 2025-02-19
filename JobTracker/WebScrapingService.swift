import Foundation

enum ScrapingError: Error {
    case invalidURL
    case networkError(Error)
    case invalidResponse
    case timeout
    
    var description: String {
        switch self {
        case .invalidURL:
            return "Please enter a valid job posting URL"
        case .networkError(let error):
            return "Unable to access the job posting: \(error.localizedDescription)"
        case .invalidResponse:
            return "Unable to read the job posting details"
        case .timeout:
            return "Request took too long to respond"
        }
    }
}

actor WebScrapingService {
    static let shared = WebScrapingService()
    
    func fetchWebpage(url urlString: String) async throws -> String {
        print("\n🌐 Testing URL: \(urlString)")
        
        guard let url = URL(string: urlString) else {
            print("❌ Invalid URL format")
            throw ScrapingError.invalidURL
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.timeoutInterval = 30
        
        // Enhanced headers for job sites
        let headers = [
            "User-Agent": "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36",
            "Accept": "text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8",
            "Accept-Language": "en-US,en;q=0.9",
            "Cache-Control": "no-cache",
            "Pragma": "no-cache"
        ]
        
        headers.forEach { request.setValue($1, forHTTPHeaderField: $0) }
        
        do {
            print("📡 Starting request...")
            let (data, response) = try await URLSession.shared.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("❌ Invalid response type")
                throw ScrapingError.invalidResponse
            }
            
            print("📥 Response status: \(httpResponse.statusCode)")
            
            guard let html = String(data: data, encoding: .utf8) else {
                print("❌ Could not decode response data")
                throw ScrapingError.invalidResponse
            }
            
            // Print preview of the HTML content
            print("\n📄 HTML Content Preview:")
            print("------------------------")
            let previewLength = 500
            let preview = html.prefix(previewLength)
            print(preview)
            print("------------------------")
            
            // Check if we got actual job content
            let lowerHTML = html.lowercased()
            if lowerHTML.contains("job") || lowerHTML.contains("position") || lowerHTML.contains("employment") {
                print("✅ Job content detected in HTML")
            } else {
                print("⚠️ No job-related content found - might be a redirect or error page")
            }
            
            print("✅ Total HTML length: \(html.count) characters")
            return html
            
        } catch {
            print("❌ Error details: \(error)")
            throw ScrapingError.networkError(error)
        }
    }
}