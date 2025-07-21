import SwiftUI

struct WorkoutDetailView: View {
    let workout: Workout
    @EnvironmentObject var statsManager: StatsManager
    
    @State private var currentExerciseIndex = 0
    @State private var timeRemaining: TimeInterval = 0
    @State private var isActive = false
    @State private var isFinished = false
    @State private var timer: Timer?
    @State private var rotationAngle: Double = 0
    @Environment(\.goBack) private var goBack
    
    private var currentExercise: Exercise? {
        guard currentExerciseIndex < workout.exercises.count else { return nil }
        return workout.exercises[currentExerciseIndex]
    }
    
    private var isLastExercise: Bool {
        currentExerciseIndex >= workout.exercises.count - 1
    }
    
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
        .hideSystemNavBar()
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
                Button(action: { goBack() }) {
                    Image(.arrowLeft)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 32, height: 32)
                }
                
                Text(workout.title)
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
                // Exercise illustration
                if let exercise = currentExercise {
                    ZStack {
                        if isActive {
                            Image(exercise.imageName)
                                .resizable()
                                .scaledToFit()
                                .clipShape(RoundedRectangle(cornerRadius: 20))
                                .overlay {
                                    RoundedRectangle(cornerRadius: 20)
                                        .strokeBorder(Color("007BFF"), lineWidth: 5)
                                }
                                .frame(maxWidth: .infinity)
                                .transition(.move(edge: .trailing))
                        } else {
                            VStack(spacing: 12) {
                                Text(exercise.name)
                                    .font(.unbounded(.regular, size: 20))
                                    .foregroundStyle(.white)
                                    .transition(.opacity.combined(with: .scale))
                                
                                Text(exercise.instructions)
                                    .font(.unbounded(.regular, size: 16))
                                    .foregroundStyle(.white.opacity(0.8))
                                    .padding(.horizontal, 40)
                                    .transition(.opacity.combined(with: .scale))
                            }
                            .multilineTextAlignment(.center)
                            .frame(maxWidth: .infinity)
                            .transition(.move(edge: .leading))
                        }
                    }
                    .animation(.default, value: isActive)
                    .frame(maxHeight: .infinity)
                }
                
                // Timer
                HStack(spacing: 20) {
                    Button(action: resetExercise) {
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
                
                // Next button
                Button(
                    isLastExercise ? "Finish Workout" : "Next Step",
                    action: nextExercise
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
                
                Text("You finished your\n\(workout.title.lowercased())")
                    .font(.unbounded(.regular, size: 20))
                    .foregroundStyle(.white)
                    .multilineTextAlignment(.center)
            }
            .frame(maxHeight: .infinity)
            
            VStack(spacing: 20) {
                Button("Repeat Routine", action: restartWorkout)
                    .buttonStyle(.customFill)
                
                Button("Back to Main Menu", action: { goBack() })
                    .buttonStyle(.customStroke)
            }
            .padding(.bottom, 50)
        }
    }
    
    // MARK: - Private Methods
    
    private func setupInitialState() {
        guard let firstExercise = workout.exercises.first else { return }
        timeRemaining = firstExercise.duration
    }
    
    private func startTimer() {
        isActive = true
        startRotationAnimation()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            if timeRemaining > 0 {
                timeRemaining -= 1
            } else {
                nextExercise()
            }
        }
    }
    
    private func stopTimer() {
        isActive = false
        stopRotationAnimation()
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
    
    private func resetExercise() {
        stopTimer()
        guard let exercise = currentExercise else { return }
        timeRemaining = exercise.duration
    }
    
    private func nextExercise() {
        stopTimer()
        
        if isLastExercise {
            isFinished = true
        } else {
            statsManager.completeWorkout(workout)
            currentExerciseIndex += 1
            if let nextExercise = currentExercise {
                timeRemaining = nextExercise.duration
            }
        }
    }
    
    private func restartWorkout() {
        currentExerciseIndex = 0
        isFinished = false
        setupInitialState()
    }
    
    private func startRotationAnimation() {
        withAnimation(.linear(duration: 2).repeatForever(autoreverses: false)) {
            rotationAngle = 360
        }
    }
    
    private func stopRotationAnimation() {
        withAnimation(.easeOut(duration: 0.5)) {
            rotationAngle = 0
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    NavigationStack {
        WorkoutDetailView(workout: .preWorkoutQuick)
    }
}
