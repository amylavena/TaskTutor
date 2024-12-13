import SwiftUI

struct CreateProjectView: View {
    @StateObject private var viewModel = CreateProjectViewModel()
    @Environment(\.dismiss) private var dismiss
    @State private var currentStep = 0
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Progress Bar
                ProgressBar(currentStep: currentStep, totalSteps: 4)
                    .padding()
                
                // Step Content
                TabView(selection: $currentStep) {
                    // Step 1: Basic Info
                    BasicInfoStep(
                        title: $viewModel.title,
                        description: $viewModel.description,
                        category: $viewModel.category,
                        difficulty: $viewModel.difficulty,
                        estimatedTime: $viewModel.estimatedTime
                    )
                    .tag(0)
                    
                    // Step 2: Materials & Tools
                    MaterialsToolsStep(
                        materials: $viewModel.materials,
                        tools: $viewModel.tools
                    )
                    .tag(1)
                    
                    // Step 3: Instructions
                    InstructionsStep(
                        instructions: $viewModel.instructions
                    )
                    .tag(2)
                    
                    // Step 4: Pricing & Publishing
                    PublishingStep(
                        isPremium: $viewModel.isPremium,
                        price: $viewModel.price,
                        isPublishing: viewModel.isPublishing,
                        onPublish: viewModel.publishProject
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Navigation Buttons
                NavigationFooter(
                    currentStep: $currentStep,
                    canProceed: viewModel.canProceedToNextStep(from: currentStep),
                    onBack: {
                        withAnimation {
                            currentStep -= 1
                        }
                    },
                    onNext: {
                        withAnimation {
                            currentStep += 1
                        }
                    }
                )
            }
            .navigationTitle("Create Project")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    if currentStep < 3 {
                        Button("Save Draft") {
                            viewModel.saveDraft()
                        }
                    }
                }
            }
            .alert("Error", isPresented: $viewModel.showError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(viewModel.errorMessage)
            }
        }
    }
}

struct ProgressBar: View {
    let currentStep: Int
    let totalSteps: Int
    
    var body: some View {
        HStack(spacing: 4) {
            ForEach(0..<totalSteps, id: \.self) { step in
                Rectangle()
                    .fill(step <= currentStep ? Color.theme.primary : Color.gray.opacity(0.3))
                    .frame(height: 4)
                    .animation(.spring(), value: currentStep)
            }
        }
    }
}

struct NavigationFooter: View {
    @Binding var currentStep: Int
    let canProceed: Bool
    let onBack: () -> Void
    let onNext: () -> Void
    
    var body: some View {
        HStack {
            if currentStep > 0 {
                Button(action: onBack) {
                    HStack {
                        Image(systemName: "chevron.left")
                        Text("Back")
                    }
                }
            }
            
            Spacer()
            
            if currentStep < 3 {
                Button(action: onNext) {
                    HStack {
                        Text("Next")
                        Image(systemName: "chevron.right")
                    }
                }
                .disabled(!canProceed)
            }
        }
        .padding()
        .background(Color.theme.cardBackground)
    }
} 