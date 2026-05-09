import Foundation

extension UserDefaults {
    private enum Keys {
        static let hasCompletedOnboarding = "hasCompletedOnboarding"
        static let soundEnabled = "soundEnabled"
        static let hapticEnabled = "hapticEnabled"
        static let reminderEnabled = "reminderEnabled"
        static let reminderTime = "reminderTime"
        static let isProUser = "isProUser"
        static let freeTrialUsed = "freeTrialUsed"
        static let totalXP = "totalXP"
        static let currentLevel = "currentLevel"
        static let launchCount = "launchCount"
    }

    var hasCompletedOnboarding: Bool {
        get { bool(forKey: Keys.hasCompletedOnboarding) }
        set { set(newValue, forKey: Keys.hasCompletedOnboarding) }
    }

    var soundEnabled: Bool {
        get { object(forKey: Keys.soundEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.soundEnabled) }
    }

    var hapticEnabled: Bool {
        get { object(forKey: Keys.hapticEnabled) as? Bool ?? true }
        set { set(newValue, forKey: Keys.hapticEnabled) }
    }

    var reminderEnabled: Bool {
        get { object(forKey: Keys.reminderEnabled) as? Bool ?? false }
        set { set(newValue, forKey: Keys.reminderEnabled) }
    }

    var reminderTime: Date {
        get { object(forKey: Keys.reminderTime) as? Date ?? Calendar.current.date(bySettingHour: 9, minute: 0, second: 0, of: Date())! }
        set { set(newValue, forKey: Keys.reminderTime) }
    }

    var isProUser: Bool {
        get { bool(forKey: Keys.isProUser) }
        set { set(newValue, forKey: Keys.isProUser) }
    }

    var freeTrialUsed: Bool {
        get { bool(forKey: Keys.freeTrialUsed) }
        set { set(newValue, forKey: Keys.freeTrialUsed) }
    }

    var totalXP: Int {
        get { integer(forKey: Keys.totalXP) }
        set { set(newValue, forKey: Keys.totalXP) }
    }

    var currentLevel: Int {
        get { integer(forKey: Keys.currentLevel) }
        set { set(newValue, forKey: Keys.currentLevel) }
    }

    var launchCount: Int {
        get { integer(forKey: Keys.launchCount) }
        set { set(newValue, forKey: Keys.launchCount) }
    }
}
