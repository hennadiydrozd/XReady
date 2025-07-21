import SwiftUI

struct AppRoot: View {
    @AppStorage(SaveKey.showOnboarding) var showOnboarding = true
    @State private var isLoading = true
    @StateObject private var statsManager = StatsManager()

    var body: some View {
        ZStack {
            LinearGradient.main.ignoresSafeArea()
            
            rootView
                .zIndex(1)
        }
        .dynamicTypeSize(.large)
        .lockOrientation(AppDelegate.orientation)
        .environmentObject(statsManager)
        .animation(.default, value: isLoading)
        .animation(.default, value: showOnboarding)
    }
    
    @ViewBuilder
    private var rootView: some View {
        if isLoading {
            PreloaderRoot()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLoading = false
                    }
                }
        } else if showOnboarding {
            OnboardingView()
        } else {
            NavigationStack {
                TabBarView()
            }
        }
    }
}
