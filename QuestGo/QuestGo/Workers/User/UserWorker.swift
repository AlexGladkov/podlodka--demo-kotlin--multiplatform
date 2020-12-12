//
//  UserWorker.swift
//  QuestGo
//
//  Created by Алексей Гладков on 13.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

class UserWorker {

    private let userKey = "Quests"
    private let configurationKey = "UserConfigurationKey"

    func updateConfiguration(configuration: UserConfiguration) {
        let encoder = JSONEncoder()

        if let encoded = try? encoder.encode(configuration) {
            let defaults = UserDefaults.standard
            defaults.set(encoded, forKey: configurationKey)
            defaults.synchronize()
        }
    }

    func readConfiguration() -> UserConfiguration {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: configurationKey) as? Data {
            let decoder = JSONDecoder()
            if let savedQuest = try? decoder.decode(UserConfiguration.self, from: savedData) {
                return savedQuest
            }
        }

        return UserConfiguration(currentUserPage: -1, currentQuestId: -1, availableQuestCount: 0, boughtQuestIdsList: [])
    }

    func save(request: User.Quest.Buy) {
        let encoder = JSONEncoder()

        if let quests = load() {
            if quests.contains(where: { $0.questId == request.questId }) == false {
                var data = [User.Quest.Buy]()
                data.append(contentsOf: quests)
                data.append(request)

                if let encoded = try? encoder.encode(data) {
                    let defaults = UserDefaults.standard
                    defaults.set(encoded, forKey: userKey)
                    defaults.synchronize()
                }
            }
        } else {
            if let encoded = try? encoder.encode([request]) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: userKey)
                defaults.synchronize()
            }
        }
    }

    func load() -> [User.Quest.Buy]? {
        let defaults = UserDefaults.standard

        if let savedData = defaults.object(forKey: userKey) as? Data {
            let decoder = JSONDecoder()
            if let savedQuest = try? decoder.decode([User.Quest.Buy].self, from: savedData) {
                return savedQuest
            }
        }

        return nil
    }

    func clear(questId: Int) {
        if let quests = load() {
            var data = [User.Quest.Buy]()

            quests.forEach { quest in
                if quest.questId != questId {
                    data.append(quest)
                }
            }

            let encoder = JSONEncoder()
            if let encoded = try? encoder.encode(data) {
                let defaults = UserDefaults.standard
                defaults.set(encoded, forKey: userKey)
                defaults.synchronize()
            }
        }
    }
}
