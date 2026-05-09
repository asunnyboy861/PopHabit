import SwiftUI

struct OnboardingCompleteView: View {
    let onDone: () -> Void

    var body: some View {
        VStack(spacing: 32) {
            Spacer()

            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundStyle(Color.popGreen)

            Text("You're all set!")
                .font(.system(.largeTitle, design: .rounded, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text("Tap POP on each habit to track your progress.\nNo streaks to break — just pop and grow!")
                .font(.system(.body, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)

            Spacer()

            Button("Let's Go!") {
                onDone()
            }
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.popGreen, in: RoundedRectangle(cornerRadius: 16))
            .padding(.horizontal)

            Spacer().frame(height: 20)
        }
        .background(Color.black)
    }
}
