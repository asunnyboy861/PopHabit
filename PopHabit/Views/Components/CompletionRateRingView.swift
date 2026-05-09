import SwiftUI

struct CompletionRateRingView: View {
    let rate: Double
    let size: CGFloat
    let lineWidth: CGFloat
    let color: Color

    init(rate: Double, size: CGFloat = 60, lineWidth: CGFloat = 6, color: Color? = nil) {
        self.rate = rate
        self.size = size
        self.lineWidth = lineWidth
        self.color = color ?? CompletionGrade(rate: rate).ringColor
    }

    var body: some View {
        ZStack {
            Circle()
                .stroke(Color.white.opacity(0.1), lineWidth: lineWidth)

            Circle()
                .trim(from: 0, to: min(rate, 1.0))
                .stroke(color, style: StrokeStyle(lineWidth: lineWidth, lineCap: .round))
                .rotationEffect(.degrees(-90))
                .animation(.spring(response: 0.6, dampingFraction: 0.7), value: rate)

            Text("\(Int(rate * 100))%")
                .font(.system(.caption2, design: .monospaced, weight: .medium))
                .foregroundStyle(Color.textPrimary)
        }
        .frame(width: size, height: size)
    }
}
