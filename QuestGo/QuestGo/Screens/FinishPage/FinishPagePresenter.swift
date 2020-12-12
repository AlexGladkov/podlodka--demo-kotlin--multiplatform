//
//  FinishPagePresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

protocol FinishPagePresentationLogic {
    /// Present single action
    func present(action: FinishAction)

    /// Present view state
    func present(viewState: FinishViewState)
}

final class FinishPagePresenter {
    // MARK: External vars
    weak var viewController: FinishPageDisplayLogic?
}

// MARK: - FinishPage Presentation Logic
extension FinishPagePresenter: FinishPagePresentationLogic {

    func present(action: FinishAction) {
        viewController?.display(action: action)
    }

    func present(viewState: FinishViewState) {
        viewController?.display(viewState: viewState)
    }
}
