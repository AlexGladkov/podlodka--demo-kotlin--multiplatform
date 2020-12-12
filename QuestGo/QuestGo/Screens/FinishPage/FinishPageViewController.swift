//
//  FinishPageViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit
import FirebaseAnalytics

protocol FinishPageDisplayLogic: class {
    /// Display single action
    func display(action: FinishAction)

    /// DIsplay view state
    func display(viewState: FinishViewState)
}

final class FinishPageViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - External vars
    private(set) var router: (FinishPageRoutingLogic & FinishPageDataPassing)?

    // MARK: Internal vars
    private var interactor: FinishPageBusinessLogic?
    private var displayData = [CellConfigurator]()

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
        let interactor = FinishPageInteractor()
        let presenter = FinishPagePresenter()
        let router = FinishPageRouter()
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
        configureTableView()

        interactor?.obtainEvent(event: .screenShown)
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        tableView.tableFooterView = UIView(frame: .zero)
        tableView.contentInset = .init(top: 0, left: 0, bottom: 48 + 24 + 24, right: 0)

        tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: String(describing: TextCell.self))
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: String(describing: ImageCell.self))
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: String(describing: VideoCell.self))
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: String(describing: HeaderCell.self))
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: String(describing: ButtonCell.self))
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: String(describing: LoadingCell.self))
        tableView.register(UINib(nibName: "TextButtonCell", bundle: nil), forCellReuseIdentifier: String(describing: TextButtonCell.self))
        tableView.register(UINib(nibName: "TextFieldCell", bundle: nil), forCellReuseIdentifier: String(describing: TextFieldCell.self))
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension FinishPageViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return displayData.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard
            let cell = tableView.dequeueReusableCell(withIdentifier: type(of: displayData[indexPath.row]).cellReuseIdentifier)
            else {
                return UITableViewCell()
        }

        displayData[indexPath.row].setup(cell: cell)

        (cell as? ButtonCell)?.delegate = self
        (cell as? TextButtonCell)?.delegate = self

        return cell
    }
}

extension FinishPageViewController: ButtonCellDelegate {
    func didButtonTap(model: ButtonCellModel) {
        switch model.identifier {
        case 0:
            router?.routetoShare(sender: tableView)

        default:
            break
        }
    }
}

extension FinishPageViewController: TextButtonCellDelegate {
    func buttonTapped(model: TextButtonCellModel) {
        switch model.identifier {
        case 0:
            interactor?.obtainEvent(event: .finishQuest)

        default:
            break
        }
    }
}

// MARK: - FinishPage Display Logic
extension FinishPageViewController: FinishPageDisplayLogic {

    func display(action: FinishAction) {
        switch action {
        case .openQuestList:
            router?.routeToQuestList()
        }
    }

    func display(viewState: FinishViewState) {
        displayData.removeAll()
        displayData.append(contentsOf: viewState.renderItems)

        tableView.reloadData()
    }
}
