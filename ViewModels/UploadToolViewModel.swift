import SwiftUI

class UploadToolViewModel: ObservableObject {
    @Published var selectedImages: [UIImage] = []
    @Published var toolName = ""
    @Published var description = ""
    @Published var category: ToolCategory?
    @Published var pricePerDay = ""
    @Published var location = ""
    
    var isValidForm: Bool {
        !selectedImages.isEmpty &&
        !toolName.isEmpty &&
        !description.isEmpty &&
        category != nil &&
        !pricePerDay.isEmpty &&
        !location.isEmpty
    }
    
    func removeImage(_ image: UIImage) {
        selectedImages.removeAll { $0 == image }
    }
    
    func uploadTool() {
        guard let category = category,
              let price = Double(pricePerDay),
              let currentUser = UserViewModel().currentUser else { return }
        
        // Create tool object but don't assign it yet since we need to upload images first
        _ = MarketplaceTool(
            name: toolName,
            description: description,
            category: category,
            pricePerDay: price,
            imageURL: "",
            location: location,
            isAvailable: true,
            owner: currentUser,
            availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400 * 30))
        )
    }
} 