//
//  IAPManager.swift
//  QuestGo
//
//  Created by Алексей Гладков on 11.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import StoreKit

class IAPManager: NSObject {

    enum IAPManagerError: Error {
        case noProductIDsFound
        case noProductsFound
        case paymentWasCancelled
        case productRequestFailed
    }

    static let shared = IAPManager()

    var onReceiveProductsHandler: ((Result<[SKProduct], IAPManagerError>) -> Void)?
    var onBuyProductHandler: ((Result<Bool, Error>) -> Void)?

    private override init() {
        super.init()
    }

    func getProducts(handler: @escaping (_ result: Result<[SKProduct], IAPManagerError>) -> Void) {
        // Get the product identifiers.
        guard let productIDs = getProductIDs() else {
            handler(.failure(.noProductIDsFound))
            return
        }

        onReceiveProductsHandler = handler

        // Initialize a product request.
        let request = SKProductsRequest(productIdentifiers: Set(productIDs))

        // Set self as the its delegate.
        request.delegate = self

        // Make the request.
        request.start()
    }

    func canMakePayments() -> Bool {
        return SKPaymentQueue.canMakePayments()
    }

    func startObserving() {
        SKPaymentQueue.default().add(self)
    }


    func stopObserving() {
        SKPaymentQueue.default().remove(self)
    }

    func buy(product: SKProduct, withHandler handler: @escaping ((_ result: Result<Bool, Error>) -> Void)) {
        let payment = SKPayment(product: product)
        SKPaymentQueue.default().add(payment)

        // Keep the completion handler.
        onBuyProductHandler = handler
    }

    private func getProductIDs() -> [String]? {
        return ["quest_buy_once"]
    }
}

extension IAPManager: SKProductsRequestDelegate {

    func productsRequest(_ request: SKProductsRequest, didReceive response: SKProductsResponse) {
        // Get the available products contained in the response.
        let products = response.products

        // Check if there are any products available.
        if products.count > 0 {
            // Call the following handler passing the received products.
            onReceiveProductsHandler?(.success(products))
        } else {
            // No products were found.
            onReceiveProductsHandler?(.failure(.noProductsFound))
        }
    }

    func request(_ request: SKRequest, didFailWithError error: Error) {
        onReceiveProductsHandler?(.failure(.productRequestFailed))
    }

    func requestDidFinish(_ request: SKRequest) {
        
    }
}

extension IAPManager: SKPaymentTransactionObserver {
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        transactions.forEach { (transaction) in
            switch transaction.transactionState {
            case .purchased:
                onBuyProductHandler?(.success(true))
                SKPaymentQueue.default().finishTransaction(transaction)

            case .restored: break

            case .failed:
                if let error = transaction.error as? SKError {
                    if error.code != .paymentCancelled {
                        onBuyProductHandler?(.failure(error))
                    } else {
                        onBuyProductHandler?(.failure(IAPManagerError.paymentWasCancelled))
                    }
                    print("IAP Error:", error.localizedDescription)
                }

                SKPaymentQueue.default().finishTransaction(transaction)

            case .deferred, .purchasing: break
            @unknown default: break
            }
        }
    }
}

extension IAPManager.IAPManagerError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noProductIDsFound: return "No In-App Purchase product identifiers were found."
        case .noProductsFound: return "No In-App Purchases were found."
        case .productRequestFailed: return "Unable to fetch available In-App Purchase products at the moment."
        case .paymentWasCancelled: return "In-App Purchase process was cancelled."
        }
    }
}
