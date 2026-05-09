import Foundation

@Observable
final class GamificationService {
    static let shared = GamificationService()

    private init() {}

    static func xpRequired(for level: Int) -> Int {
        if level <= 1 { return 0 }
        var total = 0
        for i in 1..<(level) {
            total += Int(Double(i) * 50 * pow(1.15, Double(i - 1)))
        }
        return total
    }

    func levelForXP(_ xp: Int) -> Int {
        var level = 1
        var accumulated = 0
        while true {
            let nextThreshold = Int(Double(level) * 50 * pow(1.15, Double(level - 1)))
            if accumulated + nextThreshold > xp { break }
            accumulated += nextThreshold
            level += 1
        }
        return level
    }

    func calculateXP(for habit: Habit, profile: UserProfile) -> Int {
        var xp = 10
        if habit.completionRate7Day >= 0.8 { xp += 5 }
        if habit.completionRate7Day >= 0.9 { xp += 3 }
        let consecutiveDays = calculateConsecutiveDays(for: habit)
        if consecutiveDays >= 3 { xp += 3 }
        if consecutiveDays >= 7 { xp += 5 }
        if consecutiveDays >= 30 { xp += 10 }
        if profile.lastPopDate == nil || !profile.lastPopDate!.isSameDay(as: Date().adding(days: -1)) {
            if !habit.isCompleted(on: Date()) {
                let todayCompletions = habit.completions.filter { $0.date.isToday }
                if todayCompletions.isEmpty { xp += 2 }
            }
        }
        return xp
    }

    private func calculateConsecutiveDays(for habit: Habit) -> Int {
        var count = 0
        var date = Date()
        if !habit.isCompleted(on: date) {
            date = date.adding(days: -1)
        }
        while habit.isCompleted(on: date) {
            count += 1
            date = date.adding(days: -1)
        }
        return count
    }

    func levelTitle(for level: Int) -> String {
        switch level {
        case 1...3: "Beginner"
        case 4...7: "Popper"
        case 8...12: "Habit Builder"
        case 13...18: "Streak Master"
        case 19...25: "Habit Hero"
        case 26...35: "Pop Legend"
        default: "PopHabit Royalty"
        }
    }
}
