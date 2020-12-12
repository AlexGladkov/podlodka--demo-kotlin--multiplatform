//
//  StoryPageViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 16.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol StoryPageDisplayLogic: class {
    /// Display content data
    func display(content: [CellConfigurator])

    /// Display user send wrong code
    func displayWrongCode()

    /// Display finish page
    func displayFinishPage()

    /// Display loading
    func display(loadingState: Bool)

    /// Display single action
    func display(action: StoryPageAction)

    /// Display new view state
    func display(viewState: StoryPageViewState)
}

final class StoryPageViewController: UIViewController {

    // MARK: - IBOutlets
    @IBOutlet private weak var tableView: UITableView!
    @IBOutlet private weak var codeContainerView: UIView!
    @IBOutlet private weak var codeTextView: UITextField!
    @IBOutlet private weak var buttonSendView: UIButton!
    @IBOutlet private weak var loaderView: UIActivityIndicatorView!
    @IBOutlet private weak var containerBottomMargin: NSLayoutConstraint!

    // MARK: - External vars
    private(set) var router: (StoryPageRoutingLogic & StoryPageDataPassing)?

    // MARK: Internal vars
    private var interactor: StoryPageBusinessLogic?
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
        let interactor = StoryPageInteractor()
        let presenter = StoryPagePresenter()
        let router = StoryPageRouter()
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
        configureCodeContainer()
        configureSendButton()
        interactor?.obtainEvent(event: .fetchInitial)
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        configureKeyboard()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        NotificationCenter.default.removeObserver(self)
    }

    private func configureKeyboard() {
        codeTextView.delegate = self

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillChange(notification:)),
                                               name: UIResponder.keyboardWillChangeFrameNotification, object: nil)

        NotificationCenter.default.addObserver(self,
                                               selector: #selector(keyboardWillHide),
                                               name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func configureSendButton() {
        buttonSendView.contentEdgeInsets = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        buttonSendView.addTarget(self, action: #selector(didSendTap), for: .touchUpInside)
    }

    private func configureCodeContainer() {
        codeContainerView.layer.cornerRadius = 24
        codeContainerView.layer.masksToBounds = false
        codeContainerView.layer.shadowColor = UIColor.black.cgColor
        codeContainerView.layer.shadowOffset = CGSize(width: 0.0, height: 3.0)
        codeContainerView.layer.shadowOpacity = 0.2
        codeContainerView.layer.shadowRadius = 1.0
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
    }
}

// MARK: - Actions
extension StoryPageViewController {

    @objc private func didSendTap() {
        interactor?.obtainEvent(event: .sendAnswer(codeTextView.text ?? ""))
    }

    @objc private func keyboardWillChange(notification: Notification) {
        let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
        guard let keyboardHeight = keyboardSize?.height else { return }

        let newHeight = keyboardHeight - view.safeAreaInsets.bottom + 16
        containerBottomMargin.constant = newHeight
        tableView.contentInset = .init(top: 0, left: 0, bottom: 48 + 24 + 24 + newHeight, right: 0)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }

    @objc private func keyboardWillHide() {
        containerBottomMargin.constant = 24
        tableView.contentInset = .init(top: 0, left: 0, bottom: 48 + 24 + 24, right: 0)

        UIView.animate(withDuration: 0.3) {
            self.view.layoutIfNeeded()
        }
    }
}

// MARK: - TextField delegate
extension StoryPageViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        interactor?.obtainEvent(event: .sendAnswer(codeTextView.text ?? ""))
        return true
    }
}

// MARK: - StoryPage Display Logic
extension StoryPageViewController: StoryPageDisplayLogic {
    func display(content: [CellConfigurator]) {
        displayData.removeAll()
        displayData.append(contentsOf: content)

        tableView.isHidden = false
        codeContainerView.isHidden = false
        tableView.reloadData()
    }

    func display(action: StoryPageAction) {
        switch action {
        case .openFinalPage:
            router?.routeToFinishPage()

        case .openNextPage(let nextPageId):
            router?.routeToNextPage(pageId: nextPageId)

        case .openPayPage:
            break

        case .openWrongAnswer:
            router?.routeToWrongCode()

        case .showError(_):
            break

        case .showPayFlow:
            router?.routeToPayWindow()
        }
    }

    func display(viewState: StoryPageViewState) {
        switch viewState.fetchStatus {
        case .loading:
            loaderView.startAnimating()
            tableView.isHidden = true
            codeContainerView.isHidden = true

        case .error(_):
            break

        case .showContent(let items):
            displayData.removeAll()
            displayData.append(contentsOf: items)

            loaderView.stopAnimating()
            tableView.isHidden = false
            codeContainerView.isHidden = false
            tableView.reloadData()

        case .showInfo(let info):
            displayData.removeAll()
            displayData.append(contentsOf: info)

            codeContainerView.isHidden = true
            tableView.reloadData()

            self.view.endEditing(true)
        }
    }

    func displayWrongCode() {
        router?.routeToWrongCode()
    }

    func displayFinishPage() {
        router?.routeToFinishPage()
    }

    func display(loadingState: Bool) {
        tableView.isHidden = loadingState
        codeContainerView.isHidden = loadingState

        if loadingState {
            loaderView.startAnimating()
        } else {
            loaderView.stopAnimating()
        }
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource
extension StoryPageViewController: UITableViewDataSource, UITableViewDelegate {

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

        (cell as? ImageCell)?.delegate = self
        (cell as? ButtonCell)?.delegate = self

        return cell
    }
}

// MARK: - Buttton Cell Delegate
extension StoryPageViewController: ButtonCellDelegate {
    func didButtonTap(model: ButtonCellModel) {
        interactor?.obtainEvent(event: .nextPage)
    }
}

// MARK: - Image Cell Delegate
extension StoryPageViewController: ImageCellDelegate {

    func didImageTap(url: URL?) {
        router?.routeToFullImage(url: url)
    }
}
