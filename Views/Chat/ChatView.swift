import SwiftUI
import PhotosUI
import AVKit

struct ChatView: View {
    @StateObject private var viewModel: ChatViewModel
    @FocusState private var isTextFieldFocused: Bool
    
    init(recipient: User) {
        _viewModel = StateObject(wrappedValue: ChatViewModel(recipient: recipient))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            // Chat Header
            chatHeader
            
            // Messages
            ScrollViewReader { proxy in
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(viewModel.messages) { message in
                            MessageView(message: message)
                        }
                        
                        if viewModel.isRecipientTyping {
                            TypingIndicator()
                        }
                    }
                    .padding()
                }
                .onChange(of: viewModel.messages.count) { _ in
                    if let lastMessage = viewModel.messages.last {
                        withAnimation {
                            proxy.scrollTo(lastMessage.id, anchor: .bottom)
                        }
                    }
                }
                .onChange(of: viewModel.isRecipientTyping) { _ in
                    withAnimation {
                        proxy.scrollTo("typing", anchor: .bottom)
                    }
                }
            }
            
            // Message Input
            messageInput
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $viewModel.showAttachmentPicker) {
            PhotoLibraryPicker(images: $viewModel.selectedAttachments)
        }
        .sheet(isPresented: $viewModel.showDocumentPicker) {
            DocumentPicker()
        }
        .sheet(isPresented: $viewModel.showVideoCallSheet) {
            VideoCallView(viewModel: viewModel)
        }
        .alert("Incoming Video Call", isPresented: $viewModel.incomingVideoCall) {
            Button("Accept") {
                viewModel.acceptVideoCall()
                viewModel.showVideoCallSheet = true
            }
            Button("Decline", role: .cancel) {
                viewModel.declineVideoCall()
            }
        } message: {
            Text(viewModel.recipient.name + " is calling...")
        }
    }
    
    private var chatHeader: some View {
        HStack(spacing: 16) {
            if let photoURL = viewModel.recipient.profilePhotoURL,
               let url = URL(string: photoURL) {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                } placeholder: {
                    defaultProfileImage
                }
                .frame(width: 40, height: 40)
                .clipShape(Circle())
            } else {
                defaultProfileImage
                    .frame(width: 40, height: 40)
            }
            
            VStack(alignment: .leading, spacing: 2) {
                Text(viewModel.recipient.name)
                    .font(.headline)
                
                if viewModel.isOnline {
                    Text("Online")
                        .font(.caption)
                        .foregroundColor(.green)
                }
            }
            
            Spacer()
            
            Button(action: {
                viewModel.initiateVideoCall()
                viewModel.showVideoCallSheet = true
            }) {
                Image(systemName: "video")
                    .font(.title3)
                    .foregroundColor(Color.theme.primary)
            }
            
            Button(action: { /* TODO: Show more options */ }) {
                Image(systemName: "ellipsis")
                    .font(.title3)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color.theme.cardBackground)
    }
    
    private var defaultProfileImage: some View {
        Circle()
            .fill(Color.gray.opacity(0.2))
            .overlay(
                Text(viewModel.recipient.name.prefix(1))
                    .font(.system(size: 20))
                    .foregroundColor(Color.theme.primary)
            )
    }
    
    private var messageInput: some View {
        VStack(spacing: 0) {
            if !viewModel.selectedAttachments.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(viewModel.selectedAttachments, id: \.self) { image in
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 60, height: 60)
                                .clipShape(RoundedRectangle(cornerRadius: 8))
                                .overlay(
                                    Button(action: {
                                        viewModel.selectedAttachments.removeAll { $0 == image }
                                    }) {
                                        Image(systemName: "xmark.circle.fill")
                                            .foregroundColor(.white)
                                            .background(Color.black.opacity(0.5))
                                            .clipShape(Circle())
                                    }
                                    .padding(4),
                                    alignment: .topTrailing
                                )
                        }
                    }
                    .padding()
                }
            }
            
            Divider()
            
            HStack(spacing: 16) {
                Menu {
                    Button(action: { viewModel.showAttachmentPicker = true }) {
                        Label("Photo", systemImage: "photo")
                    }
                    Button(action: { viewModel.showDocumentPicker = true }) {
                        Label("Document", systemImage: "doc")
                    }
                } label: {
                    Image(systemName: "paperclip")
                        .font(.title3)
                        .foregroundColor(Color.theme.primary)
                }
                
                TextField("Type a message...", text: $viewModel.messageText)
                    .textFieldStyle(.plain)
                    .focused($isTextFieldFocused)
                
                if !viewModel.selectedAttachments.isEmpty {
                    Button(action: viewModel.sendAttachments) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(Color.theme.primary)
                    }
                } else {
                    Button(action: viewModel.sendMessage) {
                        Image(systemName: "arrow.up.circle.fill")
                            .font(.title2)
                            .foregroundColor(viewModel.messageText.isEmpty ? .gray : Color.theme.primary)
                    }
                    .disabled(viewModel.messageText.isEmpty)
                }
            }
            .padding()
            .background(Color.theme.cardBackground)
        }
    }
}

// MARK: - Message View
struct MessageView: View {
    let message: ChatMessage
    
