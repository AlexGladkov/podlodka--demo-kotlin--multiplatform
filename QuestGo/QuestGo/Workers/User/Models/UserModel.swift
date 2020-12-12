//
//  UserModel.swift
//  QuestGo
//
//  Created by Алексей Гладков on 13.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

struct User {
    struct Quest {}
}

extension User.Quest {
    struct Buy: Codable {
        let questId: Int
    }
}
