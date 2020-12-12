//
//  FullImageRouter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 25.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol FullImageRoutingLogic {
    /// Required documentation
}

protocol FullImageDataPassing {
    /// Pass data between routers
    var dataStore: FullImageDataStoring? { get }
}

// MARK: - Test Data Passing
final class FullImageRouter: FullImageDataPassing {

    // MARK: External vars
    var dataStore: FullImageDataStoring?

    // MARK: Internal vars
    weak var viewController: UIViewController?
}

// MARK: - FullImage Routing Logic
extension FullImageRouter: FullImageRoutingLogic {
}
