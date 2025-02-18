import SwiftUI

class ColumnWidthManager: ObservableObject {
    @Published private(set) var widths: [String: CGFloat]
    
    init() {
        // Load saved widths or use defaults
        if let savedWidths = UserDefaults.standard.dictionary(forKey: "columnWidths") as? [String: CGFloat] {
            self.widths = savedWidths
        } else {
            self.widths = [
                "jobTitle": TableLayout.jobTitle,
                "company": TableLayout.company,
                "date": TableLayout.date,
                "status": TableLayout.status,
                "location": TableLayout.location,
                "link": TableLayout.link,
                "notes": TableLayout.notes
            ]
        }
    }
    
    func width(for column: String) -> CGFloat {
        widths[column] ?? TableLayout.defaultWidth
    }
    
    func setWidth(_ width: CGFloat, for column: String) {
        widths[column] = max(width, TableLayout.minimumWidth)
        // Save changes
        UserDefaults.standard.set(widths, forKey: "columnWidths")
    }
} 