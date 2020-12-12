//
//  StoryPageEvent.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

enum StoryPageEvent {
    case fetchInitial
    case sendAnswer(String)
    case nextPage
}
