import SwiftUI

struct RequirementsSection: View {
    let timeRequired: TimeInterval
    let toolsCount: Int
    let materialsCount: Int
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Requirements")
                .font(.headline)
            
            HStack(spacing: 16) {
                RequirementRow(icon: "clock", text: "\(Int(timeRequired/3600)) hours")
                RequirementRow(icon: "wrench", text: "\(toolsCount) tools")
                RequirementRow(icon: "cube.box", text: "\(materialsCount) materials")
            }
        }
    }
}

struct RequirementRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 4) {
            Image(systemName: icon)
                .foregroundColor(.gray)
            Text(text)
                .font(.subheadline)
                .foregroundColor(.gray)
        }
    }
} 