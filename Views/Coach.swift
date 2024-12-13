struct Coach: Identifiable {
    let id = UUID()
    let name: String
    let categories: [ProjectCategory]
    let rating: Double
    let reviews: Int
    let hourlyRate: Int
    let skills: [String]
    let tags: [String]
    let imageURL: String
    let description: String
} 