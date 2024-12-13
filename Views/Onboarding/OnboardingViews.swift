import SwiftUI

// MARK: - Main Onboarding View
struct OnboardingView: View {
    @StateObject private var viewModel = OnboardingViewModel()
    
    var body: some View {
        NavigationView {
            SplashView(viewModel: viewModel)
        }
    }
}

// MARK: - Splash View
struct SplashView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var showLogin = false
    @State private var showSignup = false
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                // Base background image
                Image("onboarding_bg")
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .edgesIgnoringSafeArea(.all)
                
                // Gradient overlay
                LinearGradient(
                    stops: [
                        Gradient.Stop(color: Color.black.opacity(0.6), location: 0.00),
                        Gradient.Stop(color: Color.black.opacity(0.4), location: 1.00),
                    ],
                    startPoint: UnitPoint(x: 0.5, y: 0),
                    endPoint: UnitPoint(x: 0.5, y: 1)
                )
                .edgesIgnoringSafeArea(.all)
                
                // Content
                VStack(spacing: 0) {
                    // Title Group
                    VStack(alignment: .leading, spacing: 8) {
                        Text("TASKTUTOR")
                            .font(.custom("Times New Roman", size: 48))
                            .tracking(2)
                            .foregroundColor(.white)
                        
                        Text("DIY Done Right, Together")
                            .font(.system(size: 20, weight: .regular))
                            .foregroundColor(Color(hex: "C4A484"))
                        
                        // Wavy line
                        Image("wave_line")
                            .resizable()
                            .frame(width: 60, height: 10)
                            .foregroundColor(Color(hex: "C4A484"))
                    }
                    .padding(.horizontal, 40)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, geometry.safeAreaInsets.top + 60)
                    
                    Spacer()
                    
                    // Bottom Buttons Group
                    VStack(spacing: 16) {
                        // Login Button
                        Button(action: {
                            showLogin = true
                        }) {
                            Text("LOG IN")
                                .font(.system(size: 16, weight: .medium))
                                .tracking(1)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 50)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 25)
                                        .stroke(Color.white.opacity(0.5), lineWidth: 1)
                                )
                                .padding(.horizontal, 40)
                        }
                        
                        // Sign Up Text
                        HStack(spacing: 4) {
                            Text("DON'T HAVE AN ACCOUNT?")
                                .font(.system(size: 12, weight: .regular))
                                .foregroundColor(.white.opacity(0.8))
                            
                            Button(action: {
                                showSignup = true
                            }) {
                                Text("SIGN UP")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundColor(.white)
                                    .underline(color: .white)
                            }
                        }
                    }
                    .padding(.bottom, geometry.safeAreaInsets.bottom + 20)
                }
            }
        }
        .ignoresSafeArea()
        .navigationBarHidden(true)
        .background(
            NavigationLink(isActive: $showLogin) {
                LoginView()
            } label: {
                EmptyView()
            }
        )
        .background(
            NavigationLink(isActive: $showSignup) {
                WelcomeScreenView(viewModel: viewModel)
            } label: {
                EmptyView()
            }
        )
    }
}

