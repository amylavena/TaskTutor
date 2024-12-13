import SwiftUI

struct EnhancedProjectDetailView: View {
    let project: EnhancedProject
    @State private var selectedTab = 0
    @State private var showPurchaseSheet = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Image Carousel
                TabView {
                    ForEach(project.images, id: \.self) { imageURL in
                        AsyncImage(url: URL(string: imageURL)) { image in
                            image
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                        } placeholder: {
                            Rectangle()
                                .fill(Color.gray.opacity(0.2))
                        }
                    }
                }
                .frame(height: 300)
                .tabViewStyle(PageTabViewStyle())
                
                // Project Info Header
                VStack(alignment: .leading, spacing: 16) {
                    Text(project.title)
                        .font(.title)
                        .fontWeight(.bold)
                    
                    CreatorInfoView(creator: project.creator)
                    
                    ProjectStatsView(project: project)
                }
                .padding()
                
                // Content Tabs
                CustomTabBar(
                    tabs: ["Overview", "Materials", "Instructions", "Comments"],
                    selectedTab: $selectedTab
                )
                
                // Tab Content
                TabContent(project: project, selectedTab: selectedTab)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            if project.isPremium {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Purchase \(project.price ?? 0, specifier: "$%.2f")") {
                        showPurchaseSheet = true
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
        }
        .sheet(isPresented: $showPurchaseSheet) {
            ProjectPurchaseView(project: project)
        }
    }
}

struct CreatorInfoView: View {
    let creator: Creator
    
    var body: some View {
        HStack(spacing: 12) {
            AsyncImage(url: URL(string: creator.profileImage)) { image in
                image
                    .resizable()
                    .aspectRatio(contentMode: .fill)
            } placeholder: {
                Circle()
                    .fill(Color.gray.opacity(0.2))
            }
            .frame(width: 40, height: 40)
            .clipShape(Circle())
            
            VStack(alignment: .leading, spacing: 4) {
                Text(creator.name)
                    .font(.headline)
                HStack {
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                    Text(String(format: "%.1f", creator.rating))
                    Text("•")
                    Text("\(creator.projectsCount) projects")
                }
                .font(.caption)
                .foregroundColor(.secondary)
            }
        }
    }
}

struct ProjectStatsView: View {
    let project: EnhancedProject
    
    var body: some View {
        HStack(spacing: 16) {
            StatBadge(
                icon: "clock",
                text: "\(Int(project.estimatedTime/3600)) hrs"
            )
            StatBadge(
                icon: "star.fill",
                text: String(format: "%.1f", project.rating)
            )
            StatBadge(
                icon: "person.2",
                text: "\(project.completions)"
            )
        }
    }
} 