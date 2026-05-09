import SwiftUI

struct StatsView: View {
    @State private var viewModel = StatsViewModel()

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 20) {
                    periodPicker

                    overallCard

                    if viewModel.habitsNeedingLove.isEmpty == false {
                        needsLoveSection
                    }

                    heatmapSection

                    habitsBreakdown
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("Stats")
            .onAppear {
                viewModel.loadStats()
            }
        }
    }

    private var periodPicker: some View {
        Picker("Period", selection: $viewModel.selectedPeriod) {
            ForEach(StatsViewModel.StatsPeriod.allCases, id: \.self) { period in
                Text(period.rawValue).tag(period)
            }
        }
        .pickerStyle(.segmented)
    }

    private var overallCard: some View {
        VStack(spacing: 16) {
            CompletionRateRingView(rate: viewModel.overallCompletionRate, size: 100, lineWidth: 10)

            Text(viewModel.overallGrade.emoji + " " + viewModel.overallGrade.rawValue)
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color(hex: viewModel.overallGrade.color))

            HStack(spacing: 24) {
                VStack(spacing: 4) {
                    Text("\(viewModel.totalPops)")
                        .font(.system(.title3, design: .rounded, weight: .bold))
                        .foregroundStyle(Color.textPrimary)
                    Text("Total Pops")
                        .font(.system(.caption))
                        .foregroundStyle(Color.textSecondary)
                }

                if let best = viewModel.bestHabit {
                    VStack(spacing: 4) {
                        Text(best.name)
                            .font(.system(.caption, design: .rounded, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)
                            .lineLimit(1)
                        Text("Best Habit")
                            .font(.system(.caption))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
        .padding()
        .frame(maxWidth: .infinity)
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var needsLoveSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Needs Love")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.needsLovePink)

            ForEach(viewModel.habitsNeedingLove) { habit in
                HStack {
                    Image(systemName: habit.icon)
                        .foregroundStyle(Color(hex: habit.colorHex))
                    Text(habit.name)
                        .font(.system(.subheadline))
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("\(Int(habit.completionRate7Day * 100))%")
                        .font(.system(.caption, design: .monospaced))
                        .foregroundStyle(Color.needsLovePink)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var heatmapSection: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Completion Heatmap")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            let columns = viewModel.selectedPeriod == .week ? 7 : 7
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 4), count: columns), spacing: 4) {
                ForEach(viewModel.heatmapData, id: \.date) { day in
                    RoundedRectangle(cornerRadius: 4)
                        .fill(heatmapColor(for: day.rate))
                        .frame(height: viewModel.selectedPeriod == .week ? 40 : 20)
                        .overlay {
                            if viewModel.selectedPeriod == .week {
                                VStack(spacing: 2) {
                                    Text(day.date.weekdaySymbol)
                                        .font(.system(.caption2, weight: .medium))
                                        .foregroundStyle(Color.textSecondary)
                                    Text("\(Int(day.rate * 100))%")
                                        .font(.system(.caption2, design: .monospaced))
                                        .foregroundStyle(Color.textPrimary)
                                }
                            }
                        }
                }
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var habitsBreakdown: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("Habit Breakdown")
                .font(.system(.headline, design: .rounded))
                .foregroundStyle(Color.textPrimary)

            ForEach(viewModel.habits) { habit in
                HStack(spacing: 12) {
                    Image(systemName: habit.icon)
                        .foregroundStyle(Color(hex: habit.colorHex))
                        .frame(width: 24)

                    VStack(alignment: .leading, spacing: 4) {
                        Text(habit.name)
                            .font(.system(.subheadline, weight: .medium))
                            .foregroundStyle(Color.textPrimary)

                        ProgressBarView(progress: habit.completionRate7Day, color: Color(hex: habit.colorHex), height: 4)
                    }

                    Text("\(Int(habit.completionRate7Day * 100))%")
                        .font(.system(.caption, design: .monospaced, weight: .medium))
                        .foregroundStyle(Color.textSecondary)
                        .frame(width: 40, alignment: .trailing)
                }
                .padding(.vertical, 4)
            }
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private func heatmapColor(for rate: Double) -> Color {
        switch rate {
        case 0: Color.white.opacity(0.05)
        case 0..<0.25: Color.popGreen.opacity(0.2)
        case 0.25..<0.5: Color.popGreen.opacity(0.4)
        case 0.5..<0.75: Color.popGreen.opacity(0.6)
        case 0.75..<1.0: Color.popGreen.opacity(0.8)
        default: Color.popGreen
        }
    }
}
