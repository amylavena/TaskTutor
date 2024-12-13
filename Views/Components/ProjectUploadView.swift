import SwiftUI
import PhotosUI

struct ProjectUploadView: View {
    @Environment(\.dismiss) var dismiss
    @ObservedObject var viewModel: CoachViewModel
    @State private var selectedItem: PhotosPickerItem?
    @State private var projectTitle = ""
    @State private var projectDescription = ""
    
    var body: some View {
        NavigationView {
            Form {
                Section("Project Photo") {
                    PhotosPicker(selection: $selectedItem, matching: .images) {
                        if let image = viewModel.selectedProjectImage {
                            Image(uiImage: image)
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(height: 200)
                                .frame(maxWidth: .infinity)
                                .clipShape(RoundedRectangle(cornerRadius: 12))
                        } else {
                            HStack {
                                Image(systemName: "photo.fill")
                                Text("Select Photo")
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 200)
                            .background(Color.gray.opacity(0.1))
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                        }
                    }
                }
                
                Section("Project Details") {
                    TextField("Project Title", text: $projectTitle)
                    TextField("Description", text: $projectDescription, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("Add Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Upload") {
                        viewModel.uploadProject(
                            title: projectTitle,
                            description: projectDescription
                        )
                        dismiss()
                    }
                    .disabled(!viewModel.canUploadProject)
                }
            }
        }
        .onChange(of: selectedItem) { oldValue, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    await viewModel.setSelectedProjectImage(image)
                }
            }
        }
    }
}