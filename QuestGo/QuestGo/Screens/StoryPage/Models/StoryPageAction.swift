//
//  StoryPageAction.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

enum StoryPageAction {
    case openNextPage(Int)
    case showError(String)
    case showPayFlow
    case openFinalPage
    case openPayPage
    case openWrongAnswer
}
