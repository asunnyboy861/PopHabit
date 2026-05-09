import SwiftUI
import SwiftData

@main
struct PopHabitApp: App {
    @AppStorage("hasCompletedOnboarding") private var hasCompletedOnboarding = false
    @State private var showOnboarding = false

    var sharedModelContainer: ModelContainer = DataController.shared.modelContainer

    var body: some Scene {
        WindowGroup {
            Group {
                if hasCompletedOnboarding {
                    MainTabView()
                } else {
                    OnboardingContainerView(onComplete: {
                        hasCompletedOnboarding = true
                    })
                }
            }
            .modelContainer(sharedModelContainer)
            .preferredColorScheme(.dark)
            .onAppear {
                UserDefaults.standard.launchCount += 1
            }
        }
    }
}

struct MainTabView: View {
    @State private var selectedTab = 0

    var body: some View {
        TabView(selection: $selectedTab) {
            Tab("Today", systemImage: "bubble.left.fill", value: 0) {
                TodayView()
            }

            Tab("Stats", systemImage: "chart.pie.fill", value: 1) {
                StatsView()
            }

            Tab("Settings", systemImage: "gearshape.fill", value: 2) {
                SettingsView()
            }
        }
        .tint(Color.primaryBlue)
    }
}

struct OnboardingContainerView: View {
    @State private var step = 0
    let onComplete: () -> Void

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            switch step {
            case 0:
                WelcomeView {
                    withAnimation { step = 1 }
                }
            case 1:
                HabitPickerView {
                    withAnimation { step = 2 }
                }
            case 2:
                OnboardingCompleteView {
                    onComplete()
                }
            default:
                WelcomeView {
                    withAnimation { step = 1 }
                }
            }
        }
    }
}
