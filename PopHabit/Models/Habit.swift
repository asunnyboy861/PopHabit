import Foundation
import SwiftData

@Model
final class Habit {
    var id: UUID = UUID()
    var name: String = ""
    var icon: String = "circle.fill"
    var colorHex: String = "007AFF"
    var frequency: Frequency = Frequency.daily
    var customDays: [Int] = []
    var createdAt: Date = Date()
    var sortOrder: Int = 0
    var reminderEnabled: Bool = false
    var reminderTime: Date = Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date()) ?? Date()
    @Relationship(deleteRule: .cascade, inverse: \Completion.habit)
    var completions: [Completion] = []

    init(name: String, icon: String = "circle.fill", colorHex: String = "007AFF", frequency: Frequency = Frequency.daily, customDays: [Int] = []) {
        self.id = UUID()
        self.name = name
        self.icon = icon
        self.colorHex = colorHex
        self.frequency = frequency
        self.customDays = customDays
        self.createdAt = Date()
        self.sortOrder = 0
    }

    var completionRate7Day: Double {
        CompletionRateCalculator.calculateRate(for: self, days: 7)
    }

    var completionRate30Day: Double {
        CompletionRateCalculator.calculateRate(for: self, days: 30)
    }

    var grade: CompletionGrade {
        CompletionGrade(rate: completionRate7Day)
    }

    var trend: Trend {
        CompletionRateCalculator.calculateTrend(for: self)
    }

    func isCompleted(on date: Date = Date()) -> Bool {
        completions.contains { $0.date.isSameDay(as: date) }
    }

    func completions(in days: Int) -> [Completion] {
        let startDate = Date().adding(days: -days)
        return completions.filter { $0.date >= startDate }
    }

    var shouldShowToday: Bool {
        guard frequency != .custom else {
            let weekday = Calendar.current.component(.weekday, from: Date()) - 1
            return customDays.contains(weekday)
        }
        switch frequency {
        case .daily, .weekdays:
            let weekday = Calendar.current.component(.weekday, from: Date())
            return frequency == .weekdays ? (2...6).contains(weekday) : true
        case .weekends:
            let weekday = Calendar.current.component(.weekday, from: Date())
            return weekday == 1 || weekday == 7
        case .weekly:
            let startOfWeek = Calendar.current.date(from: Calendar.current.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date()))!
            return !completions.contains { $0.date >= startOfWeek }
        case .custom:
            return true
        }
    }
}
