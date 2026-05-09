import Foundation
import SwiftData

@MainActor
final class DataController {
    static let shared = DataController()

    let modelContainer: ModelContainer

    var modelContext: ModelContext {
        modelContainer.mainContext
    }

    private init() {
        let schema = Schema([Habit.self, Completion.self, UserProfile.self])
        let config = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            modelContainer = try ModelContainer(for: schema, configurations: [config])
        } catch {
            fatalError("Failed to create ModelContainer: \(error)")
        }
    }

    func fetchHabits() throws -> [Habit] {
        let descriptor = FetchDescriptor<Habit>(sortBy: [SortDescriptor(\.sortOrder)])
        return try modelContext.fetch(descriptor)
    }

    func fetchHabitCount() throws -> Int {
        let descriptor = FetchDescriptor<Habit>()
        return try modelContext.fetchCount(descriptor)
    }

    func fetchTodayHabits() throws -> [Habit] {
        let habits = try fetchHabits()
        return habits.filter { $0.shouldShowToday }
    }

    func fetchUserProfile() throws -> UserProfile {
        let descriptor = FetchDescriptor<UserProfile>()
        let profiles = try modelContext.fetch(descriptor)
        if let profile = profiles.first {
            return profile
        }
        let profile = UserProfile()
        modelContext.insert(profile)
        try modelContext.save()
        return profile
    }

    func createHabit(name: String, icon: String, colorHex: String, frequency: Frequency = Frequency.daily, customDays: [Int] = []) throws -> Habit {
        let count = try fetchHabitCount()
        let habit = Habit(name: name, icon: icon, colorHex: colorHex, frequency: frequency, customDays: customDays)
        habit.sortOrder = count
        modelContext.insert(habit)
        try modelContext.save()
        return habit
    }

    func deleteHabit(_ habit: Habit) throws {
        modelContext.delete(habit)
        try modelContext.save()
    }

    func popHabit(_ habit: Habit) throws -> (xp: Int, leveledUp: Bool) {
        let profile = try fetchUserProfile()
        let completion = Completion(date: Date())
        let xp = GamificationService.shared.calculateXP(for: habit, profile: profile)
        completion.xpEarned = xp
        completion.habit = habit
        habit.completions.append(completion)
        profile.totalXP += xp
        profile.lastPopDate = Date()
        let oldLevel = profile.currentLevel
        profile.currentLevel = GamificationService.shared.levelForXP(profile.totalXP)
        let leveledUp = profile.currentLevel > oldLevel
        try modelContext.save()
        return (xp, leveledUp)
    }

    func unpopHabit(_ habit: Habit, on date: Date = Date()) throws {
        if let completion = habit.completions.first(where: { $0.date.isSameDay(as: date) }) {
            let profile = try fetchUserProfile()
            profile.totalXP = max(0, profile.totalXP - completion.xpEarned)
            profile.currentLevel = GamificationService.shared.levelForXP(profile.totalXP)
            modelContext.delete(completion)
            try modelContext.save()
        }
    }

    func reorderHabits(_ habits: [Habit]) throws {
        for (index, habit) in habits.enumerated() {
            habit.sortOrder = index
        }
        try modelContext.save()
    }
}
