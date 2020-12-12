//
//  SplashRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol SplashRoutingLogic {
    /// User has no quest
    func routeToQuestList()

    /// User has quest history
    func routeToQuestPage(questId: Int, questPage: Int)
}

protocol SplashDataPassing {
    /// Pass data between routers
    var dataStore: SplashDataStoring? { get }
}

// MARK: - Test Data Passing
final class SplashRouter: SplashDataPassing {

    // MARK: External vars
    var dataStore: SplashDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - Splash Routing Logic
extension SplashRouter: SplashRoutingLogic {

    func routeToQuestList() {
        let questListController: QuestsListViewController = ControllerFactory.createViewController()
        questListController.modalPresentationStyle = .overFullScreen

        viewController?.present(questListController, animated: true, completion: nil)
    }

    func routeToQuestPage(questId: Int, questPage: Int) {
        let storyPageController: StoryPageViewController = ControllerFactory.createViewController()
        storyPageController.router?.dataStore?.viewState = StoryPageViewState(currentQuestId: questId,
                                                                              currentPage: questPage)

        let navigationController = UINavigationController(rootViewController: storyPageController)
        navigationController.modalPresentationStyle = .overFullScreen
        navigationController.navigationBar.isHidden = true

        viewController?.present(navigationController, animated: true, completion: nil)
    }
}
