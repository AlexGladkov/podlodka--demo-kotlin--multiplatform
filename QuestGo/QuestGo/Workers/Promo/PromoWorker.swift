//
//  PromoWorker.swift
//  QuestGo
//
//  Created by Алексей Гладков on 08.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class PromoWorker {

    private let developApiKey = ""
    private let publicApiKey = ""

    func checkPromo(code: String) -> Single<PromoResponse> {
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

                if let result: PromoResponse = data.decode() {
                    single(.success(result))
                } else {
                    single(.error(NetworkError.encodingFailed))
                }
            })

            return Disposables.create()
        }
    }
}
