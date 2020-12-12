//
//  StoryPageViewState.swift
//  QuestGo
//
//  Created by Алексей Гладков on 06.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

struct StoryPageViewState {
    let currentQuestId: Int
    let currentPage: Int
    let currentQuestMaxPages: Int
    let correctAnswer: String
    let needsToPay: Bool
    let infoData: [CellConfigurator]
    let fetchStatus: StoryPageFetchStatus

    init(currentQuestId: Int = -1,
         currentPage: Int = 0,
         currentQuestMaxPages: Int = 0,
         correctAnswer: String = "",
         needsToPay: Bool = false,
         infoData: [CellConfigurator] = [],
         fetchStatus: StoryPageFetchStatus = .loading) {
        self.currentQuestId = currentQuestId
        self.currentPage = currentPage
        self.currentQuestMaxPages = currentQuestMaxPages
        self.correctAnswer = correctAnswer
        self.needsToPay = needsToPay
        self.infoData = infoData
        self.fetchStatus = fetchStatus
    }

    static func copy(
        currentViewState: StoryPageViewState,
        currentQuestId: Int? = nil,
        currentPage: Int? = nil,
        currentQuestMaxPages: Int? = nil,
        correctAnswer: String? = nil,
        needsToPay: Bool? = nil,
        infoData: [CellConfigurator]? = nil,
        fetchStatus: StoryPageFetchStatus? = nil
    ) -> Self {
        return StoryPageViewState(
            currentQuestId: currentQuestId ?? currentViewState.currentQuestId,
            currentPage: currentPage ?? currentViewState.currentPage,
            currentQuestMaxPages: currentQuestMaxPages ?? currentViewState.currentQuestMaxPages,
            correctAnswer: correctAnswer ?? currentViewState.correctAnswer,
            needsToPay: needsToPay ?? currentViewState.needsToPay,
            infoData: infoData ?? currentViewState.infoData,
            fetchStatus: fetchStatus ?? currentViewState.fetchStatus
        )
    }
}

enum StoryPageFetchStatus {
    case loading
    case error(String)
    case showContent([CellConfigurator])
    case showInfo([CellConfigurator])
}
