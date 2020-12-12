//
//  FullImagePresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 25.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import UIKit

protocol FullImagePresentationLogic {
    /// Present handled image url
    func present(image: UIImage)

    /// Present state when image downloading
    func presentLoading()
}

final class FullImagePresenter {
    // MARK: External vars
    weak var viewController: FullImageDisplayLogic?
}

// MARK: - FullImage Presentation Logic
extension FullImagePresenter: FullImagePresentationLogic {

    func present(image: UIImage) {
        viewController?.display(image: image)
    }

    func presentLoading() {
        viewController?.displayLoading()
    }
}
