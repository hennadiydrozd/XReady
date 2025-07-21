import Foundation
import SwiftUI

class CustomRoutinesManager: ObservableObject {
    @Published var routines: [CustomRoutine] = []
    
    private let userDefaults = UserDefaults.standard
    private let routinesKey = "customRoutines"
    
    init() {
        loadRoutines()
    }
    
    func loadRoutines() {
        if let data = userDefaults.data(forKey: routinesKey),
           let decodedRoutines = try? JSONDecoder().decode([CustomRoutine].self, from: data) {
            routines = decodedRoutines
        }
    }
    
    func saveRoutines() {
        if let data = try? JSONEncoder().encode(routines) {
            userDefaults.set(data, forKey: routinesKey)
        }
    }
    
    func addRoutine(_ routine: CustomRoutine) {
        routines.append(routine)
        saveRoutines()
    }
    
    func updateRoutine(_ routine: CustomRoutine) {
        if let index = routines.firstIndex(where: { $0.id == routine.id }) {
            var updatedRoutine = routine
//            updatedRoutine.updateTimestamp()
            routines[index] = updatedRoutine
            saveRoutines()
        }
    }
    
    func deleteRoutine(_ routine: CustomRoutine) {
        routines.removeAll { $0.id == routine.id }
        saveRoutines()
    }
    
    func deleteRoutine(at indexSet: IndexSet) {
        routines.remove(atOffsets: indexSet)
        saveRoutines()
    }
}
