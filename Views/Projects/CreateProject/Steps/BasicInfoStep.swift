import SwiftUI

struct BasicInfoStep: View {
    @Binding var title: String
    @Binding var description: String
    @Binding var category: ProjectCategory
    @Binding var difficulty: ProjectDifficulty
    @Binding var estimatedTime: TimeInterval
    
    var body: some View {
        Form {
            Section("Basic Information") {
                TextField("Project Title", text: $title)
                
                TextEditor(text: $description)
                    .frame(height: 100)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8)
                            .stroke(Color.gray.opacity(0.2))
                    )
            }
            
            Section("Details") {
                Picker("Category", selection: $category) {
                    ForEach(ProjectCategory.allCases, id: \.self) { category in
                        Text(category.rawValue).tag(category)
                    }
                }
                
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(ProjectDifficulty.allCases, id: \.self) { difficulty in
                        Text(difficulty.rawValue).tag(difficulty)
                    }
                }
                
                Stepper(
                    "Estimated Time: \(Int(estimatedTime/3600)) hours",
                    value: $estimatedTime,
                    in: 3600...86400,
                    step: 3600
                )
            }
        }
    }
} 