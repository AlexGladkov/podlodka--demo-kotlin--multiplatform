//
//  SplashInteractor.swift
//  QuestGo
//
//  Created by Алексей Гладков on 09.12.2020.
//  Copyright © 2020 Алексей Гладков. All rights reserved.
//

import questGoShared

protocol SplashBusinessLogic {
    /// Obtain user actions
    func obtainEvent(event: SplashEvent)
}

protocol SplashDataStoring: class {
    /// Required documentation
}

// MARK: - Splash Data Storing
final class SplashInteractor: SplashDataStoring {

    // MARK: - External vars
    var presenter: SplashPresentationLogic?

    // MARK: Splash Data Storing

    // MARK: Internal vars
    private let userWorker = UserWorker()
    private let configurationRepository = ConfigurationRepository(localDataSource: CommonConfigurationDataSource(),
                                                                  remoteDataSource: MockConfigurationDataSource())
}

// MARK: - Splash Business Logic
extension SplashInteractor: SplashBusinessLogic {

    func obtainEvent(event: SplashEvent) {
        switch event {
        case .initApplication:
            checkPage()
        }
    }

    private func checkPage() {
        self.configurationRepository.fetchConfiguration { [weak self] (configuration, error) in
        guard let self = self, let userConfiguration = configuration else { return }

        if userConfiguration.currentQuestId >= 0 && userConfiguration.currentQuestPage >= 0 {
            self.presenter?.present(action: .openQuestPage(Int(userConfiguration.currentQuestId),
                                                           Int(userConfiguration.currentQuestPage)))
        } else {
            self.presenter?.present(action: .openQuestList)
        }
        }
    }
}
