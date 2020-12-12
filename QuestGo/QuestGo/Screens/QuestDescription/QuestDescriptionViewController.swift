//
//  QuestDescriptionViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 07.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol QuestDescriptionDisplayLogic: class {
    /// Display single action
    func display(action: QuestDescriptionAction)

    /// Display view state
    func display(viewState: QuestDescriptionViewState)
}

final class QuestDescriptionViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!

    // MARK: - External vars
    private(set) var router: (QuestDescriptionRoutingLogic & QuestDescriptionDataPassing)?

    // MARK: Internal vars
    private var interactor: QuestDescriptionBusinessLogic?
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
        let interactor = QuestDescriptionInteractor()
        let presenter = QuestDescriptionPresenter()
        let router = QuestDescriptionRouter()
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

    // MARK: - Internal logic
    private func configureTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none

        let footerView = UIView(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 24))
        footerView.backgroundColor = UIColor(named: "primaryBackroundColor")

        tableView.tableFooterView = footerView

        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: String(describing: HeaderCell.self))
        tableView.register(UINib(nibName: "TextCell", bundle: nil), forCellReuseIdentifier: String(describing: TextCell.self))
        tableView.register(UINib(nibName: "ImageCell", bundle: nil), forCellReuseIdentifier: String(describing: ImageCell.self))
        tableView.register(UINib(nibName: "ButtonCell", bundle: nil), forCellReuseIdentifier: String(describing: ButtonCell.self))
        tableView.register(UINib(nibName: "VideoCell", bundle: nil), forCellReuseIdentifier: String(describing: VideoCell.self))
        tableView.register(UINib(nibName: "LoadingCell", bundle: nil), forCellReuseIdentifier: String(describing: LoadingCell.self))
    }
}

// MARK: - QuestDescription Display Logic
extension QuestDescriptionViewController: QuestDescriptionDisplayLogic {

    func display(action: QuestDescriptionAction) {
        switch action {
        case .openStoryPage(let questId):
            router?.routeToQuest(questId: questId)
        }
    }

    func display(viewState: QuestDescriptionViewState) {
        displayData.removeAll()
        displayData.append(contentsOf: viewState.renderItems)

        tableView.reloadData()
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension QuestDescriptionViewController: UITableViewDelegate, UITableViewDataSource {

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
        (cell as? ImageCell)?.delegate = self

        return cell
    }
}

// MARK: - Image Cell Deleegate
extension QuestDescriptionViewController: ImageCellDelegate {

    func didImageTap(url: URL?) {
        router?.routeToImage(url: url)
    }
}

// MARK: - Button Cell Delegate
extension QuestDescriptionViewController: ButtonCellDelegate {
    func didButtonTap(model: ButtonCellModel) {
        interactor?.obtainEvent(event: .playQuest)
    }
}
