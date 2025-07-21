import SwiftUI

struct ViewCustomRoutineView: View {
    let routine: CustomRoutine
    @ObservedObject var routinesManager: CustomRoutinesManager
    @Environment(\.dismiss) private var dismiss
    @State private var showingEdit = false
    @State private var showingExecution = false
    
    var body: some View {
        ZStack {
            LinearGradient.main
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.title2)
                            .foregroundColor(.white)
                    }
                    
                    Spacer()
                    
                    Button(action: {
                        showingEdit = true
                    }) {
                        Image(systemName: "square.and.pencil")
                            .font(.title2)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Routine header
                        VStack(spacing: 16) {
                            // Main image
                            ZStack {
                                RoundedRectangle(cornerRadius: 16)
                                    .fill(Color.white.opacity(0.1))
                                    .frame(height: 200)
                                
                                if let imageData = routine.imageData,
                                   let uiImage = UIImage(data: imageData) {
                                    Image(uiImage: uiImage)
                                        .resizable()
                                        .aspectRatio(contentMode: .fill)
                                        .frame(height: 200)
                                        .clipShape(RoundedRectangle(cornerRadius: 16))
                                } else {
                                    Image(systemName: "figure.strengthtraining.traditional")
                                        .font(.system(size: 60))
                                        .foregroundColor(.white.opacity(0.6))
                                }
                            }
                            
                            // Routine title
                            Text(routine.name.isEmpty ? "Untitled Routine" : routine.name)
                                .font(.system(size: 24, weight: .bold))
                                .foregroundColor(.white)
                                .multilineTextAlignment(.center)
                        }
                        
                        // Instructions section
                        if !routine.instructions.isEmpty {
                            VStack(alignment: .leading, spacing: 12) {
                                Text("Instructions")
                                    .font(.system(size: 18, weight: .semibold))
                                    .foregroundColor(.white)
                                
                                Text(routine.instructions)
                                    .font(.system(size: 16))
                                    .foregroundColor(.white.opacity(0.8))
                                    .multilineTextAlignment(.leading)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(16)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
                        }
                        
                        // Duration section
//                        if !routine.duration.isEmpty {
                            VStack(spacing: 8) {
                                Text("Duration")
                                    .font(.system(size: 16, weight: .medium))
                                    .foregroundColor(.white.opacity(0.8))
                                
                                Text(String(routine.duration))
                                    .font(.system(size: 24, weight: .bold))
                                    .foregroundColor(.white)
                            }
                            .frame(maxWidth: .infinity)
                            .frame(height: 80)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color.white.opacity(0.1))
                            )
//                        }
                        
                        // Start button
                        Button(action: {
                            showingExecution = true
                        }) {
                            Text("Start Routine")
                                .font(.system(size: 18, weight: .semibold))
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .frame(height: 56)
                                .background(
                                    RoundedRectangle(cornerRadius: 28)
                                        .fill(Color.blue)
                                )
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .navigationBarHidden(true)
        .sheet(isPresented: $showingEdit) {
            UnifiedRoutineView(routinesManager: routinesManager, routine: routine, mode: .edit)
        }
    }
}

#Preview {
    ViewCustomRoutineView(
        routine: CustomRoutine(
            name: "Morning Stretch",
            instructions: "A gentle morning stretch routine to wake up your body"
        ),
        routinesManager: CustomRoutinesManager()
    )
}