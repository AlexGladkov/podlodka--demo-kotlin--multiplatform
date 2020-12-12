//
//  StoryPagePresenter.swift
//  QuestGo
//
//  Created by Алексей Гладков on 16.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation

protocol StoryPagePresentationLogic {
    /// Present loaded data
    func present(response: QuestModel.Fetch.Response, questPage: Int)

    /// Present user sent wrong code
    func presentWrongCode()

    /// Present finish quest
    func presentFinish()

    /// Present loading
    func present(loadingState: Bool)

    /// Present single action
    func present(action: StoryPageAction)

    /// Present new view state
    func present(viewState: StoryPageViewState)
}

final class StoryPagePresenter {
    // MARK: External vars
    weak var viewController: StoryPageDisplayLogic?
}

// MARK: - StoryPage Presentation Logic
extension StoryPagePresenter: StoryPagePresentationLogic {

    func present(loadingState: Bool) {
        viewController?.display(loadingState: loadingState)
    }

    func present(action: StoryPageAction) {
        viewController?.display(action: action)
    }

    func present(viewState: StoryPageViewState) {
        viewController?.display(viewState: viewState)
    }

    func presentWrongCode() {
        viewController?.displayWrongCode()
    }

    func presentFinish() {
        viewController?.displayFinishPage()
    }

    func present(response: QuestModel.Fetch.Response, questPage: Int) {
        guard questPage < response.pages.count else {
            viewController?.displayFinishPage()
            return
        }

        var components = [CellConfigurator]()

        response.pages[questPage].components.forEach { component in
            switch component.type {
            case "text":
                components.append(TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: component.content)))
            case "image":
                components.append(TableCellConfigurator<ImageCell, ImageCellModel>(item: .init(imageUrl: URL(string: component.content))))
            case "video":
                components.append(TableCellConfigurator<VideoCell, VideoCellModel>(item: .init(videoId: component.content)))
            case "header":
                components.append(TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: component.content)))
            default:
                break
            }
        }

        viewController?.display(content: components)
    }
}
