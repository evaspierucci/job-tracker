import SwiftUI

struct ColumnHeader<FilterContent: View>: View {
    let title: String
    let sortOption: SortOption
    let currentSort: SortOption
    let sortOrder: SortOrder
    let width: CGFloat
    let onSort: () -> Void
    @Binding var showingFilter: Bool
    let filterContent: () -> FilterContent
    
    var body: some View {
        HStack(spacing: 4) {
            // Title and Sort
            Button(action: onSort) {
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
            
            // Filter
            Button(action: { showingFilter.toggle() }) {
                Image(systemName: "line.3.horizontal.decrease.circle")
                    .foregroundColor(showingFilter ? .blue : .gray)
                    .font(.caption)
            }
            .buttonStyle(.plain)
            .popover(isPresented: $showingFilter) {
                filterContent()
                    .padding()
                    .frame(minWidth: 200)
            }
        }
        .frame(width: width, alignment: .leading)
        .padding(.horizontal, 8)
    }
} 