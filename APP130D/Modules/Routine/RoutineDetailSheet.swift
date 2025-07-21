import SwiftUI

struct RoutineDetailSheet: View {
    let routine: CustomRoutine
    @ObservedObject var routinesManager: CustomRoutinesManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingEdit = false
    @State private var showingExecution = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    HStack {
                        Button {
                            dismiss()
                        } label: {
                            Image(.arrowLeft)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24)
                                .frame(width: 30, height: 30)
                        }
                        
                        Text("Custom routine")
                            .font(.unbounded(.semiBold, size: 20))
                            .foreground("02003A")
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            showingEdit = true
                        } label: {
                            Image(.edit)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            ZStack {
                                if let imageData = routine.imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .scaleAspectFill()
                                        .frame(height: 120)
                                        .clipShape(RoundedRectangle(cornerRadius: 10))
                                } else {
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("F2F2F2"))
                                        .frame(height: 120)
                                  
                                    Image(systemName: "figure.strengthtraining.traditional")
                                        .font(.system(size: 30))
                                        .foregroundColor(.black.opacity(0.6))
                                }
                            }
                            
                            // Routine name
                            VStack(alignment: .leading, spacing: 10) {
                                Text("Routine Name")
                                    .font(.unbounded(.semiBold, size: 12))
                                    .foreground("5A5A5A")
                                
                                TextField("Routine name", text: .constant(routine.name), axis: .vertical)
                                    .textFieldStyle(CustomTextFieldStyle())
                                    .frame(minHeight: 50)
                                    .allowsHitTesting(false)
                            }
                            
                            if !routine.instructions.isEmpty {
                                // Instructions
                                VStack(alignment: .leading, spacing: 10) {
                                    Text("Instructions")
                                        .font(.unbounded(.semiBold, size: 12))
                                        .foreground("5A5A5A")
                                    
                                    ZStack(alignment: .topLeading) {
                                        RoundedRectangle(cornerRadius: 10)
                                            .fill(Color("F2F2F2"))
                                        
                                        TextField("Routine instructions", text: .constant(routine.instructions), axis: .vertical)
                                            .font(.inter(.semiBold, size: 14))
                                            .foregroundStyle(.black)
                                            .padding(.vertical, 12)
                                            .padding(.horizontal, 24)
                                            .allowsHitTesting(false)
                                    }
                                    .frame(minHeight: 120)
                                }
                            }
                            
                            // Duration
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Duration")
                                    .font(.unbounded(.semiBold, size: 12))
                                    .foreground("5A5A5A")
                                    .frame(maxWidth: .infinity, alignment: .leading)
                                
                                let minutes = Int(routine.duration) / 60
                                let seconds = Int(routine.duration) % 60
                                HStack(spacing: 5) {
                                    // Minutes
                                    Text(String(format: "%02d", minutes))
                                        .font(.unbounded(.semiBold, size: 25))
                                        .foregroundStyle(.black)
                                        .frame(height: 50)
                                        .frame(maxWidth: .infinity)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("F2F2F2"))
                                        }
                                    
                                    Text(":")
                                        .font(.unbounded(.semiBold, size: 25))
                                        .foregroundStyle(.black)
                                        .frame(width: 10, height: 25)
                                    
                                    // Seconds
                                    Text(String(format: "%02d", seconds))
                                        .font(.unbounded(.semiBold, size: 25))
                                        .foregroundStyle(.black)
                                        .frame(height: 50)
                                        .frame(maxWidth: .infinity)
                                        .background {
                                            RoundedRectangle(cornerRadius: 10)
                                                .fill(Color("F2F2F2"))
                                        }
                                }
                            }
                            
                            // Start button
                            Button(action: {
                                showingExecution = true
                            }) {
                                Text("Start Routine")
                                    .font(.unbounded(.bold, size: 18))
                                    .foregroundStyle(.white)
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 56)
                                    .background(
                                        RoundedRectangle(cornerRadius: 28)
                                            .fill(Color.blue)
                                    )
                            }
                            .padding(.horizontal, 20)
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingEdit) {
            CreateEditRoutineView(routinesManager: routinesManager, routine: routine)
        }
        .fullScreenCover(isPresented: $showingExecution) {
            CustomRoutineWorkoutView(routine: routine)
        }
    }
    
    private func formatTime(_ seconds: TimeInterval) -> String {
        let minutes = Int(seconds) / 60
        let remainingSeconds = Int(seconds) % 60
        return String(format: "%02d:%02d", minutes, remainingSeconds)
    }
}

#Preview {
    RoutineDetailSheet(
        routine: CustomRoutine(name: "Test name", instructions: "Instructions"),
        routinesManager: .init()
    )
}
