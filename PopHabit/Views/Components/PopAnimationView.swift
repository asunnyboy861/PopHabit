import SwiftUI

struct PopAnimationView: View {
    let isPopped: Bool
    let xpEarned: Int
    let habitColor: Color

    @State private var scale: CGFloat = 1.0
    @State private var showParticles = false
    @State private var showXP = false
    @State private var particleOffsets: [CGSize] = Array(repeating: .zero, count: 8)
    @State private var particleOpacities: [Double] = Array(repeating: 1.0, count: 8)

    var body: some View {
        ZStack {
            if showParticles {
                ForEach(0..<8, id: \.self) { i in
                    Circle()
                        .fill(habitColor.opacity(0.8))
                        .frame(width: 8, height: 8)
                        .offset(particleOffsets[i])
                        .opacity(particleOpacities[i])
                }
            }

            if showXP {
                Text("+\(xpEarned) XP")
                    .font(.system(.caption, design: .rounded, weight: .heavy))
                    .foregroundStyle(Color.xpGold)
                    .offset(y: -30)
                    .transition(.move(edge: .bottom).combined(with: .opacity))
            }
        }
        .onChange(of: isPopped) { _, newValue in
            if newValue {
                triggerPop()
            }
        }
    }

    private func triggerPop() {
        withAnimation(.spring(response: 0.3, dampingFraction: 0.4)) {
            scale = 1.3
        }
        withAnimation(.easeOut(duration: 0.5)) {
            showParticles = true
            for i in 0..<8 {
                let angle = Double(i) * .pi / 4
                particleOffsets[i] = CGSize(
                    width: cos(angle) * 40,
                    height: sin(angle) * 40
                )
                particleOpacities[i] = 0
            }
        }
        withAnimation(.easeOut(duration: 0.6)) {
            showXP = true
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                scale = 1.0
            }
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            showParticles = false
            showXP = false
            for i in 0..<8 {
                particleOffsets[i] = .zero
                particleOpacities[i] = 1.0
            }
        }
    }
}
