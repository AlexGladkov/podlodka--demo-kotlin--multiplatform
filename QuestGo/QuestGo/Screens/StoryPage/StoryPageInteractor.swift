//
//  StoryPageInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 16.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Alamofire
import RxSwift
import FirebaseAnalytics

protocol StoryPageBusinessLogic {
    /// User did something
    func obtainEvent(event: StoryPageEvent)
}

protocol StoryPageDataStoring: class {
    /// Current view state
    var viewState: StoryPageViewState { get set }
}

// MARK: - StoryPage Data Storing
final class StoryPageInteractor: StoryPageDataStoring {

    // MARK: - External vars
    var presenter: StoryPagePresentationLogic?

    // MARK: StoryPage Data Storing
    var viewState: StoryPageViewState = StoryPageViewState()

    // MARK: Internal vars
    private let questWorker = QuestWorker()
    private let userWorker = UserWorker()
    private let questPageAnalytics = QuestPageAnalytics()
    private let disposeBag = DisposeBag()
}

// MARK: - StoryPage Business Logic
extension StoryPageInteractor: StoryPageBusinessLogic {

    func obtainEvent(event: StoryPageEvent) {
        switch event {
        case .fetchInitial:
            fetchQuestData()

        case .sendAnswer(let code):
            checkAnswer(text: code)

        case .nextPage:
            checkNextPageAvailable()
        }
    }

    private func checkAnswer(text: String) {
        if (text.lowercased() == viewState.correctAnswer.lowercased()) {
            questPageAnalytics.answerSend(questId: viewState.currentQuestId,
                                          questPage: viewState.currentPage,
                                          code: text.lowercased(), correct: true)

            var displayResult = viewState.infoData
            displayResult.append(TableCellConfigurator<ButtonCell, ButtonCellModel>(item: .init(identifier: 0,
                                                                                                buttonTitle: "Продолжить")))

            self.viewState = StoryPageViewState.copy(
                currentViewState: self.viewState,
                fetchStatus: .showInfo(displayResult)
            )

            questPageAnalytics.infoLoaded(questId: viewState.currentQuestId, questPage: viewState.currentPage)
            self.presenter?.present(viewState: viewState)
        } else {
            questPageAnalytics.answerSend(questId: viewState.currentQuestId,
                                          questPage: viewState.currentPage,
                                          code: text.lowercased(), correct: false)

            self.presenter?.present(action: .openWrongAnswer)
        }
    }

    private func checkNextPageAvailable() {
        guard viewState.currentQuestMaxPages > viewState.currentPage + 1 else {
            presenter?.present(action: .openFinalPage)
            return
        }

        if viewState.needsToPay {
            presenter?.present(action: .showPayFlow)
        } else {
            presenter?.present(action: .openNextPage(viewState.currentPage + 1))
        }
    }

    private func fetchQuestData() {
        guard viewState.currentQuestId >= 0 && viewState.currentPage >= 0 else {
            // Fallback to error
            return
        }

        presenter?.present(viewState: viewState)

        questWorker
            .fetchQuest(request: QuestModel.Fetch.Request(questId: viewState.currentQuestId))
            .subscribeOn(ConcurrentDispatchQueueScheduler(qos: .userInitiated))
            .observeOn(MainScheduler.instance)
            .subscribe { [weak self] response in
                guard let self = self else { return }
                guard response.pages.count > 0 else {
                    self.presenter?.present(action: .openFinalPage)
                    return
                }

                let currentPage = response.pages[self.viewState.currentPage]

                let configuration = self.userWorker.readConfiguration()
                self.userWorker.updateConfiguration(configuration: UserConfiguration(currentUserPage: self.viewState.currentPage,
                                                                                     currentQuestId: self.viewState.currentQuestId,
                                                                                     availableQuestCount: configuration.availableQuestCount,
                                                                                     boughtQuestIdsList: configuration.boughtQuestIdsList))

                self.questPageAnalytics.pageLoaded(questId: self.viewState.currentQuestId,
                                                   questPage: self.viewState.currentPage)

                // TODO: - Add configuration update to current page
                self.viewState = StoryPageViewState.copy(
                    currentViewState: self.viewState,
                    currentQuestMaxPages: response.pages.count,
                    correctAnswer: currentPage.code,
                    needsToPay: currentPage.needsToPay,
                    infoData: currentPage.info?.compactMap({ $0.mapToCellConfigurator() }),
                    fetchStatus: .showContent(currentPage.components.compactMap({ $0.mapToCellConfigurator() }))
                )

                self.presenter?.present(viewState: self.viewState)
            } onError: { [weak self] error in
                guard let self = self else { return }

                self.viewState = StoryPageViewState.copy(
                    currentViewState: self.viewState,
                    fetchStatus: .error(error.localizedDescription)
                )

                self.presenter?.present(viewState: self.viewState)
            }.disposed(by: disposeBag)
    }
}
