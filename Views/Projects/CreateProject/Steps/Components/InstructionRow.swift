import SwiftUI

struct InstructionRow: View {
    let instruction: ProjectInstruction
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Step \(instruction.step)")
                .font(.headline)
            
            Text(instruction.title)
                .font(.subheadline)
                .foregroundColor(.secondary)
            
            if !instruction.imageURLs.isEmpty {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(instruction.imageURLs, id: \.self) { url in
                            AsyncImage(url: URL(string: url)) { image in
                                image
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                            } placeholder: {
                                Color.gray.opacity(0.2)
                            }
                            .frame(width: 60, height: 60)
                            .cornerRadius(8)
                        }
                    }
                }
            }
        }
    }
} 