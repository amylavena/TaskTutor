import SwiftUI
import AVKit

class ChatViewModel: ObservableObject {
    let recipient: User
    @Published var messages: [ChatMessage] = []
    @Published var messageText = ""
    @Published var isLoading = false
    @Published var error: Error?
    @Published var isOnline = false
    @Published var selectedAttachments: [UIImage] = []
    @Published var showAttachmentPicker = false
    @Published var showDocumentPicker = false
    @Published var showVideoCallSheet = false
    @Published var isInVideoCall = false
    @Published var incomingVideoCall = false
    @Published var videoCallDuration: TimeInterval = 0
    @Published var isRecipientTyping = false
    
    private var videoCallTimer: Timer?
    private var callStartTime: Date?
    private var typingTimer: Timer?
    private var messageListener: Any?
    
    init(recipient: User) {
        self.recipient = recipient
        loadMessages()
        setupOnlineStatus()
        simulateRecipientTyping()
    }
    
    func loadMessages() {
        isLoading = true
        
        // Simulate loading messages
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.messages = ChatMessage.sampleMessages
            self.isLoading = false
            
            // Simulate message status updates
            self.simulateMessageStatusUpdates()
        }
    }
    
    func sendMessage() {
        guard !messageText.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty else { return }
        
        let newMessage = ChatMessage(
            type: .text,
            content: messageText,
            isFromCurrentUser: true
        )
        
        messages.append(newMessage)
        messageText = ""
        
        // Simulate message status updates
        simulateMessageStatusUpdate(for: newMessage)
        
        // Simulate recipient typing and response
        simulateRecipientResponse()
    }
    
    func sendAttachments() {
        guard !selectedAttachments.isEmpty else { return }
        
        // Simulate file upload
        let attachments: [ChatAttachment] = selectedAttachments.enumerated().map { index, image in
            ChatAttachment(
                type: .image,
                url: URL(string: "https://example.com/image\(index).jpg")!,
                fileName: "image\(index).jpg",
                fileSize: Int64(arc4random_uniform(1000000) + 500000),
                thumbnailURL: URL(string: "https://example.com/image\(index)_thumb.jpg")
            )
        }
        
        let message = ChatMessage(
            type: .attachment,
            content: "Sent \(attachments.count) image\(attachments.count > 1 ? "s" : "")",
            isFromCurrentUser: true,
            attachments: attachments
        )
        
        messages.append(message)
        selectedAttachments.removeAll()
        
        // Simulate message status updates
        simulateMessageStatusUpdate(for: message)
    }
    
    // MARK: - Message Status Simulation
    
    private func simulateMessageStatusUpdates() {
        for (index, message) in messages.enumerated() where message.isFromCurrentUser {
            DispatchQueue.main.asyncAfter(deadline: .now() + Double(index) * 0.5) {
                var updatedMessage = message
                updatedMessage.status = .delivered
                self.updateMessage(updatedMessage)
                
                // Simulate read status after delivery
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    updatedMessage.status = .read
                    self.updateMessage(updatedMessage)
                }
            }
        }
    }
    
    private func simulateMessageStatusUpdate(for message: ChatMessage) {
        var updatedMessage = message
        
        // Simulate sending -> sent
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            updatedMessage.status = .sent
            self.updateMessage(updatedMessage)
            
            // Simulate sent -> delivered
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                updatedMessage.status = .delivered
                self.updateMessage(updatedMessage)
                
                // Simulate delivered -> read
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    updatedMessage.status = .read
                    self.updateMessage(updatedMessage)
                }
            }
        }
    }
    
    private func updateMessage(_ message: ChatMessage) {
        if let index = messages.firstIndex(where: { $0.id == message.id }) {
            messages[index] = message
        }
    }
    
    // MARK: - Typing Indicator Simulation
    
    private func simulateRecipientTyping() {
        // Show typing indicator periodically
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            self.showTypingIndicator()
        }
    }
    
    private func simulateRecipientResponse() {
        showTypingIndicator()
        
        // Simulate response after typing
        DispatchQueue.main.asyncAfter(deadline: .now() + Double.random(in: 2...4)) {
            self.isRecipientTyping = false
            
            let responses = [
                "I understand. Could you provide more details?",
                "That's interesting! Let me help you with that.",
                "Great! Would you like to schedule a consultation?",
                "I have some suggestions that might help."
            ]
            
            let response = ChatMessage(
                type: .text,
                content: responses.randomElement() ?? responses[0],
                isFromCurrentUser: false
            )
            
            self.messages.append(response)
        }
    }
    
    private func showTypingIndicator() {
        isRecipientTyping = true
        
        // Hide typing indicator after random duration if no message is sent
        typingTimer?.invalidate()
        typingTimer = Timer.scheduledTimer(withTimeInterval: Double.random(in: 2...4), repeats: false) { [weak self] _ in
            self?.isRecipientTyping = false
        }
    }
    
    // MARK: - Video Call Methods
    
    func initiateVideoCall() {
        let message = ChatMessage(
            type: .videoCallRequest,
            content: "Video call request",
            isFromCurrentUser: true
        )
        messages.append(message)
        
        // Simulate recipient accepting the call
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.acceptVideoCall(fromRecipient: true)
        }
    }
    
    func acceptVideoCall(fromRecipient: Bool = false) {
        let message = ChatMessage(
            type: .videoCallAccepted,
            content: "\(fromRecipient ? recipient.name : "You") accepted the video call",
            isFromCurrentUser: !fromRecipient
        )
        messages.append(message)
        
        startVideoCall()
    }
    
    func declineVideoCall(fromRecipient: Bool = false) {
        let message = ChatMessage(
            type: .videoCallDeclined,
            content: "\(fromRecipient ? recipient.name : "You") declined the video call",
            isFromCurrentUser: !fromRecipient
        )
        messages.append(message)
        
        incomingVideoCall = false
    }
    
    func endVideoCall() {
        guard let startTime = callStartTime else { return }
        
        videoCallTimer?.invalidate()
        videoCallTimer = nil
        isInVideoCall = false
        
        let duration = Date().timeIntervalSince(startTime)
        let message = ChatMessage(
            type: .videoCallEnded,
            content: "Video call ended",
            isFromCurrentUser: true,
            videoCallDuration: duration
        )
        messages.append(message)
        
        callStartTime = nil
    }
    
    private func startVideoCall() {
        isInVideoCall = true
        callStartTime = Date()
        
        videoCallTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            guard let self = self, let startTime = self.callStartTime else { return }
            self.videoCallDuration = Date().timeIntervalSince(startTime)
        }
    }
    
    func formatDuration(_ duration: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.hour, .minute, .second]
        formatter.unitsStyle = .positional
        formatter.zeroFormattingBehavior = .pad
        return formatter.string(from: duration) ?? "0:00:00"
    }
    
    private func setupOnlineStatus() {
        // Simulate online status changes
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            self.isOnline = true
            
            // Simulate occasional offline status
            Timer.scheduledTimer(withTimeInterval: 30, repeats: true) { [weak self] _ in
                self?.isOnline = false
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                    self?.isOnline = true
                }
            }
        }
    }
    
    deinit {
        if let messageListener = messageListener {
            // Clean up message listener
            print("Cleaning up message listener: \(messageListener)")
        }
        videoCallTimer?.invalidate()
        typingTimer?.invalidate()
    }
} 