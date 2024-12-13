import SwiftUI

struct MarketplaceView: View {
    @State private var searchText = ""
    @State private var selectedTab = "For you"
    @State private var showingCategories = false
    
    let tabs = ["Sell", "For you", "Local"]
    let sampleTools = MarketplaceTool.sampleTools
    
    var filteredTools: [MarketplaceTool] {
        if searchText.isEmpty {
            return sampleTools
        }
        return sampleTools.filter { tool in
            tool.name.localizedCaseInsensitiveContains(searchText) ||
            tool.description.localizedCaseInsensitiveContains(searchText) ||
            tool.category.rawValue.localizedCaseInsensitiveContains(searchText)
        }
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Top Navigation Bar
                HStack {
                    Text("Marketplace")
                        .font(.largeTitle)
                        .bold()
                    Spacer()
                    Button(action: { /* Search action */ }) {
                        Image(systemName: "magnifyingglass")
                            .font(.title)
                            .foregroundColor(.gray)
                    }
                }
                .padding()
                
                // Tab Bar
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 20) {
                        ForEach(tabs, id: \.self) { tab in
                            Button(action: { selectedTab = tab }) {
                                Text(tab)
                                    .foregroundColor(selectedTab == tab ? .white : .gray)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedTab == tab ? Color.blue : Color.clear)
                                    .cornerRadius(20)
                            }
                        }
                        
                        Menu {
                            Button("Top Categories", action: {})
                            Button("Power Tools", action: {})
                            Button("Hand Tools", action: {})
                            Button("Gardening", action: {})
                            Button("All Categories", action: {})
                        } label: {
                            HStack {
                                Text("More")
                                Image(systemName: "chevron.down")
                            }
                            .foregroundColor(.gray)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 8)
                        }
                    }
                    .padding(.horizontal)
                }
                .padding(.vertical, 8)
                
                Divider()
                
                // Main Content
                ScrollView {
                    VStack(alignment: .leading, spacing: 16) {
                        HStack {
                            Text("Today's picks")
                                .font(.title2)
                                .bold()
                            Spacer()
                            Button(action: {}) {
                                HStack {
                                    Image(systemName: "location.fill")
                                    Text("Buda, Texas")
                                        .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.horizontal)
                        
                        LazyVGrid(
                            columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ],
                            spacing: 16
                        ) {
                            ForEach(filteredTools) { tool in
                                NavigationLink(destination: ToolDetailView(tool: tool)) {
                                    ToolCard(tool: tool)
                                }
                            }
                        }
                        .padding(.horizontal)
                    }
                }
            }
            .navigationBarHidden(true)
        }
    }
}

// Update ToolCard to accept a tool
struct ToolCard: View {
    let tool: MarketplaceTool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // Tool Image
            Rectangle()
                .fill(Color.gray.opacity(0.2))
                .frame(height: 120)
                .cornerRadius(8)
            
            // Tool Info
            VStack(alignment: .leading, spacing: 4) {
                Text(tool.name)  // Use tool name
                    .font(.headline)
                    .lineLimit(1)
                
                Text(String(format: "$%.2f", tool.pricePerDay))  // Use tool price
                    .font(.subheadline)
                    .foregroundColor(Color.theme.primary)
                
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text("4.5")
                        .font(.caption)
                    Text("(24)")
                        .font(.caption)
                        .foregroundColor(Color.theme.textSecondary)
                }
            }
        }
        .padding()
        .background(Color.theme.cardBackground)
        .cornerRadius(12)
        .shadow(color: Color.theme.shadowColor, radius: Color.theme.shadowRadius, x: 0, y: Color.theme.shadowY)
    }
}

struct MarketplaceView_Previews: PreviewProvider {
    static var previews: some View {
        MarketplaceView()
    }
} 