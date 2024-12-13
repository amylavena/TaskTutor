import SwiftUI

struct ProjectPurchaseView: View {
    let project: EnhancedProject
    @Environment(\.dismiss) private var dismiss
    @State private var isProcessing = false
    @State private var showingError = false
    @State private var errorMessage = ""
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Project Preview
                    VStack(spacing: 12) {
                        AsyncImage(url: URL(string: project.images.first ?? "")) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                        .frame(height: 200)
                        .cornerRadius(12)
                        
                        Text(project.title)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        CreatorInfoView(creator: project.creator)
                    }
                    
                    // What's Included
                    VStack(alignment: .leading, spacing: 16) {
                        Text("What's Included")
                            .font(.headline)
                        
                        IncludedFeatureRow(icon: "list.bullet", text: "\(project.instructions.count) detailed steps")
                        IncludedFeatureRow(icon: "photo", text: "Step-by-step photos")
                        IncludedFeatureRow(icon: "cart", text: "Material links")
                        IncludedFeatureRow(icon: "questionmark.circle", text: "Creator support")
                    }
                    .padding()
                    .background(Color.theme.cardBackground)
                    .cornerRadius(12)
                    
                    // Price and Purchase
                    VStack(spacing: 16) {
                        if let price = project.price {
                            Text("$\(price, specifier: "%.2f")")
                                .font(.title)
                                .fontWeight(.bold)
                        }
                        
                        Button(action: purchaseProject) {
                            if isProcessing {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            } else {
                                Text("Purchase Instructions")
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(isProcessing)
                    }
                }
                .padding()
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
            .alert("Error", isPresented: $showingError) {
                Button("OK", role: .cancel) {}
            } message: {
                Text(errorMessage)
            }
        }
    }
    
    private func purchaseProject() {
        isProcessing = true
        // Add purchase logic here
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            isProcessing = false
            dismiss()
        }
    }
}

struct IncludedFeatureRow: View {
    let icon: String
    let text: String
    
    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundColor(.green)
            Text(text)
                .font(.subheadline)
        }
    }
} 