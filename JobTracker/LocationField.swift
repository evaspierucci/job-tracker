import SwiftUI

struct LocationField: View {
    @Binding var location: JobApplication.Location
    
    var body: some View {
        TextField("Location", text: Binding(
            get: { location.displayString },
            set: { newValue in
                if newValue.isEmpty || newValue.lowercased() == "remote" {
                    location = .remote
                } else {
                    location = .city(newValue)
                }
            }
        ))
        .textFieldStyle(RoundedBorderTextFieldStyle())
    }
} 