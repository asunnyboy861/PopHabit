import SwiftUI

struct TodayView: View {
    @State private var viewModel = TodayViewModel()
    @State private var showAddHabit = false

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    headerSection

                    if !viewModel.habits.isEmpty {
                        progressSection
                    }

                    habitsList

                    if viewModel.habits.isEmpty {
                        emptyState
                    }
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        if viewModel.canAddMoreHabits {
                            showAddHabit = true
                        } else {
                            viewModel.showProUpgrade = true
                        }
                    } label: {
                        Image(systemName: "plus.circle.fill")
                            .foregroundStyle(Color.primaryBlue)
                    }
                }
            }
            .sheet(isPresented: $showAddHabit) {
                AddHabitView()
            }
            .sheet(isPresented: $viewModel.showProUpgrade) {
                ProUpgradeView()
            }
            .overlay {
                if let profile = viewModel.userProfile {
                    LevelUpCelebrationView(
                        level: profile.currentLevel,
                        isPresented: $viewModel.showLevelUp
                    )
                }
            }
            .onAppear {
                viewModel.loadHabits()
            }
        }
    }

    private var headerSection: some View {
        VStack(alignment: .leading, spacing: 4) {
            Text(viewModel.greeting)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            if let profile = viewModel.userProfile {
                HStack(spacing: 8) {
                    LevelBadgeView(level: profile.currentLevel)

                    Text("Level \(profile.currentLevel)")
                        .font(.system(.subheadline, design: .rounded, weight: .semibold))
                        .foregroundStyle(Color.levelPurple)

                    Text("\(profile.totalXP) XP")
                        .font(.system(.caption, design: .rounded, weight: .medium))
                        .foregroundStyle(Color.xpGold)
                }
            }
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }

    private var progressSection: some View {
        VStack(spacing: 8) {
            HStack {
                Text("Today's Progress")
                    .font(.system(.subheadline, weight: .semibold))
                    .foregroundStyle(Color.textSecondary)

                Spacer()

                Text("\(viewModel.completedCount)/\(viewModel.totalHabits)")
                    .font(.system(.subheadline, design: .monospaced, weight: .medium))
                    .foregroundStyle(Color.textPrimary)
            }

            ProgressBarView(progress: viewModel.todayProgress)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var habitsList: some View {
        LazyVStack(spacing: 12) {
            ForEach(viewModel.habits) { habit in
                HabitCardView(
                    habit: habit,
                    isPopped: viewModel.poppedHabitId == habit.id,
                    xpEarned: viewModel.xpEarned,
                    onPop: { viewModel.popHabit(habit) },
                    onUnpop: { viewModel.unpopHabit(habit) }
                )
            }
        }
    }

    private var emptyState: some View {
        VStack(spacing: 16) {
            Image(systemName: "bubble.left.and.bubble.right")
                .font(.system(size: 48))
                .foregroundStyle(Color.primaryBlue.opacity(0.5))

            Text("No habits yet!")
                .font(.system(.title3, design: .rounded, weight: .semibold))
                .foregroundStyle(Color.textPrimary)

            Text("Tap + to add your first habit")
                .font(.system(.subheadline))
                .foregroundStyle(Color.textSecondary)

            Button("Add First Habit") {
                showAddHabit = true
            }
            .font(.system(.headline, design: .rounded))
            .foregroundStyle(.white)
            .padding(.horizontal, 24)
            .padding(.vertical, 12)
            .background(Color.primaryBlue, in: Capsule())
        }
        .padding(.vertical, 60)
    }
}
