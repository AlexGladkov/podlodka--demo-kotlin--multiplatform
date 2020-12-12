package ru.neura.questgoshared.questGoShared.data.features.configuration

import ru.neura.questgoshared.questGoShared.data.features.configuration.models.ConfigurationModel

interface ConfigurationRemoteDataSource {
    suspend fun fetchUserConfiguration(): ConfigurationModel?
    suspend fun updateConfiguration(model: ConfigurationModel)
}