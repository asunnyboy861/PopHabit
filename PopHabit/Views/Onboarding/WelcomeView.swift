import SwiftUI

struct WelcomeView: View {
    let onContinue: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "bubble.left.and.bubble.right.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.primaryBlue)

            Text("PopHabit")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text("Pop your habits!\nNo streaks. No guilt. Just progress.")
                .font(.system(.title3, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            VStack(spacing: 16) {
                FeatureRow(icon: "hand.tap.fill", text: "One-tap POP interaction", color: .popGreen)
                FeatureRow(icon: "chart.pie.fill", text: "Zero-guilt completion rate", color: .primaryBlue)
                FeatureRow(icon: "star.fill", text: "XP rewards, never penalties", color: .xpGold)
            }
            .padding(.horizontal)

            Spacer()

            Button("Get Started") {
                onContinue()
            }
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primaryBlue, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            Spacer().frame(height: 20)
        }
        .background(Color.black)
    }
}

struct FeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)

            Text(text)
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            Spacer()
        }
    }
}
