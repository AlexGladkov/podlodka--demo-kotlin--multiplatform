//
//  QuestListAnalytics.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class QuestListAnalytics {

    func listLoaded(questCount: Int) {
        Analytics.logEvent("main_list_page_loaded", parameters: [
            "questCount": questCount
        ])
    }

    func listError(message: String) {
        Analytics.logEvent("main_error_list_page_loaded", parameters: [
            "message": message
        ])
    }
}
