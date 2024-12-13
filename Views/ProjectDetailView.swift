import SwiftUI

struct ProjectDetailView: View {
    let project: DIYProject
    @State private var selectedTab = 0
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 0) {
                // Project Image
                if let url = URL(string: project.thumbnailURL) {
                    AsyncImage(url: url) { image in
                        image
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } placeholder: {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                    }
                    .frame(height: 300)
                }
                
                VStack(alignment: .leading, spacing: 24) {
                    // Title
                    Text(project.title)
                        .font(.largeTitle)
                        .fontWeight(.bold)
                    
                    // Creator Info
                    HStack(spacing: 12) {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 50, height: 50)
                        
                        VStack(alignment: .leading, spacing: 4) {
                            Text("John Woodworker")
                                .font(.headline)
                            HStack {
                                Image(systemName: "star.fill")
                                    .foregroundColor(.yellow)
                                Text("4.9")
                                Text("•")
                                Text("15 projects")
                                    .foregroundColor(.secondary)
                            }
                            .font(.subheadline)
                        }
                    }
                    
                    // Stats
                    HStack(spacing: 16) {
                        StatBadge(icon: "clock", text: "6 hrs")
                        StatBadge(icon: "star.fill", text: "4.8")
                        StatBadge(icon: "person.2.fill", text: "127")
                    }
                    
                    // Tabs
                    CustomTabBar(
                        tabs: ["Overview", "Materials", "Instructions", "Comments"],
                        selectedTab: $selectedTab
                    )
                    
                    // Tab Content
                    switch selectedTab {
                    case 0:
                        OverviewContent(project: project)
                    case 1:
                        MaterialsContent(project: project)
                    case 2:
                        InstructionsContent(project: project)
                    case 3:
                        CommentsContent(project: project)
                    default:
                        EmptyView()
                    }
                }
                .padding()
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                if project.isPremium {
                    Button("Purchase $14.99") {
                        // Purchase action
                    }
                    .foregroundColor(.white)
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(Color.theme.primary)
                    .cornerRadius(20)
                }
            }
        }
    }
}

struct OverviewContent: View {
    let project: DIYProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // About
            VStack(alignment: .leading, spacing: 16) {
                Text("About this project")
                    .font(.title2)
                    .fontWeight(.bold)
                
                Text(project.description)
                    .foregroundColor(.secondary)
            }
            
            // Difficulty
            VStack(alignment: .leading, spacing: 16) {
                Text("Difficulty")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 4) {
                    ForEach(0..<3) { index in
                        Image(systemName: "star.fill")
                            .foregroundColor(index < 2 ? .orange : .gray)
                    }
                    Text("Intermediate")
                        .foregroundColor(.secondary)
                }
            }
            
            // Requirements
            VStack(alignment: .leading, spacing: 16) {
                Text("Requirements")
                    .font(.title2)
                    .fontWeight(.bold)
                
                HStack(spacing: 24) {
                    StatBadge(icon: "clock", text: "6 hours")
                    StatBadge(icon: "wrench", text: "\(project.tools.count) tools")
                    StatBadge(icon: "cube.box", text: "\(project.materials.count) materials")
                }
            }
        }
    }
}

struct MaterialsContent: View {
    let project: DIYProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Materials Section
            VStack(alignment: .leading, spacing: 16) {
                HStack {
                    Text("Materials Needed")
                        .font(.title2)
                        .fontWeight(.bold)
                    Spacer()
                    Text("\(project.materials.count) items")
                        .foregroundColor(.secondary)
                }
                
                ForEach(project.materials, id: \.self) { material in
                    HStack {
                        Text(material)
                        Spacer()
                        Image(systemName: "cart")
                            .foregroundColor(.blue)
                    }
                    .padding(.vertical, 8)
                    Divider()
                }
            }
            
            // Tools Section
            VStack(alignment: .leading, spacing: 16) {
                Text("Tools Required")
                    .font(.title2)
                    .fontWeight(.bold)
                
                ForEach(project.tools, id: \.self) { tool in
                    HStack {
                        Text(tool)
                        Spacer()
                        if tool.contains("Power") {
                            Text("Power Tool")
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(Color.red.opacity(0.1))
                                .foregroundColor(.red)
                                .cornerRadius(4)
                        }
                    }
                    .padding(.vertical, 8)
                    Divider()
                }
            }
        }
    }
}

struct InstructionsContent: View {
    let project: DIYProject
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            // Placeholder for when project is not purchased
            if project.isPremium {
                VStack(spacing: 16) {
                    Image(systemName: "lock.fill")
                        .font(.system(size: 48))
                        .foregroundColor(.secondary)
                    
                    Text("Purchase this project to view instructions")
                        .font(.headline)
                        .multilineTextAlignment(.center)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .padding()
            } else {
                Text("Instructions will be available here")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding()
            }
        }
    }
}

struct CommentsContent: View {
    let project: DIYProject
    @State private var newComment = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            // Comment Input
            HStack {
                TextField("Add a comment...", text: $newComment)
                    .textFieldStyle(RoundedBorderTextFieldStyle())
                
                Button("Post") {
                    // Post comment action
                }
                .disabled(newComment.isEmpty)
            }
            
            // Sample Comments
            ForEach(0..<3) { _ in
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Circle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(width: 32, height: 32)
                        
                        VStack(alignment: .leading) {
                            Text("User Name")
                                .font(.subheadline)
                                .fontWeight(.medium)
                            Text("2 days ago")
                                .font(.caption)
                                .foregroundColor(.secondary)
                        }
                    }
                    
                    Text("Great project! The instructions were very clear and easy to follow.")
                        .font(.subheadline)
                    
                    HStack {
                        Button(action: {}) {
                            Label("12", systemImage: "heart")
                        }
                        Button(action: {}) {
                            Label("Reply", systemImage: "arrowshape.turn.up.left")
                        }
                    }
                    .font(.caption)
                    .foregroundColor(.secondary)
                }
                .padding()
                .background(Color.theme.cardBackground)
                .cornerRadius(12)
            }
        }
    }
}

struct ProjectDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            ProjectDetailView(
                project: DIYProject(
                    title: "Modern Coffee Table",
                    description: "Build a sleek, modern coffee table perfect for any living room",
                    category: ProjectCategory.woodworking,
                    difficulty: .intermediate,
                    estimatedTime: 3600 * 6,
                    materials: ["Wood", "Screws", "Wood Finish"],
                    tools: ["Saw", "Drill", "Sandpaper"],
                    thumbnailURL: "coffee_table",
                    isPremium: true,
                    price: 14.99,
                    rating: 4.8,
                    completions: 127
                )
            )
        }
    }
} 