import Foundation
import SwiftUI

@Observable
@MainActor
final class HabitEditViewModel {
    var name: String = ""
    var icon: String = "circle.fill"
    var colorHex: String = "007AFF"
    var frequency: Frequency = .daily
    var customDays: [Int] = []
    var reminderEnabled: Bool = false
    var reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()

    private let dataController = DataController.shared

    let availableIcons = [
        "figure.run", "book.fill", "drop.fill", "heart.fill",
        "brain.head.profile.fill", "bed.double.fill", "leaf.fill",
        "dumbbell.fill", "music.note", "pencil", "sunrise.fill",
        "cup.and.saucer.fill", "car.fill", "phone.fill",
        "face.smiling", "star.fill", "flame.fill", "bolt.fill"
    ]

    let availableColors = [
        "007AFF", "34C759", "FFD60A", "AF52DE",
        "FF6B9D", "FF9500", "5AC8FA", "FF3B30",
        "64D2FF", "30D158", "BF5AF2", "FF6482"
    ]

    var isValid: Bool {
        !name.trimmingCharacters(in: .whitespaces).isEmpty
    }

    func createHabit() -> Habit? {
        guard isValid else { return nil }
        do {
            return try dataController.createHabit(
                name: name.trimmingCharacters(in: .whitespaces),
                icon: icon,
                colorHex: colorHex,
                frequency: frequency,
                customDays: customDays
            )
        } catch {
            return nil
        }
    }

    func loadFromHabit(_ habit: Habit) {
        name = habit.name
        icon = habit.icon
        colorHex = habit.colorHex
        frequency = habit.frequency
        customDays = habit.customDays
        reminderEnabled = habit.reminderEnabled
        reminderTime = habit.reminderTime
    }
}
