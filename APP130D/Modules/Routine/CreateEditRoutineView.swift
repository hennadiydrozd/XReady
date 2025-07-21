import SwiftUI
import PhotosUI

struct CreateEditRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var routinesManager: CustomRoutinesManager
    
    @State private var routine: CustomRoutine
    @State private var isEditing: Bool
    @State private var selectedImage: PhotosPickerItem?
    @State private var showingDurationPicker = false
    
    // Computed properties for minutes and seconds from routine duration
    private var minutes: Int {
        routine.duration / 60
    }
    
    private var seconds: Int {
        routine.duration % 60
    }
    
    init(routinesManager: CustomRoutinesManager, routine: CustomRoutine? = nil) {
        self.routinesManager = routinesManager
        self.routine = routine ?? CustomRoutine()
        self.isEditing = routine != nil
    }
    
    var body: some View {
        ZStack {
            Color.white.ignoresSafeArea()
            
            VStack(spacing: 20) {
                // Header
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
                    
                    Text(isEditing ? "Edit Routine" : "Add Routine")
                        .font(.unbounded(.semiBold, size: 20))
                        .foreground("02003A")
                        .frame(maxWidth: .infinity)
                    
                    Button {
                        saveRoutine()
                    } label: {
                        Image(.save)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                    }
                    .disabled(routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                }
                .padding(.horizontal, 20)
                .padding(.top, 10)
                
                ScrollView {
                    VStack(spacing: 24) {
                        // Image picker section
                        VStack(spacing: 16) {
                            PhotosPicker(selection: $selectedImage, matching: .images) {
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
                                        
                                        Image(.photoPlaceholder)
                                            .resizable()
                                            .scaledToFit()
                                            .frame(width: 60, height: 60)
                                    }
                                }
                            }
                            .onChange(of: selectedImage) { newItem in
                                Task {
                                    if let data = try? await newItem?.loadTransferable(type: Data.self) {
                                        routine.imageData = data
                                    }
                                }
                            }
                        }
                        
                        // Routine name
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Routine Name")
                                .font(.unbounded(.semiBold, size: 12))
                                .foreground("5A5A5A")
                            
                            TextField("Enter routine name", text: $routine.name)
                                .textFieldStyle(CustomTextFieldStyle())
                        }
                        
                        // Instructions
                        VStack(alignment: .leading, spacing: 10) {
                            Text("Instructions")
                                .font(.unbounded(.semiBold, size: 12))
                                .foreground("5A5A5A")

                            ZStack(alignment: .topLeading) {
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("F2F2F2"))
                              
                                TextField("Enter routine instructions...", text: $routine.instructions, axis: .vertical)
                                    .font(.inter(.semiBold, size: 14))
                                    .foregroundStyle(.black)
                                    .padding(.vertical, 12)
                                    .padding(.horizontal, 24)
                            }
                            .frame(height: 120)
                        }
                        
                        // Duration
                        VStack(alignment: .leading, spacing: 12) {
                            Text("Duration")
                                .font(.unbounded(.semiBold, size: 12))
                                .foreground("5A5A5A")
                                .frame(maxWidth: .infinity, alignment: .leading)
                            
                            Button(action: {
                                showingDurationPicker = true
                            }) {
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
                        }
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 20)
                    .padding(.bottom, 100)
                }
            }
        }
        .sheet(isPresented: $showingDurationPicker) {
            DurationPickerView(duration: $routine.duration)
                .presentationDetents([.height(260)])
        }
    }
    
    private func saveRoutine() {
        if isEditing {
            routinesManager.updateRoutine(routine)
        } else {
            routinesManager.addRoutine(routine)
        }
        dismiss()
    }
}

#Preview {
    CreateEditRoutineView(routinesManager: CustomRoutinesManager())
}