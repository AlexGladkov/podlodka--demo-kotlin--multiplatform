package ru.neura.questgoshared.questGoShared.data.features.configuration

import android.content.Context
import android.content.SharedPreferences
import ru.neura.questgoshared.questGoShared.data.features.configuration.ConfigurationLocalDataSource.Companion.boughtQuestIdsKey
import ru.neura.questgoshared.questGoShared.data.features.configuration.ConfigurationLocalDataSource.Companion.questIdKey
import ru.neura.questgoshared.questGoShared.data.features.configuration.ConfigurationLocalDataSource.Companion.questPageKey
import ru.neura.questgoshared.questGoShared.data.features.configuration.models.ConfigurationModel

class CommonConfigurationDataSource(private val context: Context): ConfigurationLocalDataSource {

    private val sharedPreferences: SharedPreferences = context.getSharedPreferences("APP_KEY", 0)

    override fun storeConfiguration(configurationModel: ConfigurationModel) {
        sharedPreferences.edit()
            .putLong(questIdKey, configurationModel.currentQuestId)
            .putLong(questPageKey, configurationModel.currentQuestPage)
            .putStringSet(boughtQuestIdsKey, configurationModel.boughtQuestIds.map { it.toString() }.toSet())
            .apply()
    }

    override fun fetchConfiguration(): ConfigurationModel {
        return ConfigurationModel(
            currentQuestId = sharedPreferences.getLong(questIdKey, -1),
            currentQuestPage = sharedPreferences.getLong(questPageKey, -1),
            boughtQuestIds = sharedPreferences.getStringSet(boughtQuestIdsKey, emptySet())
                ?.map { it.toLong() } ?: emptyList()
        )
    }
}