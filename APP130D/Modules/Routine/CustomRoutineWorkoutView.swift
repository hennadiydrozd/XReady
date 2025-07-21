import SwiftUI

struct CustomRoutineWorkoutView: View {
    let routine: CustomRoutine
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject var statsManager: StatsManager
    
    @State private var timeRemaining: TimeInterval = 0
    @State private var isActive = false
    @State private var isFinished = false
    @State private var timer: Timer?
    @State private var startTime: Date?
    @State private var totalElapsedTime: TimeInterval = 0
    
    var body: some View {
        ZStack {
            if isFinished {
                Color("001326").ignoresSafeArea()
                finishedView
            } else {
                LinearGradient.main.ignoresSafeArea()
                activeView
            }
        }
        .navigationBarHidden(true)
        .onAppear {
            setupInitialState()
        }
        .onDisappear {
            stopTimer()
        }
    }
    
    private var activeView: some View {
        VStack(spacing: 0) {
            // Header
            HStack(spacing: 0) {
                Button(action: { dismiss() }) {
                    Image(.arrowLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                
                Text("Custom Routine")
                    .font(.unbounded(.bold, size: 24))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                
                Color.clear
                    .frame(width: 32, height: 32)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .background {
                Color.white
                    .opacity(0.1)
                    .ignoresSafeArea()
            }
            .padding(.bottom, 18)
            
            VStack(spacing: 20) {
                // Routine illustration
                ZStack {
                    if isActive {
                        if let imageData = routine.imageData,
                           let uiImage = UIImage(data: imageData) {
                            Image(uiImage: uiImage)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(Color("007BFF"), lineWidth: 5)
                                }
                                .frame(maxWidth: .infinity)
                                .padding(.horizontal, 20)
                                .transition(.move(edge: .trailing))
                        } else {
                            RoundedRectangle(cornerRadius: 20)
                                .fill(Color.white.opacity(0.1))
                                .frame(maxWidth: .infinity, maxHeight: 200)
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(Color("007BFF"), lineWidth: 5)
                                }
                                .overlay {
                                    Image(systemName: "figure.strengthtraining.traditional")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                                .padding(.horizontal, 20)
                                .transition(.move(edge: .trailing))
                        }
                    } else {
                        VStack(spacing: 12) {
                            Text(routine.name.isEmpty ? "Custom Routine" : routine.name)
                                .font(.unbounded(.regular, size: 20))
                                .foregroundStyle(.white)
                                .transition(.opacity.combined(with: .scale))
                            
                            if !routine.instructions.isEmpty {
                                Text(routine.instructions)
                                    .font(.unbounded(.regular, size: 16))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .padding(.horizontal, 40)
                                    .transition(.opacity.combined(with: .scale))
                            }
                        }
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: .infinity)
                        .transition(.move(edge: .leading))
                    }
                }
                .animation(.default, value: isActive)
                .frame(maxHeight: .infinity)
                
                // Timer
                HStack(spacing: 20) {
                    Button(action: resetRoutine) {
                        Image(.restart)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 62, maxHeight: 62)
                    }
                    
                    ZStack {
                        ZStack {
                            Circle()
                                .fill(Color("1765A9"))
                                .opacity(0.5)
                            
                            if isActive {
                                Circle()
                                    .fill(Color("075AA2"))
                                    .padding(10)
                                    .scaleEffect(timeRemaining.truncatingRemainder(dividingBy: 2) == 0 ? 1 : 0.8)
                                    .animation(.easeInOut(duration: 1).repeatForever(), value: timeRemaining)
                                    .zIndex(1)
                            }
                        }
                        .animation(.default, value: isActive)
                        
                        Text(formatTime(timeRemaining))
                            .font(.unbounded(.bold, size: 32))
                            .foregroundStyle(.white)
                    }
                    .frame(maxWidth: 178, maxHeight: 178)
                    
                    Button(action: toggleTimer) {
                        Image(isActive ? .pause : .play)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 62, maxHeight: 62)
                    }
                }
                
                // Finish button
                Button(
                    "Finish Routine",
                    action: finishRoutine
                )
                .buttonStyle(.customFill)
                .padding(.bottom, 35)
            }
        }
        .frame(maxHeight: .infinity)
    }
    
    private var finishedView: some View {
        VStack(spacing: 0) {
            Text("Routine\nComplete!")
                .font(.unbounded(.bold, size: 24))
                .foreground("70A4FF")
                .multilineTextAlignment(.center)
                .padding(.top, 14)
            
            VStack(spacing: 32) {
                Text("Great job")
                    .font(.unbounded(.bold, size: 35))
                    .foreground("FFEE00")
                
                Text("You finished your\ncustom routine")
                    .font(.unbounded(.regular, size: 20))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
                
                // Show stats summary
                VStack(spacing: 8) {
                    Text("Time: \(formatTime(totalElapsedTime))")
                        .font(.unbounded(.regular, size: 16))
                        .foregroundStyle(.white.opacity(0.8))
                    
                    Text("Total Custom Routines: \(statsManager.stats.customRoutinesCompleted)")
                        .font(.unbounded(.regular, size: 16))
                        .foregroundStyle(.white.opacity(0.8))
                }
                .padding(.top, 20)
            }
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 20) {
                Button("Repeat Routine", action: restartRoutine)
                    .buttonStyle(.customFill)
                
                Button("Back to Routines", action: { dismiss() })
                    .buttonStyle(.customStroke)
            }
            .padding(.bottom, 50)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        timeRemaining = TimeInterval(routine.duration)
        totalElapsedTime = 0
    }
    
    private func startTimer() {
        isActive = true
        startTime = Date()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
                totalElapsedTime += 1
            } else {
                finishRoutine()
            }
        }
    }
    
    private func stopTimer() {
        isActive = false
        timer?.invalidate()
        timer = nil
    }
    
    private func toggleTimer() {
        if isActive {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func resetRoutine() {
        stopTimer()
        timeRemaining = TimeInterval(routine.duration)
        totalElapsedTime = 0
    }
    
    private func finishRoutine() {
        stopTimer()
        
        // Calculate actual duration spent on the routine
        let actualDuration = totalElapsedTime > 0 ? totalElapsedTime : TimeInterval(routine.duration)
        
        // Update stats
        statsManager.completeCustomRoutine(routine, actualDuration: actualDuration)
        
        isFinished = true
    }
    
    private func restartRoutine() {
        isFinished = false
        setupInitialState()
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    CustomRoutineWorkoutView(
        routine: CustomRoutine(
            name: "Morning Stretch",
            instructions: "A gentle morning stretch routine to wake up your body",
            duration: 300
        )
    )
    .environmentObject(StatsManager())
}
