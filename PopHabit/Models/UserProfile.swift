import Foundation
import SwiftData

@Model
final class UserProfile {
    var id: UUID = UUID()
    var totalXP: Int = 0
    var currentLevel: Int = 1
    var createdAt: Date = Date()
    var lastPopDate: Date?

    var xpForNextLevel: Int {
        GamificationService.xpRequired(for: currentLevel + 1)
    }

    var xpProgress: Double {
        let currentLevelXP = GamificationService.xpRequired(for: currentLevel)
        let nextLevelXP = GamificationService.xpRequired(for: currentLevel + 1)
        guard nextLevelXP > currentLevelXP else { return 1.0 }
        return Double(totalXP - currentLevelXP) / Double(nextLevelXP - currentLevelXP)
    }

    init() {
        self.id = UUID()
        self.totalXP = 0
        self.currentLevel = 1
        self.createdAt = Date()
    }
}
