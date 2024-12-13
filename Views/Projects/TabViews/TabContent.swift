import SwiftUI

struct TabContent: View {
    let project: EnhancedProject
    let selectedTab: Int
    
    var body: some View {
        VStack {
            switch selectedTab {
            case 0:
                OverviewTab(project: project)
            case 1:
                MaterialsTab(project: project)
            case 2:
                InstructionsTab(project: project)
            case 3:
                CommentsTab(project: project)
            default:
                EmptyView()
            }
        }
    }
}

struct OverviewTab: View {
    let project: EnhancedProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("About this project")
                .font(.headline)
            
            Text(project.description)
                .foregroundColor(.secondary)
            
            DifficultySection(difficulty: project.difficulty)
            
            RequirementsSection(
                timeRequired: project.estimatedTime,
                toolsCount: project.tools.count,
                materialsCount: project.materials.count
            )
        }
        .padding()
    }
}

struct MaterialsTab: View {
    let project: EnhancedProject
    @State private var showingAllMaterials = false
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // Materials Section
            VStack(alignment: .leading, spacing: 12) {
                HStack {
                    Text("Materials Needed")
                        .font(.headline)
                    Spacer()
                    Text("\(project.materials.count) items")
                        .foregroundColor(.secondary)
                }
                
                ForEach(showingAllMaterials ? project.materials : Array(project.materials.prefix(3))) { material in
                    MaterialRow(material: material, style: .compact)
                }
                
                if project.materials.count > 3 && !showingAllMaterials {
                    Button("Show all materials") {
                        showingAllMaterials = true
                    }
                    .foregroundColor(.blue)
                }
            }
            
            Divider()
            
            // Tools Section
            VStack(alignment: .leading, spacing: 12) {
                Text("Tools Required")
                    .font(.headline)
                
                ForEach(project.tools) { tool in
                    ToolRow(tool: tool, style: .compact)
                }
            }
        }
        .padding()
    }
}