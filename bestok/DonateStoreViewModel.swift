//
//  DonateStoreViewModel].swift
//  bestok
//
//  Created by Firas Rafislam on 09/01/2024.
//

import Foundation
import StoreKit

public enum StoreError: Error {
    case failedVerification
}

@MainActor
class DonateStoreViewModel: ObservableObject {
    
    @Published private(set) var donations: [Product] = []
    
    init() {
        
        Task {
            await requestProducts()
        }
    }
    
    func purchase(_ product: Product) async throws -> Transaction? {
        let result = try await product.purchase()
        
        switch result {
        case .success(let verification):
            let transaction = try checkVerified(verification)
            
            await transaction.finish()
            
            return transaction
        case .userCancelled, .pending:
            return nil
        default:
            return nil
        }
    }
    
    func checkVerified<T>(_ result: VerificationResult<T>) throws -> T {
        switch result {
        case .unverified(_, _):
            throw StoreError.failedVerification
        case .verified(let safe):
            return safe
        }
    }
    
    func requestProducts() async {
        do {
            
            let storeProducts = try await Product.products(for: ["gorgeoustip", "insanetip", "thankstip"])
            
            donations.append(contentsOf: storeProducts)
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }
}
