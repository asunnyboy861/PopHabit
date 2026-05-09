import Foundation
import UserNotifications

@Observable
final class NotificationService {
    static let shared = NotificationService()

    private init() {}

    func requestPermission() async -> Bool {
        do {
            return try await UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound])
        } catch {
            return false
        }
    }

    func scheduleReminder(for habit: Habit) async {
        guard habit.reminderEnabled else { return }
        let content = UNMutableNotificationContent()
        content.title = "PopHabit"
        content.body = "Time to pop \(habit.name)! You're doing great! 🎯"
        content.sound = .default
        let dateComponents = Calendar.current.dateComponents([.hour, .minute], from: habit.reminderTime)
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "habit-\(habit.id.uuidString)", content: content, trigger: trigger)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {}
    }

    func cancelReminder(for habit: Habit) {
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: ["habit-\(habit.id.uuidString)"])
    }

    func scheduleDailySummary(habits: [Habit]) async {
        let content = UNMutableNotificationContent()
        let remaining = habits.filter { !$0.isCompleted() }.count
        if remaining == 0 {
            content.body = "All habits popped! Amazing day! 🎉"
        } else {
            content.body = "\(remaining) habit\(remaining == 1 ? "" : "s") left to pop today! You got this! 💪"
        }
        content.title = "PopHabit"
        content.sound = .default
        var dateComponents = DateComponents()
        dateComponents.hour = 21
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
        let request = UNNotificationRequest(identifier: "daily-summary", content: content, trigger: trigger)
        do {
            try await UNUserNotificationCenter.current().add(request)
        } catch {}
    }
}
