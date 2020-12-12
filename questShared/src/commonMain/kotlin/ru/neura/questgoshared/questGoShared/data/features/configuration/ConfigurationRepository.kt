package ru.neura.questgoshared.questGoShared.data.features.configuration

import ru.neura.questgoshared.questGoShared.data.features.configuration.models.ConfigurationModel

class ConfigurationRepository(
    private val localDataSource: ConfigurationLocalDataSource,
    private val remoteDataSource: ConfigurationRemoteDataSource = MockConfigurationDataSource()
) {

    suspend fun fetchConfiguration(): ConfigurationModel {
        val remoteConfiguration = remoteDataSource.fetchUserConfiguration()

        return if (remoteConfiguration == null) {
            localDataSource.fetchConfiguration()
        } else {
            localDataSource.storeConfiguration(remoteConfiguration)
            remoteConfiguration
        }
    }

    suspend fun updateConfiguration(model: ConfigurationModel) {
        remoteDataSource.updateConfiguration(model)
        localDataSource.storeConfiguration(model)
    }
}