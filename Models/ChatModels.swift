import SwiftUI

enum AttachmentType {
    case photo
    case image
    case video
    case document
    case audio
    
    var icon: String {
        switch self {
        case .photo, .image:
            return "photo"
        case .video:
            return "video"
        case .document:
            return "doc"
        case .audio:
            return "waveform"
        }
    }
}

enum MessageType {
    case text
    case attachment
    case videoCallRequest
    case videoCallAccepted
    case videoCallDeclined
    case videoCallEnded
}

struct ChatMessage: Identifiable {
    let id: UUID
    let type: MessageType
    let content: String
    let timestamp: Date
    let isFromCurrentUser: Bool
    let attachments: [ChatAttachment]
    let videoCallDuration: TimeInterval?
    var status: MessageStatus
    
    init(
        id: UUID = UUID(),
        type: MessageType = .text,
        content: String,
        timestamp: Date = Date(),
        isFromCurrentUser: Bool,
        attachments: [ChatAttachment] = [],
        videoCallDuration: TimeInterval? = nil,
        status: MessageStatus = .sending
    ) {
        self.id = id
        self.type = type
        self.content = content
        self.timestamp = timestamp
        self.isFromCurrentUser = isFromCurrentUser
        self.attachments = attachments
        self.videoCallDuration = videoCallDuration
        self.status = status
    }
    
    var isVideoCallRelated: Bool {
        switch type {
        case .videoCallRequest, .videoCallAccepted, .videoCallDeclined, .videoCallEnded:
            return true
        default:
            return false
        }
    }
}

struct ChatAttachment: Identifiable {
    let id: UUID
    let type: AttachmentType
    let url: URL
    let fileName: String
    let fileSize: Int64
    let thumbnailURL: URL?
    
    init(
        id: UUID = UUID(),
        type: AttachmentType,
        url: URL,
        fileName: String,
        fileSize: Int64,
        thumbnailURL: URL?
    ) {
        self.id = id
        self.type = type
        self.url = url
        self.fileName = fileName
        self.fileSize = fileSize
        self.thumbnailURL = thumbnailURL
    }
    
    var formattedFileSize: String {
        return "\(fileSize) bytes"
    }
    
    static var sampleAttachments: [ChatAttachment] {
        [
            ChatAttachment(
                type: .image,
                url: URL(string: "https://example.com/image1.jpg")!,
                fileName: "kitchen_sketch.jpg",
                fileSize: 1024 * 1024,
                thumbnailURL: URL(string: "https://example.com/image1_thumb.jpg")
            ),
            ChatAttachment(
                type: .document,
                url: URL(string: "https://example.com/doc1.pdf")!,
                fileName: "project_plan.pdf",
                fileSize: 2048 * 1024,
                thumbnailURL: nil
            )
        ]
    }
}

enum MessageStatus {
    case sending
    case sent
    case delivered
    case read
    case failed
    
    var icon: String {
        switch self {
        case .sending:
            return "clock"
        case .sent:
            return "checkmark"
        case .delivered:
            return "checkmark.circle"
        case .read:
            return "checkmark.circle.fill"
        case .failed:
            return "exclamationmark.circle"
        }
    }
}

extension ChatMessage {
    static var sampleMessages: [ChatMessage] {
        let now = Date()
        return [
            ChatMessage(
                type: .text,
                content: "Hi! I need some help with my kitchen renovation project.",
                timestamp: now.addingTimeInterval(-3600),
                isFromCurrentUser: true,
                status: .read
            ),
            ChatMessage(
                type: .text,
                content: "Of course! I'd be happy to help. Could you tell me more about what you're planning?",
                timestamp: now.addingTimeInterval(-3500),
                isFromCurrentUser: false,
                status: .read
            ),
            ChatMessage(
                type: .attachment,
                content: "Here are some sketches of what I'm thinking",
                timestamp: now.addingTimeInterval(-3400),
                isFromCurrentUser: true,
                attachments: ChatAttachment.sampleAttachments,
                status: .delivered
            ),
            ChatMessage(
                type: .videoCallRequest,
                content: "Would you like to discuss this over a video call?",
                timestamp: now.addingTimeInterval(-3300),
                isFromCurrentUser: false,
                status: .delivered
            ),
            ChatMessage(
                type: .videoCallAccepted,
                content: "Video call started",
                timestamp: now.addingTimeInterval(-3200),
                isFromCurrentUser: true,
                status: .sent
            ),
            ChatMessage(
                type: .videoCallEnded,
                content: "Video call ended",
                timestamp: now.addingTimeInterval(-3100),
                isFromCurrentUser: true,
                videoCallDuration: 900,
                status: .sent
            )
        ]
    }
} 