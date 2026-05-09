import Foundation
import SwiftUI

@Observable
@MainActor
final class StatsViewModel {
    var habits: [Habit] = []
    var userProfile: UserProfile?
    var selectedPeriod: StatsPeriod = .week

    enum StatsPeriod: String, CaseIterable {
        case week = "Week"
        case month = "Month"
    }

    private let dataController = DataController.shared

    var overallCompletionRate: Double {
        guard !habits.isEmpty else { return 0 }
        let days = selectedPeriod == .week ? 7 : 30
        let rates = habits.map { CompletionRateCalculator.calculateRate(for: $0, days: days) }
        return rates.reduce(0, +) / Double(rates.count)
    }

    var overallGrade: CompletionGrade {
        CompletionGrade(rate: overallCompletionRate)
    }

    var totalPops: Int {
        habits.reduce(0) { $0 + $1.completions.count }
    }

    var bestHabit: Habit? {
        habits.max(by: { $0.completionRate7Day < $1.completionRate7Day })
    }

    var habitsNeedingLove: [Habit] {
        habits.filter { $0.trend == .needsLove }
    }

    var heatmapData: [DayCompletion] {
        let days = selectedPeriod == .week ? 7 : 30
        var data: [DayCompletion] = []
        for dayOffset in 0..<days {
            let date = Date().adding(days: -dayOffset)
            let completedCount = habits.filter { $0.isCompleted(on: date) }.count
            let rate = habits.isEmpty ? 0 : Double(completedCount) / Double(habits.count)
            data.append(DayCompletion(date: date, rate: rate, completedCount: completedCount, totalCount: habits.count))
        }
        return data.reversed()
    }

    struct DayCompletion {
        let date: Date
        let rate: Double
        let completedCount: Int
        let totalCount: Int
    }

    func loadStats() {
        do {
            habits = try dataController.fetchHabits()
            userProfile = try dataController.fetchUserProfile()
        } catch {}
    }
}
