import SwiftUI

struct SettingsView: View {
    @State private var soundEnabled = UserDefaults.standard.soundEnabled
    @State private var hapticEnabled = UserDefaults.standard.hapticEnabled
    @State private var purchaseManager = PurchaseManager.shared
    @State private var showProUpgrade = false

    private let githubUser = "asunnyboy861"
    private let appName = "PopHabit"

    var body: some View {
        NavigationStack {
            List {
                proSection

                preferencesSection

                supportSection

                legalSection

                aboutSection
            }
            .scrollContentBackground(.hidden)
            .background(Color.black)
            .navigationTitle("Settings")
            .sheet(isPresented: $showProUpgrade) {
                ProUpgradeView()
            }
            .onChange(of: soundEnabled) { _, newValue in
                UserDefaults.standard.soundEnabled = newValue
            }
            .onChange(of: hapticEnabled) { _, newValue in
                UserDefaults.standard.hapticEnabled = newValue
            }
        }
    }

    private var proSection: some View {
        Section {
            if purchaseManager.isProUser {
                HStack {
                    Image(systemName: "crown.fill")
                        .foregroundStyle(Color.xpGold)
                    Text("PopHabit Pro")
                        .foregroundStyle(Color.textPrimary)
                    Spacer()
                    Text("Active")
                        .font(.system(.caption, weight: .medium))
                        .foregroundStyle(Color.popGreen)
                }
            } else {
                Button {
                    showProUpgrade = true
                } label: {
                    HStack {
                        Image(systemName: "crown")
                            .foregroundStyle(Color.xpGold)
                        Text("Upgrade to Pro")
                            .foregroundStyle(Color.textPrimary)
                        Spacer()
                        Image(systemName: "chevron.right")
                            .font(.system(.caption))
                            .foregroundStyle(Color.textSecondary)
                    }
                }
            }
        }
        .listRowBackground(Color.white.opacity(0.05))
    }

    private var preferencesSection: some View {
        Section("Preferences") {
            Toggle(isOn: $soundEnabled) {
                Label("Sound Effects", systemImage: "speaker.wave.2.fill")
            }
            .tint(Color.primaryBlue)

            Toggle(isOn: $hapticEnabled) {
                Label("Haptic Feedback", systemImage: "hand.tap.fill")
            }
            .tint(Color.primaryBlue)
        }
        .listRowBackground(Color.white.opacity(0.05))
    }

    private var supportSection: some View {
        Section("Support") {
            NavigationLink {
                ContactSupportView()
            } label: {
                Label("Contact Support", systemImage: "envelope.fill")
            }

            if !purchaseManager.isProUser {
                Button {
                    Task {
                        await purchaseManager.restorePurchases()
                    }
                } label: {
                    Label("Restore Purchases", systemImage: "arrow.uturn.backward")
                }
            }
        }
        .listRowBackground(Color.white.opacity(0.05))
    }

    private var legalSection: some View {
        Section("Legal") {
            Link(destination: URL(string: "https://\(githubUser).github.io/\(appName)/support.html")!) {
                Label("Support Page", systemImage: "questionmark.circle")
            }

            Link(destination: URL(string: "https://\(githubUser).github.io/\(appName)/privacy.html")!) {
                Label("Privacy Policy", systemImage: "hand.raised.fill")
            }

            Link(destination: URL(string: "https://\(githubUser).github.io/\(appName)/terms.html")!) {
                Label("Terms of Use", systemImage: "doc.text.fill")
            }
        }
        .listRowBackground(Color.white.opacity(0.05))
    }

    private var aboutSection: some View {
        Section("About") {
            HStack {
                Text("Version")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0")
                    .foregroundStyle(Color.textSecondary)
            }

            HStack {
                Text("Build")
                Spacer()
                Text(Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? "1")
                    .foregroundStyle(Color.textSecondary)
            }
        }
        .listRowBackground(Color.white.opacity(0.05))
    }
}
