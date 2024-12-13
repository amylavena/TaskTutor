import SwiftUI

struct CoachSearchView: View {
    @State private var searchText = ""
    @State private var selectedCategory: ProjectCategory?
    @State private var filteredCoaches: [Coach] = []
    
    // Use the sample data from extension
    private let sampleCoaches = Coach.sampleCoaches
    
    var body: some View {
        VStack(spacing: 0) {
            // Search bar
            SearchBar(
                text: $searchText,
                placeholder: "Search by skill or project type",
                filteredCoaches: $filteredCoaches,
                allCoaches: sampleCoaches
            )
            .padding()
            
            // Categories filter
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    ForEach(ProjectCategory.allCases) { category in
                        CategoryPill(
                            category: category,
                            isSelected: selectedCategory == category,
                            action: {
                                if selectedCategory == category {
                                    selectedCategory = nil
                                    filteredCoaches = sampleCoaches
                                } else {
                                    selectedCategory = category
                                    filteredCoaches = sampleCoaches.filter { $0.category == category }
                                }
                            }
                        )
                    }
                }
                .padding(.horizontal)
            }
            
            // Coach list
            if filteredCoaches.isEmpty {
                VStack(spacing: 16) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 48))
                        .foregroundColor(.gray)
                    Text("No coaches found")
                        .font(.headline)
                    Text("Try adjusting your search or filters")
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
            } else {
                ScrollView {
                    LazyVStack(spacing: 16) {
                        ForEach(filteredCoaches) { coach in
                            NavigationLink(destination: CoachDetailView(coach: coach)) {
                                CoachCard(coach: coach)
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationTitle("Find a Coach")
        .onAppear {
            filteredCoaches = sampleCoaches
        }
    }
} 