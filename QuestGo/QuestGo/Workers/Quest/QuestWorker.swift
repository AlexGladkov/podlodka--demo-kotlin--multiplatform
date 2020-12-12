//
//  QuestWorker.swift
//  QuestGo
//
//  Created by Алексей Гладков on 18.08.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class QuestWorker {

    private let developApiKey = ""
    private let publicApiKey = ""

    func fetchQuestList() -> Single<QuestModel.List.Response> {
        return .create { [weak self] single in
            AF.request("",
                       headers: [
                        HTTPHeader(name: "Content-Type", value: "application/json"),
                        HTTPHeader(name: "apiKey", value: self?.publicApiKey ?? "")
                       ])
                .responseData(completionHandler: { response in

                    guard (response.response?.statusCode) != nil else {
                        single(.error(NetworkError.timeout))
                        return
                    }

                    guard let data = response.data else {
                        single(.error(NetworkError.serverError))
                        return
                    }

                    if let result: QuestModel.List.Response = data.decode() {
                        single(.success(result))
                    } else {
                        single(.error(NetworkError.encodingFailed))
                    }
                })

            return Disposables.create()
        }
    }

    func fetchQuest(request: QuestModel.Fetch.Request) -> Single<QuestModel.Fetch.Response> {
        return .create { [weak self] single in
            AF.request("",
                       headers: [
                        HTTPHeader(name: "Content-Type", value: "application/json"),
                        HTTPHeader(name: "apiKey", value: self?.publicApiKey ?? "")
                       ])
            .responseData(completionHandler: { response in

                guard (response.response?.statusCode) != nil else {
                    single(.error(NetworkError.timeout))
                    return
                }

                guard let data = response.data else {
                    single(.error(NetworkError.serverError))
                    return
                }

                if let result: QuestModel.Fetch.Response = data.decode() {
                    single(.success(result))
                } else {
                    single(.error(NetworkError.encodingFailed))
                }
            })

            return Disposables.create()
        }
    }
}
