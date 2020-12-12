//
//  FinishPageRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol FinishPageRoutingLogic {
    /// Route to quest list
    func routeToQuestList()

    /// User clicked on share button
    func routetoShare(sender: UIView)
}

protocol FinishPageDataPassing {
    /// Pass data between routers
    var dataStore: FinishPageDataStoring? { get }
}

// MARK: - Test Data Passing
final class FinishPageRouter: FinishPageDataPassing {

    // MARK: External vars
    var dataStore: FinishPageDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - FinishPage Routing Logic
extension FinishPageRouter: FinishPageRoutingLogic {

    func routeToQuestList() {
        let questListViewController: QuestsListViewController = ControllerFactory.createViewController()
        questListViewController.modalPresentationStyle = .overFullScreen

        self.viewController?.present(questListViewController, animated: true, completion: nil)
    }

    func routetoShare(sender: UIView) {
        // Setting description
        let firstActivityItem = "Классные квесты от QuestGo! Привычные маршруты и городские пейзажи заиграли новыми красками. Скачивайте приложение, рекомендую! https://questgo.page.link/app"

        // If you want to use an image
        let activityViewController : UIActivityViewController = UIActivityViewController(
            activityItems: [firstActivityItem], applicationActivities: nil)

        // This lines is for the popover you need to show in iPad
        activityViewController.popoverPresentationController?.sourceView = sender

        // This line remove the arrow of the popover to show in iPad
        activityViewController.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
        activityViewController.popoverPresentationController?.sourceRect = CGRect(x: 150, y: 150, width: 0, height: 0)

        // Pre-configuring activity items
        activityViewController.activityItemsConfiguration = [UIActivity.ActivityType.message] as? UIActivityItemsConfigurationReading

        // Anything you want to exclude
        activityViewController.excludedActivityTypes = [
            UIActivity.ActivityType.postToWeibo,
            UIActivity.ActivityType.print,
            UIActivity.ActivityType.assignToContact,
            UIActivity.ActivityType.saveToCameraRoll,
            UIActivity.ActivityType.addToReadingList,
            UIActivity.ActivityType.postToFlickr,
            UIActivity.ActivityType.postToVimeo,
            UIActivity.ActivityType.postToTencentWeibo,
            UIActivity.ActivityType.postToFacebook
        ]

        activityViewController.isModalInPresentation = true
        viewController?.present(activityViewController, animated: true, completion: nil)
    }
}
