package ru.neura.questgoshared.questGoShared.data.features.configuration

import kotlinx.coroutines.delay
import kotlinx.coroutines.runBlocking
import ru.neura.questgoshared.questGoShared.data.features.configuration.models.ConfigurationModel

class MockConfigurationDataSource: ConfigurationRemoteDataSource {

    override suspend fun fetchUserConfiguration(): ConfigurationModel? {
        runBlocking {
            delay(1000)
        }

        return null
    }

    override suspend fun updateConfiguration(model: ConfigurationModel) {
        runBlocking {
            delay(1000)
        }
    }
}