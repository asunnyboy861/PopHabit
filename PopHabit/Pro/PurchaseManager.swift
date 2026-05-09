import Foundation
import StoreKit

@Observable
@MainActor
final class PurchaseManager {
    static let shared = PurchaseManager()

    var products: [Product] = []
    var purchasedProductIDs: Set<String> = []
    var isProUser: Bool = false
    var isLoading = false

    private var transactionListener: Task<Void, Never>?

    private let productIDs = [
        "com.zzoutuo.PopHabit.monthly",
        "com.zzoutuo.PopHabit.yearly",
        "com.zzoutuo.PopHabit.lifetime"
    ]

    var monthlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.PopHabit.monthly" }
    }

    var yearlyProduct: Product? {
        products.first { $0.id == "com.zzoutuo.PopHabit.yearly" }
    }

    var lifetimeProduct: Product? {
        products.first { $0.id == "com.zzoutuo.PopHabit.lifetime" }
    }

    private init() {
        transactionListener = listenForTransactions()
    }

    func loadProducts() async {
        isLoading = true
        do {
            let storeProducts = try await Product.products(for: productIDs)
            products = storeProducts.sorted { $0.price < $1.price }
        } catch {}
        await updatePurchasedProducts()
        isLoading = false
    }

    func purchase(_ product: Product) async -> Bool {
        do {
            let result = try await product.purchase()
            switch result {
            case .success(let verification):
                let transaction = try Self.checkVerified(verification)
                await updatePurchasedProducts()
                await transaction.finish()
                return true
            case .userCancelled:
                return false
            case .pending:
                return false
            @unknown default:
                return false
            }
        } catch {
            return false
        }
    }

    func restorePurchases() async {
        do {
            try await AppStore.sync()
        } catch {}
        await updatePurchasedProducts()
    }

    private func listenForTransactions() -> Task<Void, Never> {
        Task { [weak self] in
            for await result in Transaction.updates {
                guard let self else { return }
                do {
                    let transaction = try Self.checkVerified(result)
                    await self.updatePurchasedProducts()
                    await transaction.finish()
                } catch {}
            }
        }
    }

    private static func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified:
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }

    private func updatePurchasedProducts() async {
        var purchasedIDs: Set<String> = []
        for productID in productIDs {
            if await isPurchased(productID) {
                purchasedIDs.insert(productID)
            }
        }
        purchasedProductIDs = purchasedIDs
        isProUser = !purchasedProductIDs.isEmpty
        UserDefaults.standard.isProUser = isProUser
    }

    private func isPurchased(_ productID: String) async -> Bool {
        guard let result = await Transaction.currentEntitlement(for: productID) else {
            return false
        }
        do {
            let transaction = try Self.checkVerified(result)
            return transaction.revocationDate == nil
        } catch {
            return false
        }
    }

    enum StoreError: Error {
        case failedVerification
    }
}
