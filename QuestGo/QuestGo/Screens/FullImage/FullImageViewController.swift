//
//  FullImageViewController.swift
//  QuestGo
//
//  Created by Алексей Гладков on 25.09.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import UIKit

protocol FullImageDisplayLogic: class {
    /// Display full image view
    func display(image: UIImage)

    /// Display state when image downloading
    func displayLoading()
}

final class FullImageViewController: UIViewController {

    private var imageScrollView: ImageScrollView!
    @IBOutlet weak var loaderView: UIActivityIndicatorView!
    @IBOutlet weak var closeButtonView: UIButton!

    // MARK: - External vars
    private(set) var router: (FullImageRoutingLogic & FullImageDataPassing)?

    // MARK: Internal vars
    private var interactor: FullImageBusinessLogic?

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
        let interactor = FullImageInteractor()
        let presenter = FullImagePresenter()
        let router = FullImageRouter()
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

        interactor?.fetchImage()
    }

    func setupImageScrollView() {
        imageScrollView.translatesAutoresizingMaskIntoConstraints = false
        imageScrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        imageScrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        imageScrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        imageScrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
    }

    @IBAction func closeTap(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}


// MARK: - FullImage Display Logic
extension FullImageViewController: FullImageDisplayLogic {

    func display(image: UIImage) {
        loaderView.stopAnimating()
        
        imageScrollView = ImageScrollView(frame: view.bounds)
        view.addSubview(imageScrollView)
        setupImageScrollView()

        imageScrollView.set(image: image)
        view.bringSubviewToFront(closeButtonView)
    }

    func displayLoading() {
        loaderView.startAnimating()
    }
}
