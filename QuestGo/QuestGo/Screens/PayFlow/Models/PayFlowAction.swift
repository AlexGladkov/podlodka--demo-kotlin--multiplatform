//
//  PayFlowAction.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

enum PayFlowAction {
    // @param isSuccessPromo
    // @param isNeedsToPay
    case closeWithResult(Bool, Bool)

    // @param error message
    case showError(String)
}
