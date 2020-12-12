//
//  QuestCellModel.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

struct QuestCellModel {
    let questId: String
    let title: String
    let subtitle: String
    let image: URL?
    let description: [QuestModel.QuestComponent]
}
