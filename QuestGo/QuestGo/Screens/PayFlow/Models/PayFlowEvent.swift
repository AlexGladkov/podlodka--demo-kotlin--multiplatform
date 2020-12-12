//
//  PayFlowEvent.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

enum PayFlowEvent {
    case screenShown
    case buyQuest
    case sendPromo(String)
    case promoCodeTapped
    case restoreProducts
}
