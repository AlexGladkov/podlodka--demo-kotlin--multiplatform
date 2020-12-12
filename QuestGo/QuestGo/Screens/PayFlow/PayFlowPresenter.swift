//
//  PayFlowPresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

protocol PayFlowPresentationLogic {
    /// Present current view state
    func present(viewState: PayFlowViewState)

    /// Present some action
    func present(action: PayFlowAction)
}

final class PayFlowPresenter {
    // MARK: External vars
    weak var viewController: PayFlowDisplayLogic?
}

// MARK: - PayFlow Presentation Logic
extension PayFlowPresenter: PayFlowPresentationLogic {

    func present(viewState: PayFlowViewState) {
        viewController?.display(viewState: viewState)
    }

    func present(action: PayFlowAction) {
        viewController?.display(action: action)
    }
}