// MARK: - Welcome Screen
struct WelcomeScreenView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    @State private var currentPage = 0
    
    var body: some View {
        ZStack {
            // Base background color
            Color(red: 0.75, green: 0.70, blue: 0.65) // Warm sand
            
            // Background image
            Image("bg")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 379, height: 816)
            
            // Gradient overlay
            LinearGradient(
                stops: [
                    Gradient.Stop(color: Color(red: 0.18, green: 0.20, blue: 0.16).opacity(0.90), location: 0.00),
                    Gradient.Stop(color: Color(red: 0.25, green: 0.28, blue: 0.22).opacity(0.85), location: 0.30),
                    Gradient.Stop(color: Color(red: 0.32, green: 0.34, blue: 0.28).opacity(0.80), location: 0.60),
                    Gradient.Stop(color: Color(red: 0.38, green: 0.36, blue: 0.32).opacity(0.75), location: 1.00),
                ],
                startPoint: UnitPoint(x: 0.71, y: 1.29),
                endPoint: UnitPoint(x: 1.29, y: 0.29)
            )
            .edgesIgnoringSafeArea(.all)
            
            // Content
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        if currentPage > 0 {
                            withAnimation {
                                currentPage -= 1
                            }
                        }
                    }) {
                        Image(systemName: "chevron.left")
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Text("GET STARTED")
                        .foregroundColor(.white)
                        .font(.system(size: 16, weight: .medium))
                    
                    Spacer()
                    
                    Button(action: {
                        if currentPage < 3 {  // Updated to < 3
                            withAnimation {
                                currentPage += 1
                            }
                        }
                    }) {
                        Text("SKIP")
                            .foregroundColor(.white)
                            .font(.system(size: 16, weight: .medium))
                    }
                }
                .padding()
                
                // Page Content with TabView
                TabView(selection: $currentPage) {
                    WelcomePageView(
                        image: "welcome_1",
                        title: "Your DIY Partner",
                        description: "TaskTutor connects you with skilled professionals to guide you through any project—big or small. Learn hands-on, gain confidence, and complete your projects like a pro"
                    )
                    .tag(0)
                    
                    WelcomePageView(
                        image: "welcome_2",
                        title: "Learn, Build, Create",
                        description: "Whether it's crafting, home improvement, or repairs, our coaches will teach you step-by-step, so you not only finish your project but also gain lifelong skills"
                    )
                    .tag(1)
                    
                    WelcomePageView(
                        image: "welcome_3",
                        title: "Coaching, Your Way",
                        description: "Get hands-on guidance with in-person sessions or connect with a coach through text, calls, or video—whatever works best for you. TaskTutor makes learning DIY easy and convenient"
                    )
                    .tag(2)
                    
                    WelcomePageView(
                        image: "welcome_4",
                        title: "Borrow and Build",
                        description: "No tools? No problem! Rent tools from our community marketplace to complete your projects without the hassle of buying. TaskTutor makes DIY more accessible than ever!"
                    )
                    .tag(3)
                }
                .tabViewStyle(.page(indexDisplayMode: .never))
                
                // Custom Page Indicators
                HStack(spacing: 8) {
                    ForEach(0..<4) { index in  // Updated to 0..<4
                        Circle()
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.5))
                            .frame(width: 8, height: 8)
                    }
                }
                .padding(.bottom, 40)
            }
        }
        .navigationBarHidden(true)
    }
}

// Individual Welcome Page View
struct WelcomePageView: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(spacing: 40) {
            // Circular Image Container
            Image(image)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 350, height: 350)
                .clipShape(Circle())
                .overlay(
                    Circle()
                        .stroke(Color.white.opacity(0.2), lineWidth: 1)
                )
                .padding(.top, 20)
            
            // Centered Content
            VStack(spacing: 24) {
                Text(title)
                    .font(.custom("Times New Roman", size: 40))
                    .foregroundColor(.white)
                    .multilineTextAlignment(.center)
                
                Text(description)
                    .font(.system(size: 20))
                    .foregroundColor(.white.opacity(0.8))
                    .lineSpacing(6)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
                    .frame(maxWidth: 380)
            }
            
            Spacer(minLength: 0)
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - User Type Selection
struct UserTypeSelectionView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome to TaskTutor")
                .font(.title)
                .fontWeight(.bold)
            
            Text("Let's begin by telling us a little bit more about you.")
                .multilineTextAlignment(.center)
            
            VStack(spacing: 16) {
                SelectionButton(
                    title: "I'm a DIYer seeking a coach for a project",
                    isSelected: viewModel.selectedUserType == .diyer
                ) {
                    viewModel.selectedUserType = .diyer
                }
                
                SelectionButton(
                    title: "I'm a professional looking to support DIYers with my expertise",
                    isSelected: viewModel.selectedUserType == .coach
                ) {
                    viewModel.selectedUserType = .coach
                }
            }
            .padding()
            
            Spacer()
            
            if viewModel.selectedUserType != nil {
                CustomButton(title: "Continue") {
                    viewModel.nextPage()
                }
                .padding(.horizontal)
            }
        }
        .background(Color.theme.background)
    }
}

// MARK: - Login View
struct LoginView: View {
    @State private var email = ""
    @State private var password = ""
    
    var body: some View {
        VStack(spacing: 24) {
            Text("Welcome Back")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(spacing: 16) {
                CustomTextField(title: "Email", text: $email)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                
                CustomTextField(title: "Password", text: $password)
                    .textContentType(.password)
            }
            .padding()
            
            CustomButton(title: "Log In") {
                // Handle login
            }
            .padding(.horizontal)
            
            Spacer()
        }
        .navigationBarTitleDisplayMode(.inline)
        .background(Color.theme.background)
    }
}

// Add this extension for hex color support
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}