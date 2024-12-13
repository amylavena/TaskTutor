import Foundation

struct ProjectSearchService {
    // Scoring weights
    private struct Weights {
        static let directMatch = 1.0
        static let partialMatch = 0.5
        static let relatedTermMatch = 0.3
        static let expertiseLevel = 0.2
        static let ratingBonus = 0.1
    }
    
    static func findRelevantCoaches(_ coaches: [Coach], forProjectQuery query: String) -> [Coach] {
        guard !query.isEmpty else { return coaches }
        
        print("\n=== Search Debug ===")
        print("Query: '\(query)'")
        
        let searchTerms = normalizeSearchTerms(query)
        print("Normalized terms: \(searchTerms)")
        
        let queryIntent = analyzeQueryIntent(searchTerms)
        print("Query intent: complexity=\(queryIntent.complexity ?? "none"), specific=\(queryIntent.isSpecificSkill), urgent=\(queryIntent.isUrgent)")
        
        let scoredCoaches = coaches.map { coach -> (Coach, Double) in
            let score = calculateRelevanceScore(
                coach: coach,
                searchTerms: searchTerms,
                queryIntent: queryIntent
            )
            print("\nCoach: \(coach.name)")
            print("Score: \(score)")
            return (coach, score)
        }
        
        let results = scoredCoaches
            .filter { $0.1 > 0 }
            .sorted { $0.1 > $1.1 }
            .map { $0.0 }
        
        print("\nFound \(results.count) matching coaches")
        return results
    }
    
    private static func normalizeSearchTerms(_ query: String) -> [String] {
        let words = query.lowercased()
            .components(separatedBy: .punctuation)
            .joined(separator: " ")
            .components(separatedBy: .whitespaces)
            .filter { !$0.isEmpty }
        
        return words.filter { !StopWords.common.contains($0) }
    }
    
    private static func analyzeQueryIntent(_ terms: [String]) -> QueryIntent {
        var intent = QueryIntent()
        
        // Analyze project complexity
        let complexityIndicators = Set(["complex", "advanced", "simple", "basic", "beginner"])
        intent.complexity = terms.first { complexityIndicators.contains($0) }
        
        // Detect if it's a specific skill query or a project description
        intent.isSpecificSkill = terms.count == 1 && !terms[0].contains(" ")
        
        // Check for time-related terms
        let timeIndicators = Set(["urgent", "emergency", "asap", "quick", "fast"])
        intent.isUrgent = terms.contains { timeIndicators.contains($0) }
        
        return intent
    }
    
    private static func calculateRelevanceScore(
        coach: Coach,
        searchTerms: [String],
        queryIntent: QueryIntent
    ) -> Double {
        var score = 0.0
        
        // Combine coach keywords
        let coachKeywords = getCoachKeywords(coach)
        
        // Process each search term
        for term in searchTerms {
            score += calculateTermScore(term, coachKeywords: coachKeywords)
        }
        
        // Apply expertise and rating bonuses
        score += calculateExpertiseBonus(coach, queryIntent: queryIntent)
        score += calculateRatingBonus(coach)
        
        return score
    }
    
    private static func getCoachKeywords(_ coach: Coach) -> Set<String> {
        Set(
            coach.skills.flatMap { skill in
                skill.lowercased().components(separatedBy: .whitespaces)
            } +
            coach.tags.flatMap { tag in
                tag.lowercased().components(separatedBy: .whitespaces)
            } +
            coach.description.lowercased().components(separatedBy: .whitespaces)
                .filter { !StopWords.common.contains($0) }
        )
    }
    
    private static func calculateTermScore(_ term: String, coachKeywords: Set<String>) -> Double {
        var termScore = 0.0
        
        // Direct matches
        if coachKeywords.contains(term) {
            termScore += Weights.directMatch
        }
        
        // Partial matches
        let partialMatches = coachKeywords.filter { keyword in
            keyword.contains(term) || term.contains(keyword)
        }
        termScore += Double(partialMatches.count) * Weights.partialMatch
        
        // Related terms
        let relatedTerms = RelatedTerms.get(for: term)
        let relatedMatches = coachKeywords.intersection(relatedTerms)
        termScore += Double(relatedMatches.count) * Weights.relatedTermMatch
        
        return termScore
    }
    
    private static func calculateExpertiseBonus(_ coach: Coach, queryIntent: QueryIntent) -> Double {
        // Add bonus for highly reviewed coaches
        let reviewBonus = coach.reviews > 100 ? Weights.expertiseLevel : 0
        
        // Add bonus for high ratings
        let ratingBonus = coach.rating >= 4.8 ? Weights.expertiseLevel : 0
        
        return reviewBonus + ratingBonus
    }
    
    private static func calculateRatingBonus(_ coach: Coach) -> Double {
        // Normalize rating to 0-1 range and apply weight
        return (coach.rating - 4.0) * Weights.ratingBonus
    }
}

// Supporting types
private struct QueryIntent {
    var complexity: String?
    var isSpecificSkill: Bool = false
    var isUrgent: Bool = false
}

private enum StopWords {
    static let common: Set<String> = [
        "a", "an", "the", "and", "or", "but", "in", "on", "at", "to", "for", "of",
        "with", "by", "from", "up", "about", "into", "over", "after"
    ]
}

private enum RelatedTerms {
    static let mapping: [String: Set<String>] = [
        "shelf": ["shelves", "shelving", "storage", "mounting", "installation", "bracket", "wall"],
        "shelves": ["shelf", "shelving", "storage", "mounting", "installation", "bracket", "wall"],
        "bread": ["baking", "sourdough", "cooking", "pastry", "dough", "yeast", "flour"],
        "sourdough": ["bread", "baking", "cooking", "pastry", "dough", "starter", "fermentation"],
        "electrical": ["wiring", "power", "installation", "lighting", "circuit", "outlet", "switch"],
        "paint": ["painting", "walls", "decoration", "finishing", "primer", "brush", "roller"],
        "car": ["automotive", "vehicle", "repair", "maintenance", "engine", "mechanic"],
        "pottery": ["ceramics", "clay", "sculpture", "crafts", "wheel", "kiln", "glazing"],
        "plumbing": ["pipe", "water", "drain", "faucet", "sink", "toilet", "leak"],
        "garden": ["gardening", "plants", "landscaping", "soil", "flowers", "vegetables"],
        "furniture": ["woodworking", "assembly", "carpentry", "building", "wood", "construction"],
        // Add more mappings as needed
    ]
    
    static func get(for term: String) -> Set<String> {
        mapping[term] ?? Set()
    }
} 