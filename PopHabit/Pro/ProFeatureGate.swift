import Foundation

@Observable
final class ProFeatureGate {
    static let shared = ProFeatureGate()

    var isPro: Bool {
        UserDefaults.standard.isProUser || PurchaseManager.shared.isProUser
    }

    private init() {}

    func canAddHabit(currentCount: Int) -> Bool {
        currentCount < 5 || isPro
    }

    func canUseWidget() -> Bool {
        isPro
    }

    func canUseCloudSync() -> Bool {
        isPro
    }

    func canUseAppleWatch() -> Bool {
        isPro
    }

    func canUseLiveActivity() -> Bool {
        isPro
    }

    func canUseAdvancedStats() -> Bool {
        isPro
    }

    func canUseDataExport() -> Bool {
        isPro
    }

    func canUseCustomSounds() -> Bool {
        isPro
    }

    func canUseUnlimitedReminders() -> Bool {
        isPro
    }

    func canUseAllTemplates() -> Bool {
        isPro
    }
}
