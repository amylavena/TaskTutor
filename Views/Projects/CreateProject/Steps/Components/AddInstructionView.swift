import SwiftUI
import PhotosUI

struct AddInstructionView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var instructions: [ProjectInstruction]
    
    @State private var title = ""
    @State private var description = ""
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var imageURLs: [String] = []
    
    var body: some View {
        NavigationView {
            Form {
                Section("Step Details") {
                    TextField("Title", text: $title)
                    TextEditor(text: $description)
                        .frame(height: 100)
                }
                
                Section("Images") {
                    PhotosPicker(
                        selection: $selectedItems,
                        maxSelectionCount: 5,
                        matching: .images
                    ) {
                        Label("Add Images", systemImage: "photo")
                    }
                    
                    if !imageURLs.isEmpty {
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(imageURLs, id: \.self) { url in
                                    AsyncImage(url: URL(string: url)) { image in
                                        image
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                    } placeholder: {
                                        Color.gray.opacity(0.2)
                                    }
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Add Step")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .confirmationAction) {
                    Button("Add") {
                        let newStep = ProjectInstruction(
                            step: instructions.count + 1,
                            title: title,
                            description: description,
                            imageURLs: imageURLs
                        )
                        instructions.append(newStep)
                        dismiss()
                    }
                    .disabled(title.isEmpty || description.isEmpty)
                }
            }
        }
    }
} 