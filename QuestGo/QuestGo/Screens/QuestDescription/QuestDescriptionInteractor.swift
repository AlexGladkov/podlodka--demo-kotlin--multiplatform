//
//  QuestDescriptionInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import StoreKit
import FirebaseAnalytics

protocol QuestDescriptionBusinessLogic {
    /// Obtain user actions
    func obtainEvent(event: QuestDescriptionEvent)
}

protocol QuestDescriptionDataStoring: class {
    /// Quest ID
    var questId: Int? { get set }

    /// Description parts
    var components: [QuestModel.QuestComponent]? { get set }
}

// MARK: - QuestDescription Data Storing
final class QuestDescriptionInteractor: QuestDescriptionDataStoring {

    // MARK: - External vars
    var presenter: QuestDescriptionPresentationLogic?
    var questId: Int?
    var components: [QuestModel.QuestComponent]?

    // MARK: QuestDescription Data Storing

    // MARK: Internal vars
    private var currentProduct: SKProduct?
    private let userWorker = UserWorker()

    private func renderQuest() {
        guard let components = components else { return }

        var displayData = [CellConfigurator]()

        components.forEach { component in
            switch component.type {
            case "text":
                displayData.append(TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: component.content)))
            case "image":
                displayData.append(TableCellConfigurator<ImageCell, ImageCellModel>(item: .init(imageUrl: URL(string: component.content))))
            case "video":
                displayData.append(TableCellConfigurator<VideoCell, VideoCellModel>(item: .init(videoId: component.content)))
            case "header":
                displayData.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: component.content)))
            default:
                break
            }
        }

        displayData.append(TableCellConfigurator<ButtonCell, ButtonCellModel>(item: ButtonCellModel(identifier: 0,
                                                                                                    buttonTitle: "Начать играть бесплатно")))

        presenter?.present(viewState: QuestDescriptionViewState(renderItems: displayData))
    }
}

// MARK: - QuestDescription Business Logic
extension QuestDescriptionInteractor: QuestDescriptionBusinessLogic {

    func obtainEvent(event: QuestDescriptionEvent) {
        switch event {
        case .screenShown:
            renderQuest()

        case .playQuest:
            presenter?.present(action: .openStoryPage(questId ?? 0))
        }
    }
}
