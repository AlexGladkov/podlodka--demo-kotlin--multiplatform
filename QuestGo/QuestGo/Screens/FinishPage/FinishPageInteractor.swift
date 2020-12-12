//
//  FinishPageInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import FirebaseAnalytics

protocol FinishPageBusinessLogic {
    /// Remove current quest from list
    func clearQuest()

    /// Obttain user actions
    func obtainEvent(event: FinishEvent)
}

protocol FinishPageDataStoring: class {
    /// Current quest
    var questId: Int? { get set }
}

// MARK: - FinishPage Data Storing
final class FinishPageInteractor: FinishPageDataStoring {

    // MARK: - External vars
    var presenter: FinishPagePresentationLogic?
    var questId: Int?

    // MARK: FinishPage Data Storing

    // MARK: Internal vars
    private let userWorker = UserWorker()
}

// MARK: - FinishPage Business Logic
extension FinishPageInteractor: FinishPageBusinessLogic {

    func clearQuest() {
        guard let questId = questId else { return }

        Analytics.logEvent("main_user_finished_quest", parameters: ["questId": questId])
        userWorker.clear(questId: questId)
    }

    func obtainEvent(event: FinishEvent) {
        switch event {
        case .screenShown:
            renderInitialScreen()

        case .finishQuest:
            launchFinishQuest()
        }
    }

    private func launchFinishQuest() {
        let configuration = userWorker.readConfiguration()
        userWorker.updateConfiguration(configuration: UserConfiguration(currentUserPage: -1,
                                                                        currentQuestId: -1,
                                                                        availableQuestCount: configuration.availableQuestCount,
                                                                        boughtQuestIdsList: configuration.boughtQuestIdsList))
        presenter?.present(action: .openQuestList)
    }

    private func renderInitialScreen() {
        var renderItems = [CellConfigurator]()
        renderItems.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Поздравляем!")))
        renderItems.append(TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: "Вы успешно завершили прохождение квеста. Надеюсь, вам понравилось. Вы также можете поделиться своими впечатлениями с друзьями, отправив им ссылку на квест! Спасибо, что были с нами")))
        renderItems.append(TableCellConfigurator<ButtonCell, ButtonCellModel>(item: .init(identifier: 0, buttonTitle: "Поделиться с друзьями")))
        renderItems.append(TableCellConfigurator<TextButtonCell, TextButtonCellModel>(item: .init(identifier: 0, title: "Завершить квест")))

        let viewState = FinishViewState(renderItems: renderItems)
        presenter?.present(viewState: viewState)
    }
}
