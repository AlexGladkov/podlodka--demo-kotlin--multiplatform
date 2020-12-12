package ru.agladkov.questgo.data.features.configuration

import ru.agladkov.questgo.data.features.configuration.models.UserConfiguration

interface UserConfigurationLocalDataSource {
    fun updateConfiguration(configuration: UserConfiguration)
    fun readConfiguration(): UserConfiguration
}