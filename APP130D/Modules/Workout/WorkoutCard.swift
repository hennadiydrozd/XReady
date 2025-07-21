import SwiftUI

struct WorkoutCard: View {
    let workout: Workout
    
    var body: some View {
        NavigationLink(destination: WorkoutDetailView(workout: workout)) {
            ZStack {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("005BAB"))
                
                VStack(spacing: 15) {
                    Text(workout.title)
                        .font(.unbounded(.bold, size: 22))
                    
                    Text(workout.subtitle)
                        .font(.unbounded(.regular, size: 13))
                }
                .foregroundStyle(.white)
                .multilineTextAlignment(.center)
            }
            .aspectRatio(283/275, contentMode: .fit)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    WorkoutCard(workout: .preWorkoutQuick)
}
