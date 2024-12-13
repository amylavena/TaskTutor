enum SearchService {
    static func searchCoaches(_ coaches: [Coach], searchText: String, category: ProjectCategory?) -> [Coach] {
        guard !searchText.isEmpty || category != nil else {
            return coaches
        }
        
        return coaches.filter { coach in
            let searchTerms = searchText.lowercased().split(by: " ")
            
            // Category filter
            let matchesCategory = category == nil || coach.category == category
            
            // Search text filter
            let matchesSearch = searchText.isEmpty || searchTerms.allSatisfy { term in
                // Check name
                let nameMatch = coach.name.lowercased().contains(term)
                
                // Check skills
                let skillsMatch = coach.skills.contains { $0.lowercased().contains(term) }
                
                // Check category
                let categoryMatch = coach.category.name.lowercased().contains(term)
                
                return nameMatch || skillsMatch || categoryMatch
            }
            
            return matchesSearch && matchesCategory
        }
    }
}

// Helper extension for string splitting
private extension String {
    func split(by separator: Character) -> [String] {
        self.split(separator: separator)
            .map(String.init)
            .filter { !$0.isEmpty }
    }
} 