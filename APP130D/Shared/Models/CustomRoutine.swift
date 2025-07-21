import Foundation
import SwiftUI

struct CustomRoutine: Identifiable, Codable, Hashable {
    var id = UUID().uuidString
    var name: String = ""
    var instructions: String = ""
    var duration: Int = 30
    var imageData: Data? // Store image as Data for persistence
    var createdAt = Date()
}
