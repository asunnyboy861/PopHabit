import SwiftUI

struct ProgressBarView: View {
    let progress: Double
    let color: Color
    let height: CGFloat

    init(progress: Double, color: Color = .popGreen, height: CGFloat = 8) {
        self.progress = progress
        self.color = color
        self.height = height
    }

    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: height / 2)
                    .fill(Color.white.opacity(0.1))
                    .frame(height: height)

                RoundedRectangle(cornerRadius: height / 2)
                    .fill(color)
                    .frame(width: max(0, geometry.size.width * min(progress, 1.0)), height: height)
                    .animation(.spring(response: 0.5, dampingFraction: 0.7), value: progress)
            }
        }
        .frame(height: height)
    }
}
