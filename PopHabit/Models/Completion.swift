import Foundation
import SwiftData

@Model
final class Completion {
    var id: UUID = UUID()
    var date: Date = Date()
    var xpEarned: Int = 0
    var habit: Habit?

    init(date: Date = Date(), xpEarned: Int = 0) {
        self.id = UUID()
        self.date = date
        self.xpEarned = xpEarned
    }
}
