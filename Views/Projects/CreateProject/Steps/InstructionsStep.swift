import SwiftUI

struct InstructionsStep: View {
    @Binding var instructions: [ProjectInstruction]
    @State private var showingAddInstruction = false
    
    var body: some View {
        VStack {
            List {
                ForEach(instructions) { instruction in
                    InstructionRow(instruction: instruction)
                }
                .onMove { from, to in
                    instructions.move(fromOffsets: from, toOffset: to)
                    updateStepNumbers()
                }
                .onDelete { indexSet in
                    instructions.remove(atOffsets: indexSet)
                    updateStepNumbers()
                }
            }
            
            Button(action: { showingAddInstruction = true }) {
                HStack {
                    Image(systemName: "plus.circle.fill")
                    Text("Add Step")
                }
            }
            .padding()
        }
        .sheet(isPresented: $showingAddInstruction) {
            AddInstructionView(instructions: $instructions)
        }
    }
    
    private func updateStepNumbers() {
        for (index, _) in instructions.enumerated() {
            instructions[index] = ProjectInstruction(
                step: index + 1,
                title: instructions[index].title,
                description: instructions[index].description,
                imageURLs: instructions[index].imageURLs
            )
        }
    }
} 