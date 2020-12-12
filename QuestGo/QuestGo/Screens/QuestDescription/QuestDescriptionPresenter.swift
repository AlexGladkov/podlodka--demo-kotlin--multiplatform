//
//  QuestDescriptionPresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import StoreKit

protocol QuestDescriptionPresentationLogic {
    /// Present single action
    func present(action: QuestDescriptionAction)

    /// Present view state
    func present(viewState: QuestDescriptionViewState)
}

final class QuestDescriptionPresenter {
    // MARK: - External vars
    weak var viewController: QuestDescriptionDisplayLogic?
}

// MARK: - QuestDescription Presentation Logic
extension QuestDescriptionPresenter: QuestDescriptionPresentationLogic {

    func present(action: QuestDescriptionAction) {
        viewController?.display(action: action)
    }

    func present(viewState: QuestDescriptionViewState) {
        viewController?.display(viewState: viewState)
    }
}
