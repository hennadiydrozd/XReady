import SwiftUI
import StoreKit

struct StatsView: View {
    @EnvironmentObject var statsManager: StatsManager
    @State private var showDeleteAlert = false
    
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                // Header
                VStack(spacing: 0) {
                    Text("Stats &\nSettings")
                        .font(.unbounded(.bold, size: 24))
                        .foregroundStyle(.white)
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 14)
                        .padding(.bottom, 20)
                    
                    VStack(spacing: 8) {
                        // Pre-Workout Stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Pre-Workout Stats")
                                .font(.unbounded(.bold, size: 12))
                                .foreground("91B9FF")
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    StatCard(
                                        title: "Quick\nWarm-ups",
                                        value: "\(statsManager.stats.preWorkoutQuickCount)"
                                    )
                                    StatCard(
                                        title: "Full\nWarm-ups",
                                        value: "\(statsManager.stats.preWorkoutFullCount)"
                                    )
                                    StatCard(
                                        title: "Total\nWorkouts",
                                        value: "\(statsManager.stats.totalWorkoutsCompleted)"
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Post-Workout Stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Post-Workout Stats")
                                .font(.unbounded(.bold, size: 12))
                                .foreground("91B9FF")
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    StatCard(
                                        title: "Quick\nStretches",
                                        value: "\(statsManager.stats.postWorkoutQuickCount)"
                                    )
                                    StatCard(
                                        title: "Full\nStretches",
                                        value: "\(statsManager.stats.postWorkoutFullCount)"
                                    )
                                    StatCard(
                                        title: "Total\nMinutes",
                                        value: "\(Int(statsManager.stats.totalWorkoutTime / 60))"
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Custom Routine Stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Custom Routine Stats")
                                .font(.unbounded(.bold, size: 12))
                                .foreground("91B9FF")
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    StatCard(
                                        title: "Routines\nCompleted",
                                        value: "\(statsManager.stats.customRoutinesCompleted)"
                                    )
                                    StatCard(
                                        title: "Total\nMinutes",
                                        value: "\(Int(statsManager.stats.totalCustomRoutineTime / 60))"
                                    )
                                    StatCard(
                                        title: "Total\nHours",
                                        value: "\(Int(statsManager.stats.totalCustomRoutineTime / 3600))"
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                        
                        // Achievement Stats
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Achievement Stats")
                                .font(.unbounded(.bold, size: 12))
                                .foreground("91B9FF")
                                .padding(.horizontal, 20)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack(spacing: 8) {
                                    StatCard(
                                        title: "Current\nStreak",
                                        value: "\(statsManager.stats.currentStreak)"
                                    )
                                    StatCard(
                                        title: "Total\nSessions",
                                        value: "\(statsManager.stats.totalWorkoutsCompleted + statsManager.stats.customRoutinesCompleted)"
                                    )
                                    StatCard(
                                        title: "Total\nHours",
                                        value: "\(Int((statsManager.stats.totalWorkoutTime + statsManager.stats.totalCustomRoutineTime) / 3600))"
                                    )
                                }
                                .padding(.horizontal, 20)
                            }
                        }
                    }
                    .padding(.bottom, 30)
                    
                    // Settings Section
                    VStack(alignment: .leading, spacing: 8) {
                        Text("Settings")
                            .font(.unbounded(.bold, size: 12))
                            .foreground("91B9FF")
                            .padding(.horizontal, 20)
                        
                        VStack(spacing: 8) {
                            // Rate App and Share App row
                            HStack(spacing: 4) {
                                SettingsButton(
                                    icon: .rate,
                                    title: "Rate App",
                                    action: rateApp
                                )
                                
                                SettingsButton(
                                    icon: .share,
                                    title: "Share App",
                                    action: shareApp
                                )
                            }
                            
                            // Delete All Data button
                            Button(action: {
                                showDeleteAlert = true
                            }) {
                                HStack(spacing: 15) {
                                    Image(.delete)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 18, height: 18)
                                    
                                    Text("Delete All Data")
                                        .font(.montserrat(.medium, size: 16))
                                        .foreground("EF4444")
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    
                                    Image(.chevronRight)
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 8, height: 14)
                                }
                                .padding(.horizontal, 20)
                                .frame(height: 60)
                                .background {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 30)
                                            .fill(Color("153453"))
                                        
                                        RoundedRectangle(cornerRadius: 30)
                                            .strokeBorder(Color("F9FEFE").opacity(0.1), lineWidth: 1)
                                    }
                                }
                            }
                        }
                        
                        // Privacy Policy
                        Button(action: openPrivacyPolicy) {
                            Text("Privacy Policy")
                                .font(.montserrat(.medium, size: 12))
                                .foreground("F9FEFE")
                                .frame(maxWidth: .infinity)
                                .frame(height: 24)
                                .contentShape(Rectangle())
                        }
                        .padding(.bottom, 40)
                    }
                    .font(.unbounded(.bold, size: 12))
                    .foreground("91B9FF")
                    .padding(.horizontal, 20)
                }
            }
        }
        .background {
            LinearGradient.main.ignoresSafeArea()
        }
        .alert("Delete All Data", isPresented: $showDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                statsManager.deleteAllData()
            }
        } message: {
            Text("This will permanently delete all your workout statistics and progress. This action cannot be undone.")
        }
    }
    
    private func rateApp() {
        if let scene = UIApplication.shared.connectedScenes.first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
    }
    
    private func shareApp() {
        let appURL = "https://apps.apple.com/us/app/id\(Constants.appID)?ls=1&mt=8"
        let activityVC = UIActivityViewController(
            activityItems: [appURL],
            applicationActivities: nil
        )
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
           let window = windowScene.windows.first {
            window.rootViewController?.present(activityVC, animated: true)
        }
    }
    
    private func openPrivacyPolicy() {
        UIApplication.shared.open(Constants.privacyPolicy)
    }
}

struct StatCard: View {
    let title: String
    let value: String
    
    var body: some View {
        VStack(spacing: 8) {
            Text(title)
                .font(.poppins(.medium, size: 12))
            
            Text(value)
                .font(.unbounded(.bold, size: 32))
        }
        .foregroundStyle(.white)
        .multilineTextAlignment(.center)
        .frame(width: 125, height: 104)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.1))
                
                RoundedRectangle(cornerRadius: 10)
                    .strokeBorder(Color.white.opacity(0.2), lineWidth: 1)
            }
        }
    }
}

struct SettingsButton: View {
    let icon: ImageResource
    let title: String
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 15) {
                Image(icon)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 20, height: 20)
                
                Text(title)
                    .font(.montserrat(.medium, size: 16))
                    .foreground("F9FEFE")
                    .frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(.horizontal, 20)
            .frame(height: 60)
            .background {
                ZStack {
                    RoundedRectangle(cornerRadius: 30)
                        .fill(Color("153453"))
                    
                    RoundedRectangle(cornerRadius: 30)
                        .strokeBorder(Color("F9FEFE").opacity(0.1), lineWidth: 1)
                }
            }
        }
    }
}

#Preview {
    StatsView()
        .environmentObject(StatsManager())
}