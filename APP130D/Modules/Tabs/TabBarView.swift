import SwiftUI

struct TabBarView: View {
    @State private var selectedTab: Tab = .preWorkout
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                switch selectedTab {
                case .preWorkout:
                    PreWorkoutView()
                case .postWorkout:
                    PostWorkoutView()
                case .custom:
                    CustomRoutinesView()
                case .stats:
                    StatsView()
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .animation(.easeInOut(duration: 0.3), value: selectedTab)
            
            // Custom Tab Bar
            CustomTabBar(selectedTab: $selectedTab)
        }
        .background {
            LinearGradient.main.ignoresSafeArea()
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

enum Tab: Int, CaseIterable, Identifiable {
    case preWorkout = 1
    case postWorkout
    case custom
    case stats
    
    var id: Int { rawValue }
    
    var icon: String {
       return "tab" + String(rawValue)
    }
}

// MARK: - Custom Tab Bar View
struct CustomTabBar: View {
    @Binding var selectedTab: Tab
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(Tab.allCases) { tab in
                TabBarButton(
                    tab: tab,
                    isSelected: selectedTab == tab
                ) {
                    withAnimation(.easeInOut(duration: 0.3)) {
                        selectedTab = tab
                    }
                }
            }
        }
        .padding(.horizontal, 20)
        .frame(height: 62)
        .background {
            RoundedRectangle(cornerRadius: 10)
                .fill(Color("00315C"))
        }
        .padding(.horizontal, 10)
        .padding(.bottom, 10)
    }
}

// MARK: - Individual Tab Button
struct TabBarButton: View {
    let tab: Tab
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Image(tab.icon)
                .resizable()
                .renderingMode(.template)
                .scaledToFit()
                .foregroundStyle(isSelected ? Color("88BAFF") : Color.white)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


// MARK: - Preview
#Preview {
    TabBarView()
}
