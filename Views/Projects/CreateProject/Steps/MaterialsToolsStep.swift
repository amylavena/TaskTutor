import SwiftUI

struct MaterialsToolsStep: View {
    @Binding var materials: [ProjectMaterial]
    @Binding var tools: [Tool]
    @State private var showingAddMaterial = false
    @State private var showingAddTool = false
    
    var body: some View {
        Form {
            Section(header: sectionHeader("Materials", action: { showingAddMaterial = true })) {
                ForEach(materials) { material in
                    MaterialRow(material: material, style: .detailed)
                }
                .onDelete { indexSet in
                    materials.remove(atOffsets: indexSet)
                }
            }
            
            Section(header: sectionHeader("Tools", action: { showingAddTool = true })) {
                ForEach(tools) { tool in
                    ToolRow(tool: tool, style: .detailed)
                }
                .onDelete { indexSet in
                    tools.remove(atOffsets: indexSet)
                }
            }
        }
        .sheet(isPresented: $showingAddMaterial) {
            AddMaterialView(materials: $materials)
        }
        .sheet(isPresented: $showingAddTool) {
            AddToolView(tools: $tools as Binding<[Tool]>)
        }
    }
    
    private func sectionHeader(_ title: String, action: @escaping () -> Void) -> some View {
        HStack {
            Text(title)
            Spacer()
            Button(action: action) {
                Image(systemName: "plus.circle.fill")
            }
        }
    }
}