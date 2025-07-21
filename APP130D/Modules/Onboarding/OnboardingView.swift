import SwiftUI

struct OnboardingView: View {
    @State private var currentPage = 0
    @AppStorage(SaveKey.showOnboarding) var showOnboarding = true
    
    let pages = [
        OnboardingPage(
            title: "Welcome to One WarmUp",
            description: "Get ready for peak performance with proper warm-up routines designed specifically for football players.",
            imageName: "o1",
            backgroundColor: Color(red: 0.2, green: 0.3, blue: 0.6)
        ),
        OnboardingPage(
            title: "Prepare Your Body",
            description: "Dynamic warm-up exercises help prevent injuries and improve your performance on the field.",
            imageName: "o2",
            backgroundColor: Color(red: 0.15, green: 0.25, blue: 0.55)
        ),
        OnboardingPage(
            title: "Recover & Stretch",
            description: "Post-workout stretching helps your muscles recover faster and maintain flexibility.",
            imageName: "o3",
            backgroundColor: Color(red: 0.1, green: 0.2, blue: 0.5)
        )
    ]
    
    var body: some View {
        ZStack {
            LinearGradient.main.ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Main content area
                TabView(selection: $currentPage) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        OnboardingPageView(page: pages[index])
                            .tag(index)
                    }
                }
                .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
                .animation(.easeInOut(duration: 0.5), value: currentPage)
                
                HStack(spacing: 8) {
                    ForEach(0..<pages.count, id: \.self) { index in
                        RoundedRectangle(cornerRadius: 3)
                            .fill(currentPage == index ? Color.white : Color.white.opacity(0.3))
                            .frame(width: 40, height: 6)
                            .animation(.easeInOut(duration: 0.3), value: currentPage)
                    }
                }
                .padding(.bottom, 40)
                
                Button(currentPage < pages.count - 1 ? "Next" : "Start") {
                    if currentPage < pages.count - 1 {
                        currentPage += 1
                    } else {
                        showOnboarding = false
                    }
                }
                .buttonStyle(.customFill)
                .padding(.bottom, 27)
                
                Button("Skip") {
                    showOnboarding = false
                }
                .font(.poppins(.medium, size: 14))
                .foregroundStyle(.white.opacity(0.7))
                .opacity(currentPage == pages.count - 1 ? 0 : 1)
                .padding(.bottom, 30)
            }
        }
    }
}

struct OnboardingPageView: View {
    let page: OnboardingPage
    
    var body: some View {
        VStack(spacing: 40) {
            Image(page.imageName)
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // Text content
            VStack(spacing: 20) {
                Text(page.title)
                    .font(.poppins(.bold, size: 24))
                
                Text(page.description)
                    .font(.poppins(.regular, size: 16))
                    .opacity(0.9)
            }
            .foregroundStyle(.white)
            .multilineTextAlignment(.center)
            
        }
        .padding(.vertical, 30)
        .padding(.horizontal, 24)
    }
}

struct OnboardingPage {
    let title: String
    let description: String
    let imageName: String
    let backgroundColor: Color
}

// MARK: - Preview
#Preview {
    OnboardingView()
}
