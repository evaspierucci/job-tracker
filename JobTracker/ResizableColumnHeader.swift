import SwiftUI
#if os(macOS)
import AppKit
#endif

struct ResizableColumnHeader<Content: View>: View {
    let id: String
    let minWidth: CGFloat
    @ObservedObject var widthManager: ColumnWidthManager
    @ViewBuilder let content: () -> Content
    @State private var isDragging = false
    @State private var startWidth: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 0) {
            // Content
            content()
                .frame(width: widthManager.width(for: id))
            
            // Resize Handle
            Rectangle()
                .fill(Color.gray.opacity(isDragging ? 0.5 : 0.0))
                .frame(width: 4)
                .contentShape(Rectangle())
                #if os(macOS)
                .onHover { hovering in
                    if hovering {
                        NSCursor.resizeLeftRight.push()
                    } else {
                        NSCursor.pop()
                    }
                }
                #endif
                .gesture(
                    DragGesture(minimumDistance: 1)
                        .onChanged { value in
                            if !isDragging {
                                startWidth = widthManager.width(for: id)
                                isDragging = true
                            }
                            let newWidth = max(minWidth, startWidth + value.translation.width)
                            widthManager.setWidth(newWidth, for: id)
                        }
                        .onEnded { _ in
                            isDragging = false
                        }
                )
        }
    }
} 