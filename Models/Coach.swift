import Foundation

struct Coach: Identifiable, Codable, Hashable {
    let id: String
    let name: String
    let category: ProjectCategory
    let rating: Double
    let reviewCount: Int
    let hourlyRate: Int
    let expertise: [String]
    let projectTypes: [String]
    let interests: [String]
    let skills: [String]
    let description: String?
    let imageURL: String
    let reviews: [Review]
    let rates: [Rate]
    let projectPhotos: [String]
    let instagramPhotos: [String]
    var profileImage: String
    
    var displayImage: String {
        print("DEBUG: Coach name: \(name)")
        print("DEBUG: Image URL: \(imageURL)")
        print("DEBUG: Profile Image: \(profileImage)")
        return imageURL
    }
    
    enum CodingKeys: String, CodingKey {
        case id
        case name
        case category
        case rating
        case reviewCount = "reviews"
        case hourlyRate = "hourly_rate"
        case expertise
        case projectTypes = "project_types"
        case interests
        case skills
        case description
        case imageURL = "image_url"
        case reviews = "review_list"
        case rates
        case projectPhotos = "project_photos"
        case instagramPhotos = "instagram_photos"
    }
    
    init(id: String, 
         name: String, 
         category: ProjectCategory,
         rating: Double,
         reviewCount: Int,
         hourlyRate: Int,
         expertise: [String],
         projectTypes: [String],
         interests: [String],
         skills: [String],
         description: String?,
         imageURL: String = "default_profile",
         reviews: [Review],
         rates: [Rate],
         projectPhotos: [String],
         instagramPhotos: [String],
         profileImage: String = "default_profile") {
        self.id = id
        self.name = name
        self.category = category
        self.rating = rating
        self.reviewCount = reviewCount
        self.hourlyRate = hourlyRate
        self.expertise = expertise
        self.projectTypes = projectTypes
        self.interests = interests
        self.skills = skills
        self.description = description
        self.imageURL = imageURL
        self.reviews = reviews
        self.rates = rates
        self.projectPhotos = projectPhotos
        self.instagramPhotos = instagramPhotos
        self.profileImage = profileImage
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        name = try container.decode(String.self, forKey: .name)
        category = try container.decode(ProjectCategory.self, forKey: .category)
        rating = try container.decode(Double.self, forKey: .rating)
        reviewCount = try container.decode(Int.self, forKey: .reviewCount)
        hourlyRate = try container.decode(Int.self, forKey: .hourlyRate)
        expertise = try container.decode([String].self, forKey: .expertise)
        projectTypes = try container.decode([String].self, forKey: .projectTypes)
        interests = try container.decode([String].self, forKey: .interests)
        skills = try container.decode([String].self, forKey: .skills)
        description = try container.decodeIfPresent(String.self, forKey: .description)
        imageURL = try container.decode(String.self, forKey: .imageURL)
        reviews = try container.decode([Review].self, forKey: .reviews)
        rates = try container.decode([Rate].self, forKey: .rates)
        projectPhotos = try container.decode([String].self, forKey: .projectPhotos)
        instagramPhotos = try container.decode([String].self, forKey: .instagramPhotos)
        profileImage = imageURL  // Set profileImage to match imageURL
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)  // Just use id since it's unique
    }
    
    static func == (lhs: Coach, rhs: Coach) -> Bool {
        lhs.id == rhs.id  // Compare by id
    }
}

