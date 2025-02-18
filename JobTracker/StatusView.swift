import SwiftUI

struct StatusView: View {
    let status: JobApplication.ApplicationStatus
    
    var body: some View {
        Text(status.rawValue)
            .font(.subheadline.weight(.medium))
            .foregroundColor(status.iconColor)
            .padding(.horizontal, 8)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 6)
                    .fill(status.backgroundColor)
                    .overlay(
                        RoundedRectangle(cornerRadius: 6)
                            .strokeBorder(status.iconColor.opacity(0.3), lineWidth: 1)
                    )
            )
            .contentShape(Rectangle())
            .opacity(status == .archived ? 0.8 : 1.0)
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, TableLayout.contentPadding)
    }
} 