//
//  QuestsListRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol QuestsListRoutingLogic {
    /// User clicked on quest
    func routeToQuest(questId: String, description: [QuestModel.QuestComponent])
}

protocol QuestsListDataPassing {
    /// Pass data between routers
    var dataStore: QuestsListDataStoring? { get }
}

// MARK: - Test Data Passing
final class QuestsListRouter: QuestsListDataPassing {

    // MARK: External vars
    var dataStore: QuestsListDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - QuestsList Routing Logic
extension QuestsListRouter: QuestsListRoutingLogic {

    func routeToQuest(questId: String, description: [QuestModel.QuestComponent]) {
        let questDescriptionViewController: QuestDescriptionViewController = ControllerFactory.createViewController()
        questDescriptionViewController.router?.dataStore?.questId = Int(questId) ?? 0
        questDescriptionViewController.router?.dataStore?.components = description
        let navigationController = UINavigationController(rootViewController: questDescriptionViewController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.navigationBar.isHidden = true

        self.viewController?.present(navigationController, animated: true, completion: nil)
    }
}
