import SwiftUI

struct ToolDetailView: View {
    let tool: MarketplaceTool
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Tool Image
                Rectangle()
                    .fill(Color.gray.opacity(0.2))
                    .frame(height: 300)
                
                VStack(spacing: 16) {
                    // Tool Info
                    VStack(alignment: .leading, spacing: 8) {
                        Text(tool.name)
                            .font(.title2)
                            .fontWeight(.bold)
                        
                        HStack {
                            Text(String(format: "$%.2f", tool.pricePerDay))
                                .font(.title3)
                                .foregroundColor(Color.theme.primary)
                            Text("per day")
                                .font(.subheadline)
                                .foregroundColor(Color.theme.textSecondary)
                        }
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text("4.5")
                            Text("(24 reviews)")
                                .foregroundColor(Color.theme.textSecondary)
                        }
                        .font(.subheadline)
                    }
                    
                    Divider()
                    
                    // Description
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Description")
                            .font(.headline)
                        
                        Text(tool.description)
                            .font(.subheadline)
                            .foregroundColor(Color.theme.textSecondary)
                    }
                    
                    Divider()
                    
                    // Specifications
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Specifications")
                            .font(.headline)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            specificationRow(title: "Brand", value: "Premium Tools")
                            specificationRow(title: "Condition", value: "Excellent")
                            specificationRow(title: "Location", value: tool.location)
                        }
                    }
                    
                    // Rent Button
                    Button(action: {}) {
                        Text(tool.isAvailable ? "Rent Now" : "Not Available")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(tool.isAvailable ? Color.theme.primary : Color.gray)
                            .cornerRadius(12)
                    }
                    .disabled(!tool.isAvailable)
                    .padding(.top)
                }
                .padding()
            }
        }
        .navigationTitle("Tool Details")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    private func specificationRow(title: String, value: String) -> some View {
        HStack {
            Text(title)
                .foregroundColor(Color.theme.textSecondary)
            Spacer()
            Text(value)
        }
        .font(.subheadline)
    }
}

struct ToolDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ToolDetailView(tool: MarketplaceTool.sampleTool)
        }
    }
} 