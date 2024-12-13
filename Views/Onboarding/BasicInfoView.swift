import SwiftUI

struct BasicInfoView: View {
    @ObservedObject var viewModel: OnboardingViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 24) {
            Text("The basics")
                .font(.title)
                .fontWeight(.bold)
            
            VStack(alignment: .leading, spacing: 16) {
                CustomTextField(title: "First name", text: $viewModel.firstName)
                CustomTextField(title: "Last name", text: $viewModel.lastName)
                CustomTextField(title: "Preferred language", text: $viewModel.preferredLanguage)
                CustomTextField(title: "Zip code", text: $viewModel.zipCode)
                    .keyboardType(.numberPad)
                
                Toggle("I agree to the Terms of Service and Privacy Policy", isOn: $viewModel.agreedToTerms)
                    .font(.subheadline)
            }
            
            Spacer()
            
            CustomButton(title: "Continue") {
                // Complete signup process
            }
            .disabled(!viewModel.isBasicInfoValid)
        }
        .padding()
        .background(Color.theme.background)
    }
} 