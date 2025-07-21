import Foundation

struct WorkoutStats: Codable {
    var preWorkoutQuickCount: Int = 0
    var preWorkoutFullCount: Int = 0
    var postWorkoutQuickCount: Int = 0
    var postWorkoutFullCount: Int = 0
    var customRoutinesCompleted: Int = 0
    var totalWorkoutsCompleted: Int = 0
    var totalWorkoutTime: Double = 0 
    var totalCustomRoutineTime: Double = 0
    var currentStreak: Int = 0
    var lastWorkoutDate: Date?
    
    static let `default` = WorkoutStats()
    
    var preWorkoutStats: [Int] {
        [preWorkoutQuickCount, preWorkoutFullCount, totalWorkoutsCompleted]
    }
    
    var postWorkoutStats: [Int] {
        [postWorkoutQuickCount, postWorkoutFullCount, Int(totalWorkoutTime / 60)] 
    }
    
    var generalStats: [Int] {
        [currentStreak, totalWorkoutsCompleted + customRoutinesCompleted, Int((totalWorkoutTime + totalCustomRoutineTime) / 3600)] 
    }
    
    var customRoutineStats: [Int] {
        [customRoutinesCompleted, Int(totalCustomRoutineTime / 60), Int(totalCustomRoutineTime / 3600)]
    }
}

class StatsManager: ObservableObject {
    @Published var stats = WorkoutStats()
    
    private let statsKey = "workout_stats"
    
    init() {
        loadStats()
    }
    
    func loadStats() {
        if let data = UserDefaults.standard.data(forKey: statsKey),
           let decodedStats = try? JSONDecoder().decode(WorkoutStats.self, from: data) {
            stats = decodedStats
        }
    }
    
    func saveStats() {
        if let encoded = try? JSONEncoder().encode(stats) {
            UserDefaults.standard.set(encoded, forKey: statsKey)
        }
    }
    
    func completeWorkout(_ workout: Workout) {
        switch workout {
        case .preWorkoutQuick:
            stats.preWorkoutQuickCount += 1
        case .preWorkoutFull:
            stats.preWorkoutFullCount += 1
        case .postWorkoutQuick:
            stats.postWorkoutQuickCount += 1
        case .postWorkoutFull:
            stats.postWorkoutFullCount += 1
        }
        
        stats.totalWorkoutsCompleted += 1
        stats.totalWorkoutTime += workout.totalDuration
        
        updateStreak()
        
        saveStats()
    }
    
    func completeCustomRoutine(_ routine: CustomRoutine, actualDuration: TimeInterval) {
        stats.customRoutinesCompleted += 1
        stats.totalCustomRoutineTime += actualDuration
        
        updateStreak()
        
        saveStats()
    }
    
    private func updateStreak() {
        let today = Calendar.current.startOfDay(for: Date())
        
        if let lastDate = stats.lastWorkoutDate {
            let lastWorkoutDay = Calendar.current.startOfDay(for: lastDate)
            let daysDifference = Calendar.current.dateComponents([.day], from: lastWorkoutDay, to: today).day ?? 0
            
            if daysDifference == 0 {
                return
            } else if daysDifference == 1 {
                stats.currentStreak += 1
            } else {
                stats.currentStreak = 1
            }
        } else {
            stats.currentStreak = 1
        }
        
        stats.lastWorkoutDate = Date()
    }
    
    func deleteAllData() {
        stats = WorkoutStats.default
        UserDefaults.standard.removeObject(forKey: statsKey)
        saveStats()
    }
}