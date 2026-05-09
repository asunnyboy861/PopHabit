import Foundation
import SwiftUI

@Observable
@MainActor
final class TodayViewModel {
    var habits: [Habit] = []
    var userProfile: UserProfile?
    var showLevelUp = false
    var poppedHabitId: UUID?
    var xpEarned: Int = 0
    var showProUpgrade = false

    private let dataController = DataController.shared
    private let soundManager = SoundManager.shared
    private let hapticManager = HapticManager.shared

    var greeting: String {
        Date().greeting
    }

    var todayProgress: Double {
        guard !habits.isEmpty else { return 0 }
        let completed = habits.filter { $0.isCompleted() }.count
        return Double(completed) / Double(habits.count)
    }

    var completedCount: Int {
        habits.filter { $0.isCompleted() }.count
    }

    var totalHabits: Int {
        habits.count
    }

    var canAddMoreHabits: Bool {
        guard let count = try? dataController.fetchHabitCount() else { return true }
        return count < 5 || UserDefaults.standard.isProUser
    }

    func loadHabits() {
        do {
            habits = try dataController.fetchTodayHabits()
            userProfile = try dataController.fetchUserProfile()
        } catch {}
    }

    func popHabit(_ habit: Habit) {
        do {
            let result = try dataController.popHabit(habit)
            xpEarned = result.xp
            poppedHabitId = habit.id
            soundManager.playPop()
            hapticManager.pop()
            if result.leveledUp {
                showLevelUp = true
                soundManager.playLevelUp()
                hapticManager.levelUp()
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                self.poppedHabitId = nil
            }
            loadHabits()
        } catch {}
    }

    func unpopHabit(_ habit: Habit) {
        do {
            try dataController.unpopHabit(habit)
            loadHabits()
        } catch {}
    }

    func deleteHabit(_ habit: Habit) {
        do {
            try dataController.deleteHabit(habit)
            loadHabits()
        } catch {}
    }

    func moveHabit(from source: IndexSet, to destination: Int) {
        habits.move(fromOffsets: source, toOffset: destination)
        do {
            try dataController.reorderHabits(habits)
        } catch {}
    }
}
