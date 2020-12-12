//
//  PurchaseAnalytics.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class PurchaseAnalytics {

    func purchaseSucceed(questId: Int) {
        Analytics.logEvent("main_purchase_success_bought",
                           parameters: [
                            "questId": questId
                           ])
    }

    func purchaseCanceled(questId: Int) {
        Analytics.logEvent("main_purchase_canceled",
                           parameters: [
                            "questId": questId
                           ])
    }

    func purchaseError(questId: Int, message: String) {
        Analytics.logEvent("main_purchase_canceled",
                           parameters: [
                            "questId": questId,
                            "message": message
                           ])
    }
}
