import SwiftUI

struct HabitCardView: View {
    let habit: Habit
    let isPopped: Bool
    let xpEarned: Int
    let onPop: () -> Void
    let onUnpop: () -> Void

    @State private var popScale: CGFloat = 1.0
    @State private var showCheckmark = false
    @State private var showParticles = false
    @State private var showXPFloat = false

    private var habitColor: Color {
        Color(hex: habit.colorHex)
    }

    var body: some View {
        HStack(spacing: 14) {
            VStack(alignment: .leading, spacing: 6) {
                HStack(spacing: 8) {
                    Image(systemName: habit.icon)
                        .foregroundStyle(habitColor)
                        .font(.system(.body))

                    Text(habit.name)
                        .font(.system(.headline, design: .default, weight: .semibold))
                        .foregroundStyle(Color.textPrimary)

                    Spacer()
                }

                HStack(spacing: 12) {
                    CompletionRateRingView(rate: habit.completionRate7Day, size: 32, lineWidth: 3)

                    VStack(alignment: .leading, spacing: 2) {
                        Text(habit.grade.emoji + " " + habit.grade.rawValue)
                            .font(.system(.caption, design: .monospaced, weight: .medium))
                            .foregroundStyle(Color(hex: habit.grade.color))

                        HStack(spacing: 4) {
                            Image(systemName: habit.trend.systemName)
                                .font(.system(.caption2))
                                .foregroundStyle(Color(hex: habit.trend.colorHex))

                            Text(habit.trend.displayName)
                                .font(.system(.caption2))
                                .foregroundStyle(Color(hex: habit.trend.colorHex))
                        }
                    }
                }
            }

            Spacer()

            ZStack {
                if habit.isCompleted() {
                    Button {
                        onUnpop()
                    } label: {
                        Image(systemName: "checkmark.circle.fill")
                            .font(.system(size: 44))
                            .foregroundStyle(Color.popGreen)
                    }
                } else {
                    Button {
                        performPop()
                    } label: {
                        Text("POP")
                            .font(.system(.callout, design: .rounded, weight: .bold))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 16)
                            .padding(.vertical, 10)
                            .background(habitColor, in: Capsule())
                    }
                    .scaleEffect(popScale)
                }

                if showXPFloat {
                    Text("+\(xpEarned) XP")
                        .font(.system(.caption, design: .rounded, weight: .heavy))
                        .foregroundStyle(Color.xpGold)
                        .offset(y: -40)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
        .overlay {
            if showParticles {
                ForEach(0..<6, id: \.self) { i in
                    ParticleView(index: i, color: habitColor)
                }
            }
        }
        .accessibilityElement(children: .combine)
        .accessibilityLabel("Pop \(habit.name), completion rate \(Int(habit.completionRate7Day * 100))%")
        .accessibilityAddTraits(.isButton)
    }

    private func performPop() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
            popScale = 1.3
        }
        withAnimation(.easeOut(duration: 0.5)) {
            showParticles = true
        }
        withAnimation(.easeOut(duration: 0.6)) {
            showXPFloat = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.15) {
            onPop()
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                popScale = 1.0
            }
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showParticles = false
            showXPFloat = false
        }
    }
}

struct ParticleView: View {
    let index: Int
    let color: Color

    @State private var offset: CGSize = .zero
    @State private var opacity: Double = 1.0

    var body: some View {
        Circle()
            .fill(color.opacity(0.8))
            .frame(width: 6, height: 6)
            .offset(offset)
            .opacity(opacity)
            .onAppear {
                let angle = Double(index) * .pi / 3
                withAnimation(.easeOut(duration: 0.5)) {
                    offset = CGSize(
                        width: cos(angle) * 35,
                        height: sin(angle) * 35
                    )
                    opacity = 0
                }
            }
    }
}
