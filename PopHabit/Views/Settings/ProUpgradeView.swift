import SwiftUI
import StoreKit

struct ProUpgradeView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var purchaseManager = PurchaseManager.shared
    @State private var selectedTier: Tier = .yearly

    enum Tier: String, CaseIterable {
        case monthly
        case yearly
        case lifetime

        var displayName: String {
            switch self {
            case .monthly: "Monthly"
            case .yearly: "Yearly"
            case .lifetime: "Lifetime"
            }
        }
    }

    var body: some View {
        NavigationStack {
            ScrollView {
                VStack(spacing: 24) {
                    headerSection

                    featuresList

                    tierPicker

                    purchaseButton

                    restoreButton

                    disclaimer
                }
                .padding()
            }
            .background(Color.black)
            .navigationTitle("PopHabit Pro")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("Close") { dismiss() }
                }
            }
            .task {
                await purchaseManager.loadProducts()
            }
        }
    }

    private var headerSection: some View {
        VStack(spacing: 12) {
            Image(systemName: "crown.fill")
                .font(.system(size: 48))
                .foregroundStyle(Color.xpGold)

            Text("Unlock PopHabit Pro")
                .font(.system(.title2, design: .rounded, weight: .bold))
                .foregroundStyle(Color.textPrimary)

            Text("Unlimited habits, advanced stats, and more!")
                .font(.system(.subheadline, design: .rounded))
                .foregroundStyle(Color.textSecondary)
                .multilineTextAlignment(.center)
        }
    }

    private var featuresList: some View {
        VStack(spacing: 12) {
            ProFeatureRow(icon: "infinity", text: "Unlimited habits", color: .primaryBlue)
            ProFeatureRow(icon: "chart.bar.fill", text: "Advanced stats & achievements", color: .popGreen)
            ProFeatureRow(icon: "cloud.fill", text: "CloudKit sync across devices", color: .primaryBlue)
            ProFeatureRow(icon: "app.badge.fill", text: "Widget + Live Activity", color: .levelPurple)
            ProFeatureRow(icon: "applewatch", text: "Apple Watch app", color: .popGreen)
            ProFeatureRow(icon: "square.and.arrow.up", text: "Data export (CSV/JSON)", color: .primaryBlue)
        }
        .padding()
        .background(.ultraThinMaterial, in: RoundedRectangle(cornerRadius: 16))
    }

    private var tierPicker: some View {
        VStack(spacing: 12) {
            ForEach([Tier.yearly, Tier.monthly, Tier.lifetime], id: \.self) { tier in
                tierButton(tier)
            }
        }
    }

    private func tierButton(_ tier: Tier) -> some View {
        let product: Product? = {
            switch tier {
            case .monthly: purchaseManager.monthlyProduct
            case .yearly: purchaseManager.yearlyProduct
            case .lifetime: purchaseManager.lifetimeProduct
            }
        }()

        return Button {
            selectedTier = tier
        } label: {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Text(tier.displayName)
                            .font(.system(.subheadline, weight: .semibold))
                            .foregroundStyle(Color.textPrimary)

                        if tier == .yearly {
                            Text("Best Value")
                                    .font(.system(.caption2, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(.horizontal, 6)
                                    .padding(.vertical, 2)
                                    .background(Color.popGreen, in: Capsule())
                        }
                    }

                    if let product {
                        Text(product.displayPrice)
                            .font(.system(.caption, design: .rounded))
                            .foregroundStyle(Color.textSecondary)
                    }
                }

                Spacer()

                if selectedTier == tier {
                    Image(systemName: "checkmark.circle.fill")
                        .foregroundStyle(Color.primaryBlue)
                }
            }
            .padding()
            .background(selectedTier == tier ? Color.primaryBlue.opacity(0.15) : Color.white.opacity(0.05), in: RoundedRectangle(cornerRadius: 12))
            .overlay {
                if selectedTier == tier {
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.primaryBlue, lineWidth: 2)
                }
            }
        }
    }

    private var purchaseButton: some View {
        Button {
            Task {
                let product: Product? = {
                    switch selectedTier {
                    case .monthly: purchaseManager.monthlyProduct
                    case .yearly: purchaseManager.yearlyProduct
                    case .lifetime: purchaseManager.lifetimeProduct
                    }
                }()
                if let product {
                    let success = await purchaseManager.purchase(product)
                    if success {
                        dismiss()
                    }
                }
            }
        } label: {
            Group {
                if purchaseManager.isLoading {
                    ProgressView()
                        .tint(.white)
                } else {
                    Text("Subscribe")
                        .font(.system(.headline, design: .rounded))
                }
            }
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(Color.primaryBlue, in: RoundedRectangle(cornerRadius: 16))
        }
        .disabled(purchaseManager.isLoading)
    }

    private var restoreButton: some View {
        Button("Restore Purchases") {
            Task {
                await purchaseManager.restorePurchases()
            }
        }
        .font(.system(.subheadline, design: .rounded))
        .foregroundStyle(Color.primaryBlue)
    }

    private var disclaimer: some View {
        VStack(spacing: 4) {
            Text("Payment will be charged to your Apple ID account at confirmation of purchase.")
                .font(.system(.caption2))
                .foregroundStyle(Color.textSecondary)
            Text("Subscriptions automatically renew unless canceled at least 24 hours before the end of the current period.")
                .font(.system(.caption2))
                .foregroundStyle(Color.textSecondary)
            Text("Manage or cancel subscriptions in Settings > Apple ID > Subscriptions.")
                .font(.system(.caption2))
                .foregroundStyle(Color.textSecondary)
        }
        .multilineTextAlignment(.center)
    }
}

struct ProFeatureRow: View {
    let icon: String
    let text: String
    let color: Color

    var body: some View {
        HStack(spacing: 10) {
            Image(systemName: icon)
                .foregroundStyle(color)
                .frame(width: 24)

            Text(text)
                .font(.system(.subheadline))
                .foregroundStyle(Color.textPrimary)

            Spacer()

            Image(systemName: "checkmark")
                .font(.system(.caption, weight: .bold))
                .foregroundStyle(Color.popGreen)
        }
    }
}