    var body: some View {
        VStack(alignment: message.isFromCurrentUser ? .trailing : .leading, spacing: 4) {
            if message.isVideoCallRelated {
                videoCallMessage
            } else if !message.attachments.isEmpty {
                attachmentMessage
            } else {
                textMessage
            }
            
            HStack(spacing: 4) {
                Text(timeString(from: message.timestamp))
                    .font(.caption2)
                    .foregroundColor(.secondary)
                
                if message.isFromCurrentUser {
                    Image(systemName: message.status.icon)
                        .font(.caption2)
                        .foregroundColor(message.status == .failed ? .red : .secondary)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: message.isFromCurrentUser ? .trailing : .leading)
    }
    
    private var textMessage: some View {
        Text(message.content)
            .font(.body)
            .foregroundColor(message.isFromCurrentUser ? .white : .primary)
            .padding(.horizontal, 16)
            .padding(.vertical, 12)
            .background(message.isFromCurrentUser ? Color.theme.primary : Color.theme.cardBackground)
            .cornerRadius(20)
    }
    
    private var attachmentMessage: some View {
        VStack(alignment: .leading, spacing: 8) {
            if !message.content.isEmpty {
                Text(message.content)
                    .font(.body)
                    .foregroundColor(message.isFromCurrentUser ? .white : .primary)
            }
            
            ForEach(message.attachments) { attachment in
                AttachmentView(attachment: attachment)
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(message.isFromCurrentUser ? Color.theme.primary : Color.theme.cardBackground)
        .cornerRadius(20)
    }
    
    private var videoCallMessage: some View {
        HStack(spacing: 8) {
            Image(systemName: "video")
            
            VStack(alignment: .leading, spacing: 4) {
                Text(message.content)
                if let duration = message.videoCallDuration {
                    Text(formatDuration(duration))
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 12)
        .background(Color.theme.cardBackground)
        .cornerRadius(20)
    }
    
    private func timeString(from date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
    
    private func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: duration) ?? "0:00:00"
    }
}

// MARK: - Attachment View
struct AttachmentView: View {
    let attachment: ChatAttachment
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: attachment.type.icon)
                .font(.title2)
                .foregroundColor(Color.theme.primary)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(attachment.fileName)
                    .font(.subheadline)
                    .lineLimit(1)
                
                Text(attachment.formattedFileSize)
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            Button(action: { /* TODO: Download attachment */ }) {
                Image(systemName: "arrow.down.circle")
                    .font(.title3)
                    .foregroundColor(Color.theme.primary)
            }
        }
        .padding()
        .background(Color.theme.cardBackground.opacity(0.5))
        .cornerRadius(12)
    }
}

// MARK: - Video Call View
struct VideoCallView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: ChatViewModel
    
    var body: some View {
        ZStack {
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack {
                Text(viewModel.formatDuration(viewModel.videoCallDuration))
                    .font(.title)
                    .foregroundColor(.white)
                    .padding()
                
                Spacer()
                
                HStack(spacing: 40) {
                    Button(action: { /* TODO: Toggle camera */ }) {
                        Image(systemName: "camera.rotate")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                    }
                    
                    Button(action: {
                        viewModel.endVideoCall()
                        dismiss()
                    }) {
                        Image(systemName: "phone.down.fill")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.red)
                            .clipShape(Circle())
                    }
                    
                    Button(action: { /* TODO: Toggle microphone */ }) {
                        Image(systemName: "mic")
                            .font(.title)
                            .foregroundColor(.white)
                            .padding()
                            .background(Color.gray.opacity(0.5))
                            .clipShape(Circle())
                    }
                }
                .padding(.bottom, 40)
            }
        }
    }
}

// MARK: - Document Picker
struct DocumentPicker: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let picker = UIDocumentPickerViewController(forOpeningContentTypes: [.pdf, .text])
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
}

// MARK: - Media Picker
struct MediaPicker: UIViewControllerRepresentable {
    @Binding var images: [UIImage]
    
    func makeUIViewController(context: Context) -> PHPickerViewController {
        var config = PHPickerConfiguration()
        config.filter = .images
        config.selectionLimit = 5
        
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = context.coordinator
        return picker
    }
    
    func updateUIViewController(_ uiViewController: PHPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, PHPickerViewControllerDelegate {
        let parent: MediaPicker
        
        init(_ parent: MediaPicker) {
            self.parent = parent
        }
        
        func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
            picker.dismiss(animated: true)
            
            for result in results {
                if result.itemProvider.canLoadObject(ofClass: UIImage.self) {
                    result.itemProvider.loadObject(ofClass: UIImage.self) { image, error in
                        if let image = image as? UIImage {
                            DispatchQueue.main.async {
                                self.parent.images.append(image)
                            }
                        }
                    }
                }
            }
        }
    }
}

// MARK: - Typing Indicator
struct TypingIndicator: View {
    @State private var animationOffset: CGFloat = 0
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<3) { index in
                Circle()
                    .fill(Color.secondary)
                    .frame(width: 6, height: 6)
                    .offset(y: animationOffset)
                    .animation(
                        Animation.easeInOut(duration: 0.5)
                            .repeatForever()
                            .delay(0.15 * Double(index)),
                        value: animationOffset
                    )
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 8)
        .background(Color.theme.cardBackground)
        .cornerRadius(16)
        .frame(maxWidth: .infinity, alignment: .leading)
        .id("typing")
        .onAppear {
            animationOffset = -5
        }
    }
}

struct ChatView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ChatView(recipient: User(name: "John Smith", email: "john@example.com", profilePhotoURL: ""))
        }
    }
} 