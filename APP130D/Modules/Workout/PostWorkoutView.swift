import SwiftUI

struct PostWorkoutView: View {
    var body: some View {
        VStack(spacing: 0) {
            Text("Post-Workout\nStretch")
                .font(.unbounded(.bold, size: 24))
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
                .frame(maxWidth: .infinity)
                .padding(.vertical, 14)
                .background {
                    Color.white
                        .opacity(0.1)
                        .ignoresSafeArea()
                }
            
            VStack(spacing: 30) {
                // Quick Warm-up Card
                WorkoutCard(workout: .postWorkoutQuick)
                
                // Full Warm-up Card
                WorkoutCard(workout: .postWorkoutFull)
            }
            .frame(maxHeight: .infinity)
            .padding(.vertical, 18)
        }
    }
}

#Preview {
    ZStack {
        LinearGradient.main.ignoresSafeArea()
        PostWorkoutView()
    }
}
