//
//  FullImageInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 25.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import Alamofire

protocol FullImageBusinessLogic {
    /// Screen was shown
    func fetchImage()
}

protocol FullImageDataStoring: class {
    /// Image Url
    var imageUrl: URL? { get set }
}

// MARK: - FullImage Data Storing
final class FullImageInteractor: FullImageDataStoring {

    // MARK: - External vars
    var presenter: FullImagePresentationLogic?

    // MARK: FullImage Data Storing
    var imageUrl: URL?

    // MARK: Internal vars
}

// MARK: - FullImage Business Logic
extension FullImageInteractor: FullImageBusinessLogic {

    func fetchImage() {
        guard let imageUrl = imageUrl else { return }

        presenter?.presentLoading()
        AF.request(imageUrl).responseImage { [weak self] response in
            guard let self = self else { return }

            if case .success(let image) = response.result {
                self.presenter?.present(image: image)
            }
        }
    }
}
