//
//  StoryPageRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 16.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol StoryPageRoutingLogic {
    /// Route to next page
    func routeToNextPage(pageId: Int)

    /// Route to wrong code
    func routeToWrongCode()

    /// Route to quest ending
    func routeToFinishPage()

    /// User clicked on image
    func routeToFullImage(url: URL?)

    /// User needs to pay queset
    func routeToPayWindow()
}

protocol StoryPageDataPassing {
    /// Pass data between routers
    var dataStore: StoryPageDataStoring? { get }
}

// MARK: - Test Data Passing
final class StoryPageRouter: StoryPageDataPassing {

    // MARK: External vars
    var dataStore: StoryPageDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - StoryPage Routing Logic
extension StoryPageRouter: StoryPageRoutingLogic {

    func routeToWrongCode() {
        let alertViewController = UIAlertController(title: "Ошибка", message: "Вы ввели неправильный код, попробуйте еще раз", preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Хорошо", style: .default, handler: nil))

        viewController?.present(alertViewController, animated: true, completion: nil)
    }

    func routeToPayWindow() {
        guard let viewState = dataStore?.viewState else { return }

        let payFlowViewController: PayFlowViewController = ControllerFactory.createViewController()
        payFlowViewController.router?.dataStore?.questId = viewState.currentQuestId

        viewController?.present(payFlowViewController, animated: true, completion: nil)
    }

    func routeToFinishPage() {
        let finishPageViewController: FinishPageViewController = ControllerFactory.createViewController()
        finishPageViewController.router?.dataStore?.questId = dataStore?.viewState.currentQuestId
        finishPageViewController.modalPresentationStyle = .overFullScreen

        viewController?.present(finishPageViewController, animated: true, completion: nil)
    }

    func routeToNextPage(pageId: Int) {
        guard let dataStore = dataStore else { return }

        let storyPageViewController: StoryPageViewController = ControllerFactory.createViewController()


        storyPageViewController.router?.dataStore?.viewState = StoryPageViewState.copy(currentViewState: dataStore.viewState,
                                                                                       currentPage: pageId)

        viewController?.navigationController?.pushViewController(storyPageViewController, animated: true)
    }

    func routeToFullImage(url: URL?) {
        let fullImageViewController: FullImageViewController = ControllerFactory.createViewController()
        fullImageViewController.router?.dataStore?.imageUrl = url
        fullImageViewController.modalPresentationStyle = .overFullScreen

        viewController?.present(fullImageViewController, animated: true, completion: nil)
    }
}
