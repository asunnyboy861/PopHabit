import Foundation
import SwiftData

struct CompletionRateCalculator {
    static func calculateRate(for habit: Habit, days: Int) -> Double {
        let startDate = Date().adding(days: -days)
        let relevantCompletions = habit.completions.filter { $0.date >= startDate }
        var expectedDays = 0
        for dayOffset in 0..<days {
            let date = Date().adding(days: -dayOffset)
            if shouldTrackOnDate(habit: habit, date: date) {
                expectedDays += 1
            }
        }
        guard expectedDays > 0 else { return 0 }
        var completedDays = Set<Date>()
        for completion in relevantCompletions {
            let dayStart = completion.date.startOfDay
            completedDays.insert(dayStart)
        }
        var actualCompleted = 0
        for dayOffset in 0..<days {
            let date = Date().adding(days: -dayOffset)
            if shouldTrackOnDate(habit: habit, date: date) {
                if completedDays.contains(date.startOfDay) {
                    actualCompleted += 1
                }
            }
        }
        return Double(actualCompleted) / Double(expectedDays)
    }

    static func calculateTrend(for habit: Habit) -> Trend {
        let recentRate = calculateRate(for: habit, days: 7)
        let olderRate = calculateRate(for: habit, days: 14)
        let diff = recentRate - olderRate
        if diff > 0.05 { return .improving }
        if diff < -0.05 { return .needsLove }
        return .stable
    }

    private static func shouldTrackOnDate(habit: Habit, date: Date) -> Bool {
        switch habit.frequency {
        case .daily: return true
        case .weekdays:
            let weekday = Calendar.current.component(.weekday, from: date)
            return (2...6).contains(weekday)
        case .weekends:
            let weekday = Calendar.current.component(.weekday, from: date)
            return weekday == 1 || weekday == 7
        case .weekly:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: date))!
            return date == startOfWeek
        case .custom:
            let weekday = Calendar.current.component(.weekday, from: date) - 1
            return habit.customDays.contains(weekday)
        }
    }
}
