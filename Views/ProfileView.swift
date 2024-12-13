import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    
    var body: some View {
        NavigationView {
            List {
                // Profile Header
                VStack(spacing: 16) {
                    // Profile Image
                    Image(systemName: "person.circle.fill")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 100, height: 100)
                        .foregroundColor(Color.theme.primary)
                    
                    // User Info
                    VStack(spacing: 4) {
                        Text(userViewModel.currentUser?.name ?? "User Name")
                            .font(.title2)
                            .fontWeight(.semibold)
                        
                        Text(userViewModel.currentUser?.email ?? "email@example.com")
                            .font(.subheadline)
                            .foregroundColor(Color.theme.textSecondary)
                    }
                }
                .frame(maxWidth: .infinity)
                .padding()
                .listRowInsets(EdgeInsets())
                .background(Color.theme.cardBackground)
                
                // Settings Sections
                Section("Account") {
                    NavigationLink(destination: Text("Edit Profile")) {
                        Label("Edit Profile", systemImage: "person")
                    }
                    
                    NavigationLink(destination: Text("Notifications")) {
                        Label("Notifications", systemImage: "bell")
                    }
                }
                
                Section("Support") {
                    NavigationLink(destination: Text("Help Center")) {
                        Label("Help Center", systemImage: "questionmark.circle")
                    }
                    
                    NavigationLink(destination: Text("Contact Us")) {
                        Label("Contact Us", systemImage: "envelope")
                    }
                }
                
                Section {
                    Button(action: {
                        userViewModel.signOut()
                    }) {
                        Label("Sign Out", systemImage: "arrow.right.square")
                            .foregroundColor(.red)
                    }
                }
            }
            .navigationTitle("Profile")
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
            .environmentObject(UserViewModel())
    }
} 