import SwiftUI

struct CoachDetailView: View {
    let coach: Coach
    @State private var showBooking = false
    @State private var selectedTab = 0
    
    private var relevantCoaches: [Coach] {
        let otherCoaches = Coach.sampleCoaches.filter { $0.id != coach.id }
        
        // Find coaches with matching skills or expertise
        let skillMatches = otherCoaches.filter { otherCoach in
            !Set(otherCoach.skills).isDisjoint(with: Set(coach.skills)) ||
            !Set(otherCoach.expertise).isDisjoint(with: Set(coach.expertise))
        }
        
        // Find coaches in same or related categories
        let categoryMatches = otherCoaches.filter { otherCoach in
            switch coach.category {
            case .crafts:
                // Crafts coaches might share interests with woodworking and art
                return otherCoach.category == .crafts || 
                       (otherCoach.category == .woodworking && otherCoach.interests.contains { $0.lowercased().contains("art") })
            case .woodworking:
                // Woodworking relates to home improvement and some crafts
                return otherCoach.category == .woodworking || 
                       otherCoach.category == .homeImprovement ||
                       (otherCoach.category == .crafts && otherCoach.skills.contains { $0.lowercased().contains("wood") })
            case .electrical:
                // Electrical often relates to home improvement and smart home
                return otherCoach.category == .electrical || 
                       (otherCoach.category == .homeImprovement && otherCoach.skills.contains { $0.lowercased().contains("electrical") })
            case .homeImprovement:
                // Home improvement can relate to multiple categories
                return otherCoach.category == .homeImprovement || 
                       otherCoach.category == .woodworking || 
                       otherCoach.category == .electrical
            default:
                return false
            }
        }
        
        // Combine matches, prioritizing skill matches first
        let combined = Array(Set(skillMatches + categoryMatches))
        
        // Sort by relevance (same category first, then by rating)
        return combined.sorted { coach1, coach2 in
            if coach1.category == coach.category && coach2.category != coach.category {
                return true
            } else if coach1.category != coach.category && coach2.category == coach.category {
                return false
            } else {
                return coach1.rating > coach2.rating
            }
        }
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 24) {
                // Top Profile Navigation
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 16) {
                        ForEach(relevantCoaches) { sampleCoach in
                            NavigationLink(destination: CoachDetailView(coach: sampleCoach)) {
                                VStack {
                                    if let uiImage = UIImage(named: sampleCoach.imageURL) {
                                        Image(uiImage: uiImage)
                                            .resizable()
                                            .aspectRatio(contentMode: .fill)
                                            .frame(width: 60, height: 60)
                                            .clipShape(Circle())
                                    } else {
                                        Circle()
                                            .fill(Color.theme.cardBackground)
                                            .frame(width: 60, height: 60)
                                            .overlay(
                                                Image(systemName: "person.fill")
                                                    .foregroundColor(Color.theme.textSecondary)
                                            )
                                    }
                                    Text(sampleCoach.name.split(separator: " ").first ?? "")
                                        .font(.caption)
                                        .foregroundColor(Color.theme.textPrimary)
                                }
                            }
                        }
                    }
                    .padding(.horizontal)
                }
                
                // Main Profile Section
                VStack(alignment: .leading, spacing: 8) {
                    // Profile Image
                    if let uiImage = UIImage(named: coach.imageURL) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 300)
                            .clipShape(Rectangle())
                    } else {
                        Rectangle()
                            .fill(Color.gray.opacity(0.2))
                            .frame(height: 300)
                            .overlay(
                                Image(systemName: "person.fill")
                                    .resizable()
                                    .scaledToFit()
                                    .foregroundColor(.gray)
                                    .padding(80)
                            )
                    }
                    
                    VStack(alignment: .leading, spacing: 8) {
                        Text(coach.name)
                            .font(.title)
                            .fontWeight(.bold)
                        
                        Text("Buda, TX")
                            .font(.subheadline)
                            .foregroundColor(.secondary)
                        
                        HStack {
                            Image(systemName: "star.fill")
                                .foregroundColor(.yellow)
                            Text(String(format: "%.1f", coach.rating))
                            Text("•")
                            Text("\(coach.reviewCount) reviews")
                                .foregroundColor(.secondary)
                        }
                        .font(.subheadline)
                    }
                    .padding(.horizontal)
                }

                // Tab Selection
                HStack(spacing: 0) {
                    ForEach(["Info", "Reviews", "Rates"], id: \.self) { tab in
                        Button(action: {
                            withAnimation {
                                selectedTab = ["Info", "Reviews", "Rates"].firstIndex(of: tab) ?? 0
                            }
                        }) {
                            VStack(spacing: 8) {
                                Text(tab)
                                    .foregroundColor(selectedTab == ["Info", "Reviews", "Rates"].firstIndex(of: tab) ? Color.theme.primary : Color.theme.textSecondary)
                                
                                Rectangle()
                                    .fill(selectedTab == ["Info", "Reviews", "Rates"].firstIndex(of: tab) ? Color.theme.primary : Color.clear)
                                    .frame(height: 2)
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                }
                .padding(.horizontal)

                // Info Content
                if selectedTab == 0 {
                    VStack(alignment: .leading, spacing: 24) {
                        // About section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("About")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            // Description
                            Text(coach.description ?? "No description available")
                                .foregroundColor(.secondary)
                                .padding(.horizontal)
                        }
                        
                        // Skills Section
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Skills")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(coach.skills, id: \.self) { skill in
                                    Text(skill)
                                        .font(.subheadline)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 8)
                                        .frame(maxWidth: .infinity)
                                        .background(Color.theme.cardBackground)
                                        .foregroundColor(Color.theme.textPrimary)
                                        .cornerRadius(20)
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Coaching Modality
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Coaching modality")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            HStack(spacing: 12) {
                                Text("Virtual consults")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                                
                                Text("On site coaching")
                                    .font(.subheadline)
                                    .padding(.horizontal, 12)
                                    .padding(.vertical, 8)
                                    .background(Color.gray.opacity(0.1))
                                    .cornerRadius(20)
                            }
                            .padding(.horizontal)
                        }
                        
                        // Projects Gallery
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Projects")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(coach.projectPhotos, id: \.self) { photo in
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .aspectRatio(1, contentMode: .fit)
                                        .cornerRadius(8)
                                        .overlay(
                                            Image(systemName: "photo.fill")
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                        
                        // Instagram Gallery
                        VStack(alignment: .leading, spacing: 16) {
                            Text("Instagram")
                                .font(.headline)
                                .padding(.horizontal)
                            
                            LazyVGrid(columns: [
                                GridItem(.flexible()),
                                GridItem(.flexible()),
                                GridItem(.flexible())
                            ], spacing: 12) {
                                ForEach(coach.instagramPhotos, id: \.self) { photo in
                                    Rectangle()
                                        .fill(Color.gray.opacity(0.1))
                                        .aspectRatio(1, contentMode: .fit)
                                        .cornerRadius(8)
                                        .overlay(
                                            Image(systemName: "camera.fill")
                                                .foregroundColor(.gray)
                                        )
                                }
                            }
                            .padding(.horizontal)
                        }
                    }
                } else if selectedTab == 1 {
                    // Reviews Content
                    VStack(alignment: .leading, spacing: 24) {
                        Text("Reviews")
                            .font(.title)
                            .fontWeight(.bold)
                            .padding(.horizontal)
                        
                        ForEach(coach.reviews) { review in
                            VStack(alignment: .leading, spacing: 16) {
                                // Review Header
                                HStack(spacing: 12) {
                                    // Profile Image
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                        .frame(width: 50, height: 50)
                                        .overlay(
                                            Image(systemName: "person.fill")
                                                .foregroundColor(.gray)
                                        )
                                    
                                    // Name and Date
                                    VStack(alignment: .leading, spacing: 4) {
                                        Text(review.authorName)
                                            .font(.headline)
                                        
                                        Text(review.date.formatted(date: .long, time: .omitted))
                                            .font(.subheadline)
                                            .foregroundColor(Color.theme.textSecondary)
                                    }
                                }
                                
                                // Verified Badge
                                if review.isVerified {
                                    Text("VERIFIED REVIEW")
                                        .font(.caption)
                                        .fontWeight(.medium)
                                        .padding(.horizontal, 12)
                                        .padding(.vertical, 6)
                                        .background(Color.theme.cardBackground)
                                        .foregroundColor(Color.theme.primary)
                                        .cornerRadius(16)
                                }
                                
                                // Review Content
                                Text(review.comment)
                                    .font(.body)
                                    .foregroundColor(Color.theme.textSecondary)
                                    .fixedSize(horizontal: false, vertical: true)
                            }
                            .padding()
                            .frame(maxWidth: .infinity)
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                            
                            Divider()
                                .padding(.horizontal)
                        }
                    }
                    .padding(.vertical)
                } else if selectedTab == 2 {
                    // Rates Content
                    ScrollView {
                        VStack(spacing: 24) {
                            // Regular Rates
                            VStack(alignment: .leading, spacing: 20) {
                                ForEach(coach.rates.filter { !$0.isPackage }) { rate in
                                    RateCard(rate: rate)
                                }
                            }
                            .padding(.horizontal)
                            
                            // Package Deals
                            if coach.rates.contains(where: { $0.isPackage }) {
                                VStack(alignment: .leading, spacing: 16) {
                                    Text("Package Deals")
                                        .font(.headline)
                                        .padding(.horizontal)
                                    
                                    ForEach(coach.rates.filter { $0.isPackage }) { package in
                                        PackageCard(package: package)
                                    }
                                }
                            }
                            
                            // Cancellation Policy
                            VStack(alignment: .leading, spacing: 8) {
                                Text("Cancellation Policy")
                                    .font(.headline)
                                    .foregroundColor(Color.theme.textPrimary)
                                
                                Text("Free cancellation up to 24 hours before the session. After that, a $25 fee applies.")
                                    .font(.subheadline)
                                    .foregroundColor(Color.theme.textSecondary)
                            }
                            .padding()
                            .background(Color.theme.cardBackground)
                            .cornerRadius(12)
                            .shadow(
                                color: Color.theme.shadowColor,
                                radius: Color.theme.shadowRadius,
                                x: 0,
                                y: Color.theme.shadowY
                            )
                            .padding(.horizontal)
                        }
                        .padding(.vertical)
                    }
                }
            }
            .padding(.vertical)
        }
        .navigationBarTitleDisplayMode(.inline)
        .overlay(
            VStack {
                Spacer()
                Button(action: { showBooking = true }) {
                    Text("Contact Coach")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 12)
                        .background(Color.theme.primary)
                        .cornerRadius(25)
                }
                .padding(.horizontal, 16)
                .padding(.bottom, 8)
            }
        )
        .sheet(isPresented: $showBooking) {
            BookingView(coach: coach)
        }
    }
}

struct CoachDetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            CoachDetailView(coach: Coach.sampleCoaches[0])
        }
    }
}