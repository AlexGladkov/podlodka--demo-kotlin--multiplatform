//
//  Configuration.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

struct UserConfiguration: Codable {
    let currentUserPage: Int
    let currentQuestId: Int
    let availableQuestCount: Int
    let boughtQuestIdsList: [Int]
}
