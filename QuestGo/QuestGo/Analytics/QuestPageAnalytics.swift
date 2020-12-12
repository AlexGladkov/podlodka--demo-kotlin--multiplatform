//
//  QuestPageAnalytics.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import FirebaseAnalytics

class QuestPageAnalytics {

    func pageLoaded(questId: Int, questPage: Int) {
        Analytics.logEvent("main_page_loaded", parameters: [
            "questId" : questId,
            "questPage": questPage
        ])
    }

    func infoLoaded(questId: Int, questPage: Int) {
        Analytics.logEvent("main_info_loaded", parameters: [
            "questId": questId,
            "questPage": questPage
        ])
    }

    func answerSend(questId: Int, questPage: Int, code: String, correct: Bool) {
        Analytics.logEvent("main_page_code", parameters: [
            "questId": questId,
            "questPage": questPage,
            "code": code,
            "correct": correct
        ])
    }
}
