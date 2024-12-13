import SwiftUI

struct InstructionsTab: View {
    let project: EnhancedProject
    @State private var expandedSteps: Set<UUID> = []
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            ForEach(project.instructions) { instruction in
                StepCard(
                    instruction: instruction,
                    isExpanded: expandedSteps.contains(instruction.id),
                    onTap: {
                        if expandedSteps.contains(instruction.id) {
                            expandedSteps.remove(instruction.id)
                        } else {
                            expandedSteps.insert(instruction.id)
                        }
                    }
                )
            }
        }
        .padding()
    }
}

struct StepCard: View {
    let instruction: ProjectInstruction
    let isExpanded: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: onTap) {
                HStack {
                    Text("Step \(instruction.step)")
                        .font(.headline)
                        .foregroundColor(.primary)
                    
                    Spacer()
                    
                    Image(systemName: "chevron.down")
                        .rotationEffect(.degrees(isExpanded ? 180 : 0))
                        .foregroundColor(.secondary)
                }
            }
            
            if isExpanded {
                Text(instruction.title)
                    .font(.subheadline)
                    .fontWeight(.medium)
                
                Text(instruction.description)
                    .font(.subheadline)
                    .foregroundColor(.secondary)
                
                if !instruction.imageURLs.isEmpty {
                    ScrollView(.horizontal, showsIndicators: false) {
                        HStack(spacing: 12) {
                            ForEach(instruction.imageURLs, id: \.self) { imageURL in
                                AsyncImage(url: URL(string: imageURL)) { image in
                                    image
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(width: 200, height: 150)
                                        .cornerRadius(8)
                                } placeholder: {
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 200, height: 150)
                                        .cornerRadius(8)
                                }
                            }
                        }
                    }
                }
            }
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.theme.shadowColor, radius: Color.theme.shadowRadius, x: 0, y: Color.theme.shadowY)
    }
} 