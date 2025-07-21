import Foundation

enum Constants {
    static let privacyPolicy = URL(string: "https://sites.google.com/view/xreadyapp/privacy-policy")!
    static let appID = "6748915738"
}

enum SaveKey {
    static let showOnboarding = "showOnboarding"
    static let workoutStats = "workout_stats"
}

extension Notification.Name {
    static let closePreloader = Notification.Name("closePreloader")
}
