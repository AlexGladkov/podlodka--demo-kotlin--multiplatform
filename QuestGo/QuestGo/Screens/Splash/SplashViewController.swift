//
//  SplashViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol SplashDisplayLogic: class {
    /// Display single action
    func display(action: SplashAction)
}

final class SplashViewController: UIViewController {

    @IBOutlet weak var iconHolderView: UIView!

    // MARK: - External vars
    private(set) var router: (SplashRoutingLogic & SplashDataPassing)?

    // MARK: Internal vars
    private var interactor: SplashBusinessLogic?

    // MARK: Object lifecycle
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    // MARK: - Setup
    private func setup() {
        let viewController = self
        let interactor = SplashInteractor()
        let presenter = SplashPresenter()
        let router = SplashRouter()
        viewController.interactor = interactor
        viewController.router = router
        interactor.presenter = presenter
        presenter.viewController = viewController
        router.viewController = viewController
        router.dataStore = interactor
    }

    // MARK: View lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

        iconHolderView.layer.cornerRadius = 8
        iconHolderView.layer.shadowColor = UIColor.black.cgColor
        iconHolderView.layer.shadowOpacity = 0.2
        iconHolderView.layer.shadowOffset = CGSize(width: 2, height: 2)
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        interactor?.obtainEvent(event: .initApplication)
    }
}

// MARK: - Splash Display Logic
extension SplashViewController: SplashDisplayLogic {

    func display(action: SplashAction) {
        switch action {
        case .openQuestList:
            router?.routeToQuestList()

        case .openQuestPage(let questId, let questPage):
            router?.routeToQuestPage(questId: questId, questPage: questPage)
        }
    }
}
