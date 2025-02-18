import SwiftUI

struct HeaderCell: View {
    let title: String
    let sortOption: SortOption
    let currentSort: SortOption
    let sortOrder: SortOrder
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                Text(title)
                    .foregroundColor(.primary)
                
                if currentSort == sortOption {
                    Image(systemName: sortOrder.systemImageName)
                        .font(.caption)
                        .foregroundColor(.blue)
                }
            }
        }
        .buttonStyle(.plain)
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.horizontal, 8)
    }
} 