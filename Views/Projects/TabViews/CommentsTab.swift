import SwiftUI

struct CommentsTab: View {
    let project: EnhancedProject
    @State private var newComment = ""
    @State private var comments: [ProjectComment] = []
    @State private var isLoading = false
    
    var body: some View {
        VStack(spacing: 16) {
            // Comment Input
            CommentInputField(text: $newComment) {
                // Submit comment action
                submitComment()
            }
            
            if isLoading {
                ProgressView()
            } else {
                // Comments List
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(comments) { comment in
                            CommentRow(comment: comment)
                        }
                    }
                    .padding()
                }
            }
        }
    }
    
    private func submitComment() {
        guard !newComment.isEmpty else { return }
        // Add comment submission logic
        newComment = ""
    }
}

struct CommentInputField: View {
    @Binding var text: String
    let onSubmit: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            TextField("Add a comment...", text: $text)
                .textFieldStyle(RoundedBorderTextFieldStyle())
            
            Button(action: onSubmit) {
                Text("Post")
                    .fontWeight(.medium)
            }
            .disabled(text.isEmpty)
        }
        .padding()
    }
}

struct CommentRow: View {
    let comment: ProjectComment
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // User Info
            HStack {
                AsyncImage(url: URL(string: comment.userPhotoURL)) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    Circle()
                        .fill(Color.gray.opacity(0.2))
                }
                .frame(width: 32, height: 32)
                .clipShape(Circle())
                
                VStack(alignment: .leading) {
                    Text(comment.userName)
                        .font(.subheadline)
                        .fontWeight(.medium)
                    Text(comment.date.formatted())
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            // Comment Content
            Text(comment.content)
                .font(.subheadline)
            
            // Actions
            HStack(spacing: 16) {
                Button(action: {}) {
                    Label("\(comment.likes)", systemImage: "heart")
                }
                
                Button(action: {}) {
                    Label("Reply", systemImage: "arrowshape.turn.up.left")
                }
            }
            .font(.caption)
            .foregroundColor(.secondary)
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
    }
} 