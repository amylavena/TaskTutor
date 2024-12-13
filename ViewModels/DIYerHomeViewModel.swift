import Foundation

class DIYerHomeViewModel: ObservableObject {
    @Published var recommendedProjects: [DIYProject] = [
        DIYProject(
            title: "Modern Coffee Table",
            description: "Build a sleek, modern coffee table perfect for any living room",
            category: .woodworking,
            difficulty: .intermediate,
            estimatedTime: 3600 * 6,
            materials: ["Wood", "Screws", "Wood Finish"],
            tools: ["Saw", "Drill", "Sandpaper"],
            thumbnailURL: "coffee_table",
            isPremium: true,
            price: 14.99,
            rating: 4.8,
            completions: 127
        ),
        DIYProject(
            title: "Herb Garden Planter",
            description: "Create a beautiful herb garden planter for your kitchen",
            category: .gardening,
            difficulty: .beginner,
            estimatedTime: 3600 * 2,
            materials: ["Wood", "Soil", "Seeds"],
            tools: ["Saw", "Drill", "Garden Tools"],
            thumbnailURL: "herb_garden",
            isPremium: false,
            price: nil,
            rating: 4.5,
            completions: 89
        )
    ]
} 