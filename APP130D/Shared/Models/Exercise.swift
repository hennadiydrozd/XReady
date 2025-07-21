import Foundation

struct Exercise: Identifiable, Hashable {
    let id = UUID()
    let name: String
    let duration: TimeInterval
    let instructions: String
    let imageName: String
    
    init(name: String, duration: TimeInterval, instructions: String, imageName: String = "figure.walk") {
        self.name = name
        self.duration = duration
        self.instructions = instructions
        self.imageName = imageName
    }
}