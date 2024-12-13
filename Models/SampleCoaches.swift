import Foundation

extension Coach {
    static let sampleCoaches: [Coach] = [
        // Ted (Woodworking Expert)
        .tedSample,
        
        // Mike (Electrical Expert)
        Coach(
            id: "2",
            name: "Mike Thompson",
            category: .electrical,
            rating: 4.9,
            reviewCount: 156,
            hourlyRate: 65,
            expertise: ["Electrical Systems", "Home Automation", "Smart Home Integration"],
            projectTypes: ["Wiring", "Panel Installation", "Smart Home Setup"],
            interests: ["Smart Home", "Energy Efficiency", "Home Safety"],
            skills: ["Electrical Wiring", "Smart Home", "Panel Installation", "Lighting Design"],
            description: """
                Mike is a master electrician with over 15 years of experience in residential and commercial electrical work.
                
                Specializing in smart home integration and modern electrical solutions, Mike has helped countless homeowners upgrade their electrical systems and implement cutting-edge home automation technology.
                
                As a certified electrical coach, Mike focuses on teaching DIYers how to safely handle basic electrical projects while knowing when to call in a professional. His practical approach emphasizes safety and understanding of electrical fundamentals.
                """,
            imageURL: "mike_profile",
            reviews: [
                Review(
                    id: "1",
                    authorName: "John D.",
                    date: Date(),
                    rating: 5,
                    comment: "Mike's expertise in smart home integration is unmatched. He guided me through my whole-house automation project with patience and deep knowledge.",
                    isVerified: true
                )
            ],
            rates: [
                Rate(
                    id: "1",
                    type: .virtual,
                    title: "Initial Consultation",
                    price: 65,
                    duration: 30,
                    description: "Virtual consultation to discuss your electrical project and safety considerations",
                    additionalInfo: ["Safety assessment", "Project planning", "Code requirements"],
                    isPackage: false
                )
            ],
            projectPhotos: ["mike_project_1", "mike_project_2", "mike_project_3"],
            instagramPhotos: ["mike_insta_1", "mike_insta_2", "mike_insta_3"],
            profileImage: "mike_profile"
        ),
        
        // Sue (Crafts Expert)
        Coach(
            id: "3",
            name: "Sue Walls",
            category: .crafts,
            rating: 4.8,
            reviewCount: 98,
            hourlyRate: 45,
            expertise: ["Ceramics", "Pottery", "Sculpture", "Art Education"],
            projectTypes: ["Hand Building", "Wheel Throwing", "Glazing", "Decorative Arts"],
            interests: ["Arts Education", "Sustainable Crafts", "Traditional Techniques"],
            skills: ["Pottery", "Ceramics", "Sculpture", "Glazing", "Kiln Operation"],
            description: """
                Sue is a professional ceramics artist and dedicated instructor with a passion for making pottery accessible to everyone.
                
                With an MFA in Ceramics and over 8 years of teaching experience, Sue has developed a teaching style that combines traditional techniques with modern approaches. She believes that working with clay is not just about creating objects, but about connecting with an ancient craft that spans cultures and centuries.
                
                Her studio practice focuses on functional pottery and sculptural works, and she loves sharing both the technical skills and creative aspects of ceramics with her students. Sue specializes in helping beginners develop their skills and confidence at the potter's wheel.
                """,
            imageURL: "sue_profile",
            reviews: [
                Review(
                    id: "1",
                    authorName: "Emily R.",
                    date: Date(),
                    rating: 5,
                    comment: "Sue's patience and expertise made learning pottery so enjoyable. She has a gift for explaining complex techniques in simple terms.",
                    isVerified: true
                ),
                Review(
                    id: "2",
                    authorName: "Mark L.",
                    date: Date(),
                    rating: 5,
                    comment: "Great teacher! I went from never touching clay to making my own bowls in just a few sessions.",
                    isVerified: true
                )
            ],
            rates: [
                Rate(
                    id: "1",
                    type: .onsite,
                    title: "Beginner Wheel Throwing",
                    price: 75,
                    duration: 90,
                    description: "One-on-one instruction in basic wheel throwing techniques",
                    additionalInfo: ["Clay included", "Tools provided", "Firing available"],
                    isPackage: false
                ),
                Rate(
                    id: "2",
                    type: .onsite,
                    title: "Pottery Basics Package",
                    price: 299,
                    duration: 120,
                    description: "Four-session package covering hand building and wheel throwing",
                    additionalInfo: ["Materials included", "Take home 3-4 finished pieces", "Glazing instruction"],
                    isPackage: true
                )
            ],
            projectPhotos: ["sue_project_1", "sue_project_2", "sue_project_3"],
            instagramPhotos: ["sue_insta_1", "sue_insta_2", "sue_insta_3"],
            profileImage: "sue_profile"
        ),
        
        // Additional Woodworking Coaches
        Coach(
            id: "4",
            name: "Maria Garcia",
            category: .woodworking,
            rating: 4.9,
            reviewCount: 134,
            hourlyRate: 70,
            expertise: ["Fine Furniture", "Wood Carving", "Artistic Woodwork"],
            projectTypes: ["Custom Furniture", "Decorative Pieces", "Wood Sculpture"],
            interests: ["Art", "Sustainable Wood", "Teaching"],
            skills: ["Wood carving", "Furniture design", "Artistic techniques", "Fine finishing", "Tool mastery"],
            description: """
                Maria combines traditional woodworking with artistic expression, specializing in decorative furniture and sculptural pieces.
                
                With a background in fine arts and 12 years of woodworking experience, she helps DIYers develop both technical skills and creative vision.
                """,
            imageURL: "maria_profile",
            reviews: [
                Review(
                    id: "1",
                    authorName: "Rachel K.",
                    date: Date(),
                    rating: 5,
                    comment: "Maria's artistic approach to woodworking opened my eyes to what's possible. She taught me how to incorporate decorative elements into functional pieces, and her carving techniques are amazing.",
                    isVerified: true
                ),
                Review(
                    id: "2",
                    authorName: "James M.",
                    date: Date(),
                    rating: 5,
                    comment: "I came to learn basic furniture making but got so much more. Maria's attention to design and finishing details transformed my project from simple to stunning.",
                    isVerified: true
                )
            ],
            rates: [
                Rate(
                    id: "1",
                    type: .onsite,
                    title: "Artistic Woodworking Basics",
                    price: 85,
                    duration: 120,
                    description: "Introduction to decorative woodworking techniques",
                    additionalInfo: ["Tools provided", "Materials included", "Take home a carved piece"],
                    isPackage: false
                ),
                Rate(
                    id: "2",
                    type: .onsite,
                    title: "Furniture Design Workshop",
                    price: 399,
                    duration: 480,
                    description: "Four-session course on designing and building artistic furniture",
                    additionalInfo: [
                        "Design consultation included",
                        "Advanced carving techniques",
                        "Finishing methods",
                        "Small project completion"
                    ],
                    isPackage: true
                )
            ],
            projectPhotos: ["maria_project_1", "maria_project_2", "maria_project_3"],
            instagramPhotos: ["maria_insta_1", "maria_insta_2", "maria_insta_3"],
            profileImage: "maria_profile"
        ),
        
        // Additional Pottery/Crafts Coach
        Coach(
            id: "5",
            name: "David Chen",
            category: .crafts,
            rating: 4.9,
            reviewCount: 112,
            hourlyRate: 55,
            expertise: ["Ceramics", "Glaze Chemistry", "Raku Firing"],
            projectTypes: ["Functional Pottery", "Raku", "Custom Glazes"],
            interests: ["Japanese Ceramics", "Glaze Development", "Teaching"],
            skills: ["Wheel throwing", "Glaze mixing", "Raku firing", "Hand building", "Kiln operation"],
            description: """
                David specializes in Japanese pottery techniques and custom glaze development.
                
                With an emphasis on the science behind ceramics, he helps students understand both the artistic and technical aspects of pottery.
                """,
            imageURL: "david_profile",
            reviews: [
                Review(
                    id: "1",
                    authorName: "Sarah M.",
                    date: Date(),
                    rating: 5,
                    comment: "David's knowledge of glazes is incredible. He helped me develop a unique glaze for my work and taught me the science behind why certain combinations work.",
                    isVerified: true
                ),
                Review(
                    id: "2",
                    authorName: "Tom H.",
                    date: Date(),
                    rating: 4,
                    comment: "The Raku workshop was amazing! David's expertise made the complex firing process understandable and exciting.",
                    isVerified: true
                )
            ],
            rates: [
                Rate(
                    id: "1",
                    type: .onsite,
                    title: "Glaze Development Workshop",
                    price: 95,
                    duration: 180,
                    description: "Learn to create and test your own glazes",
                    additionalInfo: ["Materials provided", "Take home test tiles", "Recipe book included"],
                    isPackage: false
                ),
                Rate(
                    id: "2",
                    type: .onsite,
                    title: "Raku Firing Experience",
                    price: 250,
                    duration: 360,
                    description: "Full-day Raku workshop including firing",
                    additionalInfo: [
                        "All materials included",
                        "Safety equipment provided",
                        "Take home 2-3 pieces",
                        "Lunch included"
                    ],
                    isPackage: true
                )
            ],
            projectPhotos: ["david_project_1", "david_project_2", "david_project_3"],
            instagramPhotos: ["david_insta_1", "david_insta_2", "david_insta_3"],
            profileImage: "david_profile"
        ),
        
        // Additional Electrical/Smart Home Coach
        Coach(
            id: "6",
            name: "Alex Rivera",
            category: .electrical,
            rating: 4.8,
            reviewCount: 143,
            hourlyRate: 75,
            expertise: ["Home Automation", "Solar Installation", "Energy Efficiency"],
            projectTypes: ["Smart Home", "Solar Power", "Energy Monitoring"],
            interests: ["Renewable Energy", "Smart Technology", "Energy Conservation"],
            skills: ["Solar installation", "Smart home integration", "Energy monitoring", "Automation programming"],
            description: """
                Alex specializes in renewable energy solutions and advanced home automation.
                
                Combining electrical expertise with sustainable technology, he helps homeowners create efficient, modern living spaces.
                """,
            imageURL: "alex_profile",
            reviews: [
                Review(
                    id: "1",
                    authorName: "Michael P.",
                    date: Date(),
                    rating: 5,
                    comment: "Alex helped me plan and install a complete smart home system. His knowledge of both electrical work and home automation made the project seamless.",
                    isVerified: true
                ),
                Review(
                    id: "2",
                    authorName: "Linda R.",
                    date: Date(),
                    rating: 5,
                    comment: "The solar consultation was eye-opening. Alex explained everything clearly and helped me design an efficient system for my home.",
                    isVerified: true
                )
            ],
            rates: [
                Rate(
                    id: "1",
                    type: .virtual,
                    title: "Smart Home Consultation",
                    price: 85,
                    duration: 60,
                    description: "Plan your smart home setup",
                    additionalInfo: ["System design", "Product recommendations", "Integration planning"],
                    isPackage: false
                ),
                Rate(
                    id: "2",
                    type: .onsite,
                    title: "Solar Energy Package",
                    price: 499,
                    duration: 480,
                    description: "Complete solar system planning and basic installation guidance",
                    additionalInfo: [
                        "Site assessment",
                        "System design",
                        "Installation planning",
                        "Efficiency optimization",
                        "Rebate guidance"
                    ],
                    isPackage: true
                )
            ],
            projectPhotos: ["alex_project_1", "alex_project_2", "alex_project_3"],
            instagramPhotos: ["alex_insta_1", "alex_insta_2", "alex_insta_3"],
            profileImage: "alex_profile"
        )
    ]
} 