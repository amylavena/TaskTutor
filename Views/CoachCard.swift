struct CoachCard: View {
    let coach: Coach
    
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            HStack(spacing: 16) {
                // Profile Image
                let imageToLoad = coach.imageURL
                print("DEBUG: ----Image Loading Debug----")
                print("DEBUG: Coach name: \(coach.name)")
                print("DEBUG: Image name to load: \(imageToLoad)")
                
                // Try different image loading methods
                Group {
                    if let uiImage = UIImage(named: imageToLoad) {
                        print("DEBUG: Successfully loaded UIImage")
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else if let assetImage = Image(imageToLoad) {
                        print("DEBUG: Successfully loaded from asset catalog")
                        assetImage
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                    } else {
                        print("DEBUG: Failed to load image, using fallback")
                        Image(systemName: "person.fill")
                            .foregroundColor(.gray)
                    }
                }
                .frame(width: 80, height: 80)
                .clipShape(Circle())
                .background(
                    Circle()
                        .fill(Color.gray.opacity(0.1))
                        .frame(width: 80, height: 80)
                )
                
                // Name and Categories
                VStack(alignment: .leading, spacing: 4) {
                    Text(coach.name)
                        .font(.headline)
                    
                    // Categories
                    HStack {
                        ForEach(coach.categories, id: \.self) { category in
                            Text(category.name)
                                .font(.caption)
                                .padding(.horizontal, 8)
                                .padding(.vertical, 4)
                                .background(category.color.opacity(0.2))
                                .foregroundColor(category.color)
                                .cornerRadius(8)
                        }
                    }
                }
            }
            
            // Rating and Reviews
            HStack {
                Image(systemName: "star.fill")
                    .foregroundColor(.yellow)
                Text(String(format: "%.1f", coach.rating))
                    .fontWeight(.medium)
                Text("(\(coach.reviews) reviews)")
                    .foregroundColor(.secondary)
            }
            .font(.subheadline)
            
            // Skills
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(coach.skills, id: \.self) { skill in
                        Text(skill)
                            .font(.caption)
                            .padding(.horizontal, 8)
                            .padding(.vertical, 4)
                            .background(Color.gray.opacity(0.1))
                            .cornerRadius(8)
                    }
                }
            }
            
            // Hourly Rate
            HStack {
                Text("$\(coach.hourlyRate)/hour")
                    .font(.headline)
                    .foregroundColor(.primary)
            }
        }
        .padding()
        .background(Color(.systemBackground))
        .cornerRadius(12)
        .shadow(radius: 2)
    }
} 