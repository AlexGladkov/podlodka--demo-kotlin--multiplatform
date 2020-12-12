//
//  PayFlowViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol PayFlowDelegate: class {
    func closeWithResult(isPromoSuccess: Bool, isNeedToPay: Bool)
}

protocol PayFlowDisplayLogic: class {
    /// Display current view state
    func display(viewState: PayFlowViewState)

    /// Display action
    func display(action: PayFlowAction)
}

final class PayFlowViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet weak var tableView: UITableView!

    weak var delegate: PayFlowDelegate?

    // MARK: - External vars
    private(set) var router: (PayFlowRoutingLogic & PayFlowDataPassing)?

    // MARK: Internal vars
    private var interactor: PayFlowBusinessLogic?
    private var displayData = [CellConfigurator]()
    private var promoCode = ""

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
        let interactor = PayFlowInteractor()
        let presenter = PayFlowPresenter()
        let router = PayFlowRouter()
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
extension PayFlowViewController: UITableViewDataSource, UITableViewDelegate {

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
        (cell as? TextFieldCell)?.delegate = self

        return cell
    }
}

// MARK: - Text Field Cell Delegate
extension PayFlowViewController: TextFieldDelegate {
    func textDidChanged(identifier: Int, newValue: String) {
        promoCode = newValue
    }
}

// MARK: - Text Button Cell Delegate
extension PayFlowViewController: TextButtonCellDelegate {
    func buttonTapped(model: TextButtonCellModel) {
        switch model.identifier {
        case 0:
            interactor?.obtainEvent(event: .screenShown)

        case 1:
            interactor?.obtainEvent(event: .promoCodeTapped)

        case 2:
            interactor?.obtainEvent(event: .restoreProducts)

        default:
            break
        }
    }
}

// MARK: - Buttton Cell Delegate
extension PayFlowViewController: ButtonCellDelegate {
    func didButtonTap(model: ButtonCellModel) {
        switch model.identifier {
        case 0:
            interactor?.obtainEvent(event: .sendPromo(promoCode))

        case 1:
            interactor?.obtainEvent(event: .buyQuest)

        default:
            break
        }
    }
}

// MARK: - PayFlow Display Logic
extension PayFlowViewController: PayFlowDisplayLogic {

    func display(viewState: PayFlowViewState) {
        displayData.removeAll()
        displayData.append(contentsOf: viewState.renderItems)

        tableView.reloadData()
    }

    func display(action: PayFlowAction) {
        switch action {
        case .closeWithResult(let isSuccessPromo, let isNeedToPay):
            delegate?.closeWithResult(isPromoSuccess: isSuccessPromo, isNeedToPay: isNeedToPay)
            dismiss(animated: true, completion: nil)

        case .showError(let message):
            router?.routeToError(message: message)
        }
    }
}
