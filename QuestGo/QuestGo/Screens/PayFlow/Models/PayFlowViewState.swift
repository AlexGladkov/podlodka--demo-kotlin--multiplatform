//
//  PayFlowViewState.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

struct PayFlowViewState {
    let renderItems: [CellConfigurator]

    init(renderItems: [CellConfigurator] = []) {
        self.renderItems = renderItems
    }
}
