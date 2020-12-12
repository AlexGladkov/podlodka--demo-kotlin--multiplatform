//
//  QuestDescriptionRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol QuestDescriptionRoutingLogic {
    /// User paid quest
    func routeToQuest(questId: Int)

    /// User got error
    func routeToAlert(title: String, message: String)

    /// User clicked to image
    func routeToImage(url: URL?)
}

protocol QuestDescriptionDataPassing {
    /// Pass data between routers
    var dataStore: QuestDescriptionDataStoring? { get }
}

// MARK: - Test Data Passing
final class QuestDescriptionRouter: QuestDescriptionDataPassing {

    // MARK: External vars
    var dataStore: QuestDescriptionDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - QuestDescription Routing Logic
extension QuestDescriptionRouter: QuestDescriptionRoutingLogic {

    func routeToQuest(questId: Int) {
        let storyPageViewController: StoryPageViewController = ControllerFactory.createViewController()
        storyPageViewController.router?.dataStore?.viewState = StoryPageViewState(currentQuestId: questId,
                                                                                  currentPage: 0)

        let navigationViewController = UINavigationController(rootViewController: storyPageViewController)
        navigationViewController.modalPresentationStyle = .overFullScreen
        navigationViewController.navigationBar.isHidden = true

        viewController?.present(navigationViewController, animated: true, completion: nil)
    }

    func routeToAlert(title: String, message: String) {
        let alertViewController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        alertViewController.view.tintColor = UIColor(named: "primaryTextColor")

        viewController?.present(alertViewController, animated: true, completion: nil)
    }

    func routeToImage(url: URL?) {
        let fullImageViewContrtoller: FullImageViewController = ControllerFactory.createViewController()
        fullImageViewContrtoller.router?.dataStore?.imageUrl = url

        viewController?.present(fullImageViewContrtoller, animated: true, completion: nil)
    }
}
