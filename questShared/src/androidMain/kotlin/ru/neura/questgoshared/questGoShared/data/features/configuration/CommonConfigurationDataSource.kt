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
            .putInt(questIdKey, configurationModel.currentQuestId)
            .putInt(questPageKey, configurationModel.currentQuestPage)
            .putStringSet(boughtQuestIdsKey, configurationModel.boughtQuestIds.map { it.toString() }.toSet())
            .apply()
    }

    override fun fetchConfiguration(): ConfigurationModel {
        return ConfigurationModel(
            currentQuestId = sharedPreferences.getInt(questIdKey, -1),
            currentQuestPage = sharedPreferences.getInt(questPageKey, -1),
            boughtQuestIds = sharedPreferences.getStringSet(boughtQuestIdsKey, emptySet())
                ?.map { it.toInt() } ?: emptyList()
        )
    }
}