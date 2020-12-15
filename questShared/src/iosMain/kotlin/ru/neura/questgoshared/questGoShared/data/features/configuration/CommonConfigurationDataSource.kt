package ru.neura.questgoshared.questGoShared.data.features.configuration

import platform.Foundation.NSString
import platform.Foundation.NSUserDefaults
import platform.Foundation.valueForKey
import platform.darwin.NSInteger
import ru.neura.questgoshared.questGoShared.data.features.configuration.models.ConfigurationModel

class CommonConfigurationDataSource: ConfigurationLocalDataSource {

    private val userDefaults = NSUserDefaults.standardUserDefaults()

    override fun storeConfiguration(configurationModel: ConfigurationModel) {
        userDefaults.setInteger(configurationModel.currentQuestId.toLong(), questIdKey)
        userDefaults.setInteger(configurationModel.currentQuestPage.toLong(), questPageKey)
        userDefaults.setObject(configurationModel.boughtQuestIds
            .map { it.toString() }.joinToString { " " }, boughtQuestIdsKey)
    }

    override fun fetchConfiguration(): ConfigurationModel {
        val questId = userDefaults.valueForKey(questIdKey) as? NSInteger
        val questPage = userDefaults.valueForKey(questPageKey) as? NSInteger
        val boughtQuests = (userDefaults.valueForKey(boughtQuestIdsKey) as? NSString ?: "").toString()

        return ConfigurationModel(
            currentQuestId = questId?.toInt() ?: -1,
            currentQuestPage = questPage?.toInt() ?: -1,
            boughtQuestIds = if (boughtQuests.isEmpty()) {
                emptyList()
            } else {
                boughtQuests.split(" ").map { it.toInt() }
            }
        )
    }

    companion object {
        const val questIdKey = "QUEST_ID_KEY"
        const val questPageKey = "QUEST_PAGE_KEY"
        const val boughtQuestIdsKey = "BOUGHT_QUEST_ID_KEY"
    }
}