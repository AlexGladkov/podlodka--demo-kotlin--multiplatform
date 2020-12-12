//
//  QuestsListViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol QuestsListDisplayLogic: class {
    /// Display quest list
    func display(quests: [CellConfigurator])

    /// Display loading
    func display(loadingState: Bool)
}

final class QuestsListViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var loaderView: UIActivityIndicatorView!

    // MARK: - External vars
    private(set) var router: (QuestsListRoutingLogic & QuestsListDataPassing)?

    // MARK: Internal vars
    private var interactor: QuestsListBusinessLogic?
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
        let interactor = QuestsListInteractor()
        let presenter = QuestsListPresenter()
        let router = QuestsListRouter()
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

        interactor?.fetchQuestList()
    }

    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.tableFooterView = UIView(frame: .zero)

        tableView.register(UINib(nibName: "QuestCell", bundle: nil), forCellReuseIdentifier: String(describing: QuestCell.self))
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: String(describing: HeaderCell.self))
        tableView.register(UINib(nibName: "EmptyCell", bundle: nil), forCellReuseIdentifier: String(describing: EmptyCell.self))

        tableView.reloadData()
    }
}

// MARK: - QuestsList Display Logic
extension QuestsListViewController: QuestsListDisplayLogic {
    func display(quests: [CellConfigurator]) {
        displayData.removeAll()
        displayData.append(contentsOf: quests)

        tableView.reloadData()
    }

    func display(loadingState: Bool) {
        if loadingState {
            loaderView.startAnimating() 
        } else {
            loaderView.stopAnimating()
        }
    }
}

// MARK: - QuestList TableView Delegate, DataSource
extension QuestsListViewController: UITableViewDelegate, UITableViewDataSource {

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

        cell.selectionStyle = .none

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        if let model = displayData[indexPath.row] as? TableCellConfigurator<QuestCell, QuestCellModel> {
            router?.routeToQuest(questId: model.item.questId, description: model.item.description)
        }
    }
}
