//
//  PayFlowRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol PayFlowRoutingLogic {
    /// Show user error
    func routeToError(message: String)
}

protocol PayFlowDataPassing {
    /// Pass data between routers
    var dataStore: PayFlowDataStoring? { get }
}

// MARK: - Test Data Passing
final class PayFlowRouter: PayFlowDataPassing {

    // MARK: External vars
    var dataStore: PayFlowDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - PayFlow Routing Logic
extension PayFlowRouter: PayFlowRoutingLogic {

    func routeToError(message: String) {
        let alertViewController = UIAlertController(title: "Ошибка", message: message, preferredStyle: .alert)
        alertViewController.addAction(UIAlertAction(title: "Закрыть", style: .default, handler: nil))

        viewController?.present(alertViewController, animated: true, completion: nil)
    }
}
