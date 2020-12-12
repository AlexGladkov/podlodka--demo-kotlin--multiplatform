//
//  QuestsListPresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

protocol QuestsListPresentationLogic {
    /// Present quest list response
    func present(response: QuestModel.List.Response)

    /// Present animating switch
    func present(loadingState: Bool)
}

final class QuestsListPresenter {
    // MARK: External vars
    weak var viewController: QuestsListDisplayLogic?
}

// MARK: - QuestsList Presentation Logic
extension QuestsListPresenter: QuestsListPresentationLogic {

    func present(response: QuestModel.List.Response) {
        var cells = response.items.map { quest -> CellConfigurator in
            return TableCellConfigurator<QuestCell, QuestCellModel>(item: .init(questId: "\(quest.questId)",
                                                                                title: quest.questName,
                                                                                subtitle: quest.questSubtitle,
                                                                                image: URL(string: quest.questImage),
                description: quest.description))
        }

        cells.insert(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Квесты")), at: 0)
        cells.insert(TableCellConfigurator<EmptyCell, Any>(item: ""), at: 1)
        viewController?.display(quests: cells)
    }

    func present(loadingState: Bool) {
        viewController?.display(loadingState: loadingState)
    }
}
