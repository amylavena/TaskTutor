import SwiftUI

struct ChatListView: View {
    var body: some View {
        List {
            ForEach(0..<10) { _ in
                ChatRow()
            }
        }
        .navigationTitle("Messages")
    }
}

struct ChatRow: View {
    var body: some View {
        HStack(spacing: 12) {
            Circle()
                .fill(Color.gray.opacity(0.2))
                .frame(width: 50, height: 50)
            
            VStack(alignment: .leading, spacing: 4) {
                Text("Coach Name")
                    .font(.headline)
                Text("Last message preview...")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                    .lineLimit(1)
            }
            
            Spacer()
            
            VStack(alignment: .trailing, spacing: 4) {
                Text("2:30 PM")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Circle()
                    .fill(Color.theme.primary)
                    .frame(width: 18, height: 18)
                    .overlay(
                        Text("2")
                            .font(.caption2)
                            .foregroundColor(.white)
                    )
            }
        }
        .padding(.vertical, 4)
    }
} 