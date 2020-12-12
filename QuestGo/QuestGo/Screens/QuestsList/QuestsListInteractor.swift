//
//  QuestsListInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import RxSwift
import FirebaseAnalytics

protocol QuestsListBusinessLogic {
    /// User opened screen
    func fetchQuestList()
}

protocol QuestsListDataStoring: class {
    /// Required documentation
}

// MARK: - QuestsList Data Storing
final class QuestsListInteractor: QuestsListDataStoring {

    // MARK: - External vars
    var presenter: QuestsListPresentationLogic?

    // MARK: QuestsList Data Storing

    // MARK: Internal vars
    private let questWorker = QuestWorker()
    private let disposeBag = DisposeBag()
    private let questListAnalytics = QuestListAnalytics()
}

// MARK: - QuestsList Business Logic
extension QuestsListInteractor: QuestsListBusinessLogic {

    func fetchQuestList() {
        presenter?.present(loadingState: true)
        questWorker.fetchQuestList()
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe(onSuccess: { [weak self] response in
                self?.questListAnalytics.listLoaded(questCount: response.items.count)
                self?.presenter?.present(loadingState: false)
                self?.presenter?.present(response: response)
            }) { [weak self] error in
                self?.questListAnalytics.listError(message: error.localizedDescription)
                self?.presenter?.present(loadingState: false)
                self?.presenter?.present(response: .init(items: []))
        }.disposed(by: disposeBag)
    }
}
