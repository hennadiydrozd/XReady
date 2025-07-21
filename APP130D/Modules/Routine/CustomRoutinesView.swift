import SwiftUI

struct CustomRoutinesView: View {
    @StateObject private var routinesManager = CustomRoutinesManager()
    @State private var showingCreateRoutine = false
    @State private var selectedRoutine: CustomRoutine?
    
    var body: some View {
        ZStack {
            LinearGradient.main
                .ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                Text("Custom\nRoutines List")
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
                
                
                if routinesManager.routines.isEmpty {
                    // Empty state
                    ZStack {
                        RoundedRectangle(cornerRadius: 18)
                            .fill(LinearGradient(colors: [Color("AAE7FF"), Color("3987F3")], startPoint: .topLeading, endPoint: .bottomTrailing))
                            .opacity(0.3)
                            .opacity(0.2)
                            .padding(.horizontal, 20)
                            .padding(.vertical, 60)
                        
                        VStack(spacing: 20) {
                            Button(action: {
                                showingCreateRoutine = true
                            }) {
                                Image(.circlePlus)
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 70, height: 70)
                            }
                            
                            Text("No custom routines yet.\nTap + to create one")
                                .font(.unbounded(.regular, size: 18))
                                .foreground("9B98BB")
                                .multilineTextAlignment(.center)
                        }
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                } else {
                    // Routines list
                    ScrollView {
                        LazyVStack(spacing: 16) {
                            ForEach(routinesManager.routines) { routine in
                                Button(action: {
                                    selectedRoutine = routine
                                }) {
                                    CustomRoutineCard(routine: routine)
                                }
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                    .overlay(alignment: .bottom) {
                        Button("+ Add more", action: {
                            showingCreateRoutine = true
                        })
                        .buttonStyle(.customFill)
                        .padding(.bottom, 34)
                    }
                }
            }
        }
        .sheet(isPresented: $showingCreateRoutine) {
            UnifiedRoutineView(routinesManager: routinesManager, mode: .create)
        }
        .sheet(item: $selectedRoutine) { routine in
            UnifiedRoutineView(routinesManager: routinesManager, routine: routine, mode: .detail)
        }
    }
}

struct CustomRoutineCard: View {
    let routine: CustomRoutine
    
    var body: some View {
        HStack(spacing: 16) {
            // Routine image or placeholder
            ZStack {
                if let imageData = routine.imageData,
                   let uiImage = UIImage(data: imageData) {
                    Image(uiImage: uiImage)
                        .scaleAspectFill()
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                } else {
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.1))
                    
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 30))
                        .foregroundColor(.white.opacity(0.6))
                }
            }
            .aspectRatio(1, contentMode: .fit)
            .frame(width: 70, height: 70)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(routine.name.isEmpty ? "Untitled Routine" : routine.name)
                    .font(.unbounded(.regular, size: 14))
                    .foregroundStyle(.white)
                    .lineLimit(1)
                                
                if !routine.instructions.isEmpty {
                    Text(routine.instructions)
                        .font(.unbounded(.regular, size: 12))
                        .foreground("9B98BB")
                        .multilineTextAlignment(.leading)
                        .lineLimit(2)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .topLeading)
        }
        .padding(16)
        .frame(height: 90)
        .background {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(LinearGradient(colors: [Color("3987F3"), Color("AAE7FF")], startPoint: .topLeading, endPoint: .bottomTrailing))
                
                RoundedRectangle(cornerRadius: 8)
                    .strokeBorder(Color.white, lineWidth: 1)
            }
            .opacity(0.2)
        }
    }
}

#Preview {
    CustomRoutinesView()
}