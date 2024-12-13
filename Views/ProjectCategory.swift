enum ProjectCategory: String, CaseIterable, Identifiable {
    case automotive = "Automotive"
    case electrical = "Electrical"
    case plumbing = "Plumbing"
    case carpentry = "Carpentry"
    case painting = "Painting"
    case gardening = "Gardening"
    case homeImprovement = "Home Improvement"
    case crafts = "Crafts"
    case cooking = "Cooking"
    case technology = "Technology"
    
    var id: String { rawValue }
    
    var name: String { rawValue }
    
    var color: Color {
        switch self {
        case .automotive:
            return Color(.systemBlue)
        case .electrical:
            return Color(.systemYellow)
        case .plumbing:
            return Color(.systemTeal)
        case .carpentry:
            return Color(.systemBrown)
        case .painting:
            return Color(.systemPurple)
        case .gardening:
            return Color(.systemGreen)
        case .homeImprovement:
            return Color(.systemOrange)
        case .crafts:
            return Color(.systemPink)
        case .cooking:
            return Color(.systemRed)
        case .technology:
            return Color(.systemIndigo)
        }
    }
    
    var icon: String {
        switch self {
        case .automotive:
            return "car.fill"
        case .electrical:
            return "bolt.fill"
        case .plumbing:
            return "drop.fill"
        case .carpentry:
            return "hammer.fill"
        case .painting:
            return "paintbrush.fill"
        case .gardening:
            return "leaf.fill"
        case .homeImprovement:
            return "house.fill"
        case .crafts:
            return "scissors"
        case .cooking:
            return "fork.knife"
        case .technology:
            return "desktopcomputer"
        }
    }
} 