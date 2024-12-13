import Foundation
import SwiftUI

struct DateRange {
    let start: Date
    let end: Date
}

struct MarketplaceTool: Identifiable {
    let id = UUID()
    let name: String
    let description: String
    let category: ToolCategory
    let pricePerDay: Double
    let imageURL: String
    let location: String
    let isAvailable: Bool
    let owner: User
    let availableDates: DateRange
    
    static let sampleTools = [
        MarketplaceTool(
            name: "DeWalt Power Drill",
            description: "Professional-grade 20V MAX cordless drill/driver. Perfect for woodworking and home improvement projects. Includes two batteries and charger.",
            category: .powerTools,
            pricePerDay: 25.00,
            imageURL: "drill_1",
            location: "Austin, TX",
            isAvailable: true,
            owner: User(name: "John Smith", email: "john@example.com", profilePhotoURL: "profile_1"),
            availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400 * 30))
        ),
        MarketplaceTool(
            name: "Craftsman Socket Set",
            description: "230-piece mechanics tool set with quick-release ratchets. Perfect for auto repair and maintenance.",
            category: .automotive,
            pricePerDay: 15.00,
            imageURL: "socket_set_1",
            location: "Round Rock, TX",
            isAvailable: true,
            owner: User(name: "Amy Wilson", email: "Amy@example.com", profilePhotoURL: "profile_2"),
            availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400 * 14))
        ),
        MarketplaceTool(
            name: "Honda 2000W Generator",
            description: "Quiet and fuel-efficient portable generator. Great for camping or backup power.",
            category: .electrical,
            pricePerDay: 45.00,
            imageURL: "generator_1",
            location: "Georgetown, TX",
            isAvailable: true,
            owner: User(name: "Mike Thompson", email: "mike@example.com", profilePhotoURL: "profile_3"),
            availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400 * 7))
        ),
        MarketplaceTool(
            name: "Werner 24ft Extension Ladder",
            description: "Heavy-duty aluminum extension ladder. Type IA 300 lb rating. Perfect for painting or roof access.",
            category: .ladders,
            pricePerDay: 20.00,
            imageURL: "ladder_1",
            location: "Buda, TX",
            isAvailable: true,
            owner: User(name: "Lisa Chen", email: "lisa@example.com", profilePhotoURL: "profile_4"),
            availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400 * 21))
        ),
        MarketplaceTool(
            name: "Pressure Washer 3000 PSI",
            description: "Gas-powered pressure washer with multiple nozzles. Great for deck cleaning and exterior washing.",
            category: .cleaning,
            pricePerDay: 35.00,
            imageURL: "pressure_washer_1",
            location: "Cedar Park, TX",
            isAvailable: true,
            owner: User(name: "David Garcia", email: "david@example.com", profilePhotoURL: "profile_5"),
            availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400 * 10))
        )
    ]
    
    static let sampleTool = sampleTools[0]
}

#if DEBUG
struct MarketplaceTool_Previews: PreviewProvider {
    static var previews: some View {
        List(MarketplaceTool.sampleTools) { tool in
            VStack(alignment: .leading) {
                Text(tool.name)
                    .font(.headline)
                Text(tool.location)
                    .font(.subheadline)
                Text("$\(tool.pricePerDay, specifier: "%.2f")/day")
                    .font(.caption)
            }
        }
    }
}
#endif

#if DEBUG
extension MarketplaceTool {
    static let previewTools = sampleTools
    
    static let previewTool = MarketplaceTool(
        name: "Preview Test Tool",
        description: "A tool for testing previews",
        category: .handTools,
        pricePerDay: 10.00,
        imageURL: "test_tool",
        location: "Test Location",
        isAvailable: true,
        owner: User(name: "Test User", email: "test@example.com", profilePhotoURL: "profile_test"),
        availableDates: DateRange(start: Date(), end: Date().addingTimeInterval(86400))
    )
}
#endif 
