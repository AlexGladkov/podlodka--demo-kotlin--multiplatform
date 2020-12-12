//
//  SplashPresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

protocol SplashPresentationLogic {
    /// Present single action
    func present(action: SplashAction)
}

final class SplashPresenter {
    // MARK: External vars
    weak var viewController: SplashDisplayLogic?
}

// MARK: - Splash Presentation Logic
extension SplashPresenter: SplashPresentationLogic {

    func present(action: SplashAction) {
        viewController?.display(action: action)
    }
}
