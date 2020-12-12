package ru.agladkov.questgo.data.features.configuration.sharedprefs

import android.content.Context
import android.content.SharedPreferences
import com.google.gson.Gson
import ru.agladkov.questgo.R
import ru.agladkov.questgo.data.features.configuration.UserConfigurationLocalDataSource
import ru.agladkov.questgo.data.features.configuration.models.UserConfiguration
import javax.inject.Inject

class SharedPreferencesConfigurationLocalDataSource @Inject constructor(
    private val context: Context
) : UserConfigurationLocalDataSource {

    private val configurationKey = "ConfigurationKey"
    private val gson = Gson()

    private var sharedPreferences: SharedPreferences = context.getSharedPreferences(
        context.getString(
            R.string.app_name
        ), 0
    )

    override fun updateConfiguration(configuration: UserConfiguration) {
        sharedPreferences.edit().putString(configurationKey, gson.toJson(configuration)).apply()
    }

    override fun readConfiguration(): UserConfiguration {
        return try {
            val json = sharedPreferences.getString(configurationKey, "")
            gson.fromJson<UserConfiguration>(json, UserConfiguration::class.java)
        } catch (e: Exception) {
            UserConfiguration.getInstance()
        }
    }
}