extension Coach {
    static let tedSample = Coach(
        id: "1",
        name: "Ted",
        category: .woodworking,
        rating: 5.0,
        reviewCount: 150,
        hourlyRate: 75,
        expertise: ["Woodworking", "Furniture Making", "Home Improvement"],
        projectTypes: ["Custom Furniture", "Built-ins", "Home Repairs"],
        interests: ["Teaching", "Sustainable Wood", "Traditional Techniques"],
        skills: ["Joining techniques", "Sanding and finishing", "Tool education", "Basic carpentry", 
                "Measuring", "Framing basics", "Project planning", "Repairs", "Flooring"],
        description: """
            Ted is a passionate and experienced carpenter dedicated to empowering DIYers with essential woodworking skills.

            With over a decade of hands-on experience in carpentry, Ted has honed his craft through various projects, from building custom furniture to renovating homes. He believes that anyone can become a confident DIYer with the right guidance and techniques.

            As a verified coach, Ted specializes in teaching beginners the foundational skills of carpentry, including measuring, cutting, and joining materials. His approachable teaching style focuses on creating a supportive and encouraging environment where DIYers can learn at their own pace.
            """,
        imageURL: "ted_profile",
        reviews: [
            Review(
                id: "1",
                authorName: "Lisa C.",
                date: Date(),
                rating: 5,
                comment: "I recently completed a coaching session with Ted to learn how to install a floating shelf in my living room, and I couldn't be happier! As a beginner DIYer, I was a bit intimidated, but Ted made the process easy and enjoyable.\n\nHe provided a clear list of tools and materials needed, including a level, drill, stud finder, saw, wood screws, and the shelf itself. Ted guided us through each step, from measuring and marking to securing the shelf to the wall.",
                isVerified: true
            ),
            Review(
                id: "2",
                authorName: "Sue H.",
                date: Date(),
                rating: 5,
                comment: "Love my consult with Ted! As someone new to woodworking, I was a bit nervous about using a table saw, but Ted made me feel comfortable and confident from the start.\n\nHe focused not only on the mechanics of using the table saw but also on essential safety measures. He taught me how to properly set up the saw, adjust the blade height, and use push sticks to keep my hands safe while cutting. His emphasis on wearing safety gear and understanding the tool's operation was excellent.",
                isVerified: true
            )
        ],
        rates: [
            // Regular Sessions
            Rate(
                id: "1",
                type: .onsite,
                title: "In-Person Workshop",
                price: 75,
                duration: 120,
                description: "Hands-on guidance at your location",
                additionalInfo: [
                    "Travel within 10 miles included",
                    "Travel fee applies for greater distances",
                    "All skill levels welcome",
                    "Tools and safety equipment provided"
                ],
                isPackage: false
            ),
            Rate(
                id: "2",
                type: .virtual,
                title: "Virtual Project Planning",
                price: 50,
                duration: 60,
                description: "Detailed project planning and consultation",
                additionalInfo: [
                    "Project material list creation",
                    "Step-by-step project timeline",
                    "Tool recommendations",
                    "Budget planning assistance"
                ],
                isPackage: false
            ),
            Rate(
                id: "3",
                type: .text,
                title: "Quick DIY Support",
                price: 15,
                duration: 30,
                description: "Quick text-based help for small issues",
                additionalInfo: [
                    "Rapid response within 2 hours",
                    "Photo sharing for better assistance",
                    "Perfect for quick questions",
                    "Available 7 days a week"
                ],
                isPackage: false
            ),
            Rate(
                id: "4",
                type: .call,
                title: "Phone Consultation",
                price: 25,
                duration: 30,
                description: "Direct phone guidance for immediate help",
                additionalInfo: [
                    "Available for urgent issues",
                    "Screen sharing option available",
                    "Follow-up summary provided",
                    "Flexible scheduling"
                ],
                isPackage: false
            ),
            
            // Package Deals
            Rate(
                id: "5",
                type: .virtual,
                title: "DIY Starter Package",
                price: 199,
                duration: 240,
                description: "Complete introduction to woodworking",
                additionalInfo: [
                    "4 one-hour virtual sessions",
                    "Basic tool guide included",
                    "Safety training included",
                    "Save $50 compared to individual sessions",
                    "Valid for 3 months"
                ],
                isPackage: true
            ),
            Rate(
                id: "6",
                type: .onsite,
                title: "Project Mastery Package",
                price: 499,
                duration: 480,
                description: "Comprehensive project completion support",
                additionalInfo: [
                    "8 hours of in-person guidance",
                    "Materials shopping assistance",
                    "Tool selection guidance",
                    "Save $100 compared to individual sessions",
                    "Can be split across multiple days"
                ],
                isPackage: true
            ),
            Rate(
                id: "7",
                type: .virtual,
                title: "Monthly Mentorship",
                price: 299,
                duration: 360,
                description: "Ongoing support for multiple projects",
                additionalInfo: [
                    "6 hours of virtual sessions",
                    "Unlimited text support",
                    "Monthly project review",
                    "Save $150 compared to individual sessions",
                    "30-day satisfaction guarantee"
                ],
                isPackage: true
            )
        ],
        projectPhotos: ["ted_project_1", "ted_project_2", "ted_project_3"],
        instagramPhotos: ["ted_insta_1", "ted_insta_2", "ted_insta_3"],
        profileImage: "ted_profile"
    )
} 