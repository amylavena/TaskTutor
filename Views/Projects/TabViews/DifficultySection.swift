import SwiftUI

struct DifficultySection: View {
    let difficulty: ProjectDifficulty
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Difficulty")
                .font(.headline)
            
            HStack {
                ForEach(0..<3) { index in
                    Image(systemName: "star.fill")
                        .foregroundColor(getDifficultyColor(index))
                }
                Text(difficulty.rawValue)
                    .foregroundColor(.secondary)
            }
        }
    }
    
    private func getDifficultyColor(_ index: Int) -> Color {
        switch difficulty {
        case .beginner:
            return index == 0 ? .green : .gray
        case .intermediate:
            return index <= 1 ? .orange : .gray
        case .advanced:
            return .red
        }
    }
} 