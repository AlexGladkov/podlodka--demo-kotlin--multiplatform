//
//  PayFlowInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import RxSwift
import StoreKit

protocol PayFlowBusinessLogic {
    /// User did something
    func obtainEvent(event: PayFlowEvent)
}

protocol PayFlowDataStoring: class {
    /// Quest Id
    var questId: Int? { get set }
}

// MARK: - PayFlow Data Storing
final class PayFlowInteractor: PayFlowDataStoring {

    // MARK: - External vars
    var presenter: PayFlowPresentationLogic?

    // MARK: PayFlow Data Storing
    var questId: Int?

    // MARK: Internal vars
    private var viewState = PayFlowViewState()
    private let promoWorker = PromoWorker()
    private let userWorker = UserWorker()
    private let purchaseAnalytics = PurchaseAnalytics()
    private let disposeBag = DisposeBag()
}

// MARK: - PayFlow Business Logic
extension PayFlowInteractor: PayFlowBusinessLogic {

    func obtainEvent(event: PayFlowEvent) {
        switch event {
        case .screenShown:
            renderInitialScreen()

        case .promoCodeTapped:
            renderPromoCodeScreen()

        case .sendPromo(let code):
            checkPromo(code: code)

        case .buyQuest:
            launchBuyProcess()

        case .restoreProducts:
            launchRestoreProcess()
        }
    }

    private func launchBuyProcess() {
        var renderData = [CellConfigurator]()
        renderData.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Конец ознакомительного фрагмента")))
        renderData.append(TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: "Вы прошли ознакомительный участок квеста. Дальнейшее прохождение будет доступно после оплаты.")))
        renderData.append(TableCellConfigurator<LoadingCell, Any>(item: ""))

        viewState = PayFlowViewState(renderItems: renderData)
        presenter?.present(viewState: viewState)

        StoreObserver.shared.delegate = self
        StoreManager.shared.delegate = self

        StoreManager.shared.startProductRequest(with: ["quest_buy_once"])
    }

    private func launchRestoreProcess() {
        var renderData = [CellConfigurator]()
        renderData.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Конец ознакомительного фрагмента")))
        renderData.append(TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: "Вы прошли ознакомительный участок квеста. Дальнейшее прохождение будет доступно после оплаты.")))
        renderData.append(TableCellConfigurator<LoadingCell, Any>(item: ""))

        viewState = PayFlowViewState(renderItems: renderData)
        presenter?.present(viewState: viewState)

        StoreObserver.shared.delegate = self
        StoreManager.shared.delegate = self

        StoreObserver.shared.restore()
    }

    private func checkPromo(code: String) {
        var renderData = [CellConfigurator]()
        renderData.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Введите промокод")))
        renderData.append(TableCellConfigurator<TextFieldCell, TextFieldCellModel>(item: .init(identifier: 0,
                                                                                               hint: "Например, promoaction")))
        renderData.append(TableCellConfigurator<LoadingCell, Any>(item: ""))

        viewState = PayFlowViewState(renderItems: renderData)
        presenter?.present(viewState: viewState)

        promoWorker.checkPromo(code: code)
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] response in
                if response.isValid {
                    self?.presenter?.present(action: .closeWithResult(true, false))
                } else {
                    self?.renderPromoCodeScreen()
                    self?.presenter?.present(action: .showError("Промокод истек или введен неправильно"))
                }
            } onError: { [weak self] _ in
                self?.renderPromoCodeScreen()
                self?.presenter?.present(action: .showError("Не удалось загрузить данные"))
            }.disposed(by: disposeBag)
    }

    private func renderPromoCodeScreen() {
        var renderData = [CellConfigurator]()
        renderData.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Введите промокод")))
        renderData.append(TableCellConfigurator<TextFieldCell, TextFieldCellModel>(item: .init(identifier: 0,
                                                                                               hint: "Например, promoaction")))
        renderData.append(TableCellConfigurator<ButtonCell, ButtonCellModel>(item: .init(identifier: 0,
                                                                                         buttonTitle: "Отправить")))
        renderData.append(TableCellConfigurator<TextButtonCell, TextButtonCellModel>(item: .init(identifier: 0,
                                                                                                 title: "Назад")))

        viewState = PayFlowViewState(renderItems: renderData)
        presenter?.present(viewState: viewState)
    }

    private func renderInitialScreen() {
        var renderData = [CellConfigurator]()
        renderData.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: "Конец ознакомительного фрагмента")))
        renderData.append(TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: "Вы прошли ознакомительный участок квеста. Дальнейшее прохождение будет доступно после оплаты.")))
        renderData.append(TableCellConfigurator<ButtonCell, ButtonCellModel>(item: .init(identifier: 1,
                                                                                         buttonTitle: "Купить квест")))
        renderData.append(TableCellConfigurator<TextButtonCell, TextButtonCellModel>(item: .init(identifier: 1,
                                                                                                 title: "Ввести промокод")))
        renderData.append(TableCellConfigurator<TextButtonCell, TextButtonCellModel>(item: .init(identifier: 2,
                                                                                                 title: "Восстановить покупки")))

        viewState = PayFlowViewState(renderItems: renderData)
        presenter?.present(viewState: viewState)
    }

    private func finishPayment() {
        guard let questId = questId else {
            purchaseAnalytics.purchaseError(questId: self.questId ?? 0, message: "Не удалось обновить данные")
            presenter?.present(action: .showError("Не удалось обновить данные"))
            presenter?.present(action: .closeWithResult(true, false))
            return
        }

        let currentConfiguration = userWorker.readConfiguration()
        var currentQuestIds = [Int]()
        currentQuestIds.append(contentsOf: currentConfiguration.boughtQuestIdsList)

        if !currentQuestIds.contains(questId) {
            currentQuestIds.append(questId)
        }

        userWorker.updateConfiguration(configuration: UserConfiguration(currentUserPage: currentConfiguration.currentUserPage,
                                                                        currentQuestId: currentConfiguration.currentQuestId,
                                                                        availableQuestCount: currentConfiguration.availableQuestCount,
                                                                        boughtQuestIdsList: currentQuestIds))

        purchaseAnalytics.purchaseSucceed(questId: questId)
        presenter?.present(action: .closeWithResult(true, false))
    }
}

extension PayFlowInteractor: StoreManagerDelegate {
    func storeManagerDidReceiveResponse(_ response: [Section]) {
        guard
            let firstSection = response.first,
            let products = firstSection.elements as? [SKProduct],
            let product = products.first
        else { return }

        StoreObserver.shared.buy(product)
    }

    func storeManagerDidReceiveMessage(_ message: String) {
        renderInitialScreen()
        let messageString = "Не удалось получить данные для оплаты"
        purchaseAnalytics.purchaseError(questId: self.questId ?? 0, message: messageString)
        presenter?.present(action: .showError(messageString))
    }
}

extension PayFlowInteractor: StoreObserverDelegate {
    func storeObserverRestoreDidSucceed() {
        finishPayment()
    }

    func storeObserverBuyDidSucceed() {
        finishPayment()
    }

    func storeObserverDidReceiveMessage(_ message: String) {
        switch message {
        case Messages.noRestorablePurchases:
            let messageString = "На данный момент у вас отсутствуют покупки. Вы можете приобрести квест, нажав на кнопку купить"
            purchaseAnalytics.purchaseError(questId: self.questId ?? 0, message: messageString)
            presenter?.present(action: .showError(messageString))

        case Messages.canceled:
            let messageString = "Оплата была отменена пользователем"
            purchaseAnalytics.purchaseCanceled(questId: self.questId ?? 0)
            presenter?.present(action: .showError(messageString))

        default:
            let messageString = "Не удалось совершить платеж"
            purchaseAnalytics.purchaseError(questId: self.questId ?? 0, message: messageString)
            presenter?.present(action: .showError(messageString))
        }

        renderInitialScreen()
    }
}
