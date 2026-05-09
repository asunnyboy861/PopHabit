import UIKit

@Observable
final class HapticManager {
    static let shared = HapticManager()

    private init() {}

    func pop() {
        guard UserDefaults.standard.hapticEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .light)
        generator.impactOccurred()
    }

    func levelUp() {
        guard UserDefaults.standard.hapticEnabled else { return }
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }

    func achievement() {
        guard UserDefaults.standard.hapticEnabled else { return }
        let generator = UIImpactFeedbackGenerator(style: .heavy)
        generator.impactOccurred()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            let gen2 = UIImpactFeedbackGenerator(style: .medium)
            gen2.impactOccurred()
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            let gen3 = UIImpactFeedbackGenerator(style: .light)
            gen3.impactOccurred()
        }
    }
}
