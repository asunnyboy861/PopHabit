import SwiftUI

struct LevelBadgeView: View {
    let level: Int

    var body: some View {
        ZStack {
            Circle()
                .fill(Color.levelPurple.opacity(0.2))
                .frame(width: 28, height: 28)

            Image(systemName: "star.fill")
                .font(.system(.caption))
                .foregroundStyle(Color.levelPurple)
        }
    }
}
