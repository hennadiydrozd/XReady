import SwiftUI
import PhotosUI

enum RoutineViewMode {
    case detail
    case edit
    case create
}

struct UnifiedRoutineView: View {
    @Environment(\.dismiss) private var dismiss
    @ObservedObject var routinesManager: CustomRoutinesManager
    
    @State private var routine: CustomRoutine
    @State private var originalRoutine: CustomRoutine
    @State private var mode: RoutineViewMode
    @State private var selectedImage: PhotosPickerItem?
    @State private var showingDurationPicker = false
    @State private var showingExecution = false
    
    // Computed properties for minutes and seconds from routine duration
    private var minutes: Int {
        routine.duration / 60
    }
    
    private var seconds: Int {
        routine.duration % 60
    }
    
    init(routinesManager: CustomRoutinesManager, routine: CustomRoutine? = nil, mode: RoutineViewMode = .detail) {
        self.routinesManager = routinesManager
        let targetRoutine = routine ?? CustomRoutine()
        self.routine = targetRoutine
        self.originalRoutine = targetRoutine
        self.mode = mode
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                
                VStack(spacing: 20) {
                    // Header
                    HStack {
                        Button {
                            if mode == .edit {
                                // Reset to original routine and switch to detail mode
                                routine = originalRoutine
                                mode = .detail
                            } else {
                                dismiss()
                            }
                        } label: {
                            Image(.arrowLeft)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24)
                                .frame(width: 30, height: 30)
                        }
                        
                        Text(headerTitle)
                            .font(.unbounded(.semiBold, size: 20))
                            .foreground("02003A")
                            .frame(maxWidth: .infinity)
                        
                        Button {
                            switch mode {
                            case .detail:
                                mode = .edit
                            case .edit, .create:
                                saveRoutine()
                            }
                        } label: {
                            Image(mode == .detail ? .edit : .save)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
                        }
                        .disabled(isCreateOrEditMode && routine.name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty)
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, 10)
                    
                    ScrollView {
                        VStack(spacing: 24) {
                            // Image section
                            imageSection
                            
                            // Routine name
                            routineNameSection
                            
                            // Instructions
                            if !routine.instructions.isEmpty || isCreateOrEditMode {
                                instructionsSection
                            }
                            
                            // Duration
                            durationSection
                            
                            // Start button (only in detail mode)
                            if mode == .detail {
                                startButton
                            }
                        }
                        .padding(.horizontal, 20)
                        .padding(.top, 20)
                        .padding(.bottom, 100)
                    }
                }
            }
        }
        .sheet(isPresented: $showingDurationPicker) {
            DurationPickerView(duration: $routine.duration)
                .presentationDetents([.height(260)])
        }
        .fullScreenCover(isPresented: $showingExecution) {
            CustomRoutineWorkoutView(routine: routine)
        }
    }
    
    // MARK: - Computed Properties
    
    private var headerTitle: String {
        switch mode {
        case .detail:
            return "Custom routine"
        case .edit:
            return "Edit Routine"
        case .create:
            return "Add Routine"
        }
    }
    
    private var isCreateOrEditMode: Bool {
        mode == .create || mode == .edit
    }
    
    // MARK: - View Components
    
    private var imageSection: some View {
        Group {
            if isCreateOrEditMode {
                PhotosPicker(selection: $selectedImage, matching: .images) {
                    imageContent
                }
                .onChange(of: selectedImage) { newItem in
                    Task {
                        if let data = try? await newItem?.loadTransferable(type: Data.self) {
                            routine.imageData = data
                        }
                    }
                }
            } else {
                imageContent
            }
        }
    }
    
    private var imageContent: some View {
        ZStack {
            if let imageData = routine.imageData,
               let uiImage = UIImage(data: imageData) {
                Image(uiImage: uiImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: 120)
                    .clipShape(RoundedRectangle(cornerRadius: 10))
            } else {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("F2F2F2"))
                    .frame(height: 120)
                
                if isCreateOrEditMode {
                    Image(.photoPlaceholder)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 60, height: 60)
                } else {
                    Image(systemName: "figure.strengthtraining.traditional")
                        .font(.system(size: 30))
                        .foregroundColor(.black.opacity(0.6))
                }
            }
        }
    }
    
    private var routineNameSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Routine Name")
                .font(.unbounded(.semiBold, size: 12))
                .foreground("5A5A5A")
            
            if isCreateOrEditMode {
                TextField("Enter routine name", text: $routine.name)
                    .textFieldStyle(CustomTextFieldStyle())
            } else {
                TextField("Routine name", text: .constant(routine.name), axis: .vertical)
                    .textFieldStyle(CustomTextFieldStyle())
                    .frame(minHeight: 50)
                    .allowsHitTesting(false)
            }
        }
    }
    
    private var instructionsSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            Text("Instructions")
                .font(.unbounded(.semiBold, size: 12))
                .foreground("5A5A5A")
            
            ZStack(alignment: .topLeading) {
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color("F2F2F2"))
                
                if isCreateOrEditMode {
                    TextField("Enter routine instructions...", text: $routine.instructions, axis: .vertical)
                        .font(.inter(.semiBold, size: 14))
                        .foregroundStyle(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                } else {
                    TextField("Routine instructions", text: .constant(routine.instructions), axis: .vertical)
                        .font(.inter(.semiBold, size: 14))
                        .foregroundStyle(.black)
                        .padding(.vertical, 12)
                        .padding(.horizontal, 24)
                        .allowsHitTesting(false)
                }
            }
            .frame(minHeight: 120)
        }
    }
    
    private var durationSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Duration")
                .font(.unbounded(.semiBold, size: 12))
                .foreground("5A5A5A")
                .frame(maxWidth: .infinity, alignment: .leading)
            
            if isCreateOrEditMode {
                Button(action: {
                    showingDurationPicker = true
                }) {
                    durationDisplay
                }
            } else {
                durationDisplay
            }
        }
    }
    
    private var durationDisplay: some View {
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
    
    private var startButton: some View {
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
    
    // MARK: - Helper Functions
    
    private func saveRoutine() {
        if mode == .edit {
            routinesManager.updateRoutine(routine)
            originalRoutine = routine
            mode = .detail
        } else if mode == .create {
            routinesManager.addRoutine(routine)
            dismiss()
        }
    }
}

#Preview {
    UnifiedRoutineView(
        routinesManager: CustomRoutinesManager(),
        routine: CustomRoutine(name: "Test Routine", instructions: "Test instructions"),
        mode: .detail
    )
}