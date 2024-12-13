import SwiftUI

struct PublishingStep: View {
    @Binding var isPremium: Bool
    @Binding var price: Double?
    let isPublishing: Bool
    let onPublish: () -> Void
    
    var body: some View {
        Form {
            Section("Publishing Options") {
                Toggle("Premium Project", isOn: $isPremium)
                
                if isPremium {
                    HStack {
                        Text("Price")
                        Spacer()
                        TextField("Price", value: $price, format: .currency(code: "USD"))
                            .keyboardType(.decimalPad)
                            .multilineTextAlignment(.trailing)
                    }
                }
            }
            
            Section {
                Button(action: onPublish) {
                    if isPublishing {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                    } else {
                        Text("Publish Project")
                    }
                }
                .frame(maxWidth: .infinity)
                .disabled(isPublishing || (isPremium && (price ?? 0) <= 0))
            }
        }
    }
} 