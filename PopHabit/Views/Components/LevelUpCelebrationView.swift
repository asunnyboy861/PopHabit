import SwiftUI

struct LevelUpCelebrationView: View {
    let level: Int
    @Binding var isPresented: Bool

    @State private var showContent = false

    var body: some View {
        if isPresented {
            ZStack {
                Color.black.opacity(0.7)
                    .ignoresSafeArea()
                    .onTapGesture {
                        dismiss()
                    }

                VStack(spacing: 20) {
                    Text("LEVEL UP!")
                        .font(.system(.largeTitle, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.xpGold)

                    Text("\(level)")
                        .font(.system(size: 72, weight: .heavy, design: .rounded))
                        .foregroundStyle(Color.levelPurple)
                        .scaleEffect(showContent ? 1.0 : 0.1)

                    Text(GamificationService.shared.levelTitle(for: level))
                        .font(.system(.title3, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color.textSecondary)

                    Button("Awesome!") {
                        dismiss()
                    }
                    .font(.system(.headline, design: .rounded))
                    .foregroundStyle(.white)
                    .padding(.horizontal, 40)
                    .padding(.vertical, 12)
                    .background(Color.levelPurple, in: Capsule())
                }
                .padding(40)
                .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 24))
                .scaleEffect(showContent ? 1.0 : 0.5)
                .opacity(showContent ? 1 : 0)
            }
            .onAppear {
                withAnimation(.spring(response: 0.5, dampingFraction: 0.6)) {
                    showContent = true
                }
            }
        }
    }

    private func dismiss() {
        withAnimation(.easeOut(duration: 0.3)) {
            showContent = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            isPresented = false
        }
    }
}
