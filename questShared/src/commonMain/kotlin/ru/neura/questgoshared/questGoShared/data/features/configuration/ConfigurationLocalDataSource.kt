package ru.neura.questgoshared.questGoShared.data.features.configuration

import ru.neura.questgoshared.questGoShared.data.features.configuration.models.ConfigurationModel

interface ConfigurationLocalDataSource {
    fun storeConfiguration(configurationModel: ConfigurationModel)
    fun fetchConfiguration(): ConfigurationModel

    companion object {
        const val questIdKey = "QUEST_ID_KEY"
        const val questPageKey = "QUEST_PAGE_KEY"
        const val boughtQuestIdsKey = "BOUGHT_QUEST_ID_KEY"
    }
}