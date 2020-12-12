//
//  QuestPage.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import RxSwift

struct QuestModel {
    struct Fetch { }
    struct List { }
}

extension QuestModel {

    struct QuestComponent: Codable {
        let type: String
        let content: String
    }
}

extension QuestModel.QuestComponent {

    func mapToCellConfigurator() -> CellConfigurator? {
        switch self.type {
        case "text":
            return TableCellConfigurator<TextCell, TextCellModel>(item: .init(text: self.content))
        case "image":
            return TableCellConfigurator<ImageCell, ImageCellModel>(item: .init(imageUrl: URL(string: self.content)))
        case "video":
            return TableCellConfigurator<VideoCell, VideoCellModel>(item: .init(videoId: self.content))
        case "header":
            return TableCellConfigurator<HeaderCell, HeaderCellModel>(item: .init(text: self.content))
        default:
            return nil
        }
    }
}

extension QuestModel.List {
    struct Response: Codable {
        let items: [Quest]

        struct Quest: Codable {
            let questId: Int
            let questName: String
            let questImage: String
            let questSubtitle: String
            let description: [QuestModel.QuestComponent]
        }
    }
}

extension QuestModel.Fetch {

    struct Request {
        let questId: Int
    }

    struct Response: Codable {
        let questId: Int
        let pages: [QuestPage]

        struct QuestPage: Codable {
            let pageId: Int
            let code: String
            let needsToPay: Bool
            let components: [QuestModel.QuestComponent]
            let info: [QuestModel.QuestComponent]?
        }
    }
}
