//
//  DonateStoreViewModel].swift
//  bestok
//
//  Created by Firas Rafislam on 09/01/2024.
//

import Foundation
import StoreKit
import SwiftUI

public enum StoreError: Error {
    case failedVerification
}

@MainActor
class DonateStoreViewModel: ObservableObject {
    
    @Published private(set) var donations: [Product] = []
    
    enum ProductState {
        case loading, store(products: [Product]), error
    }
    
    @Published var state: ProductState = .loading
    
    init() {
        
        Task {
            await requestProducts()
        }
    }
    
    #if os(iOS)
    func purchase(_ product: Product) async throws -> StoreKit.Transaction? {
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
    #endif
    
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
            state = .loading
            let storeProducts = try await Product.products(for: ["gorgeoustip", "insanetip", "thankstip"])
            
            donations.append(contentsOf: storeProducts)
            
            withAnimation {
                state = .store(products: donations)
            }
        } catch {
            print("Failed product request from the App Store server: \(error)")
        }
    }
}
