//
//  ControllerFactory.swift
//  LeroyMerlin
//
//  Created by Алексей Гладков on 13/09/2019.
//  Copyright © 2019 LeroyMerlin. All rights reserved.
//
import UIKit

class ControllerFactory {

    static func createViewController<T: UIViewController>() -> T {
        let nameStoryboard = String(describing: T.self)
        let nameViewController = String(describing: T.self)
        let storyboard = UIStoryboard(name: nameStoryboard, bundle: nil)
        let newVC = storyboard.instantiateViewController(withIdentifier: nameViewController)
        guard let viewController = newVC as? T else { fatalError() }

        return viewController
    }
}
