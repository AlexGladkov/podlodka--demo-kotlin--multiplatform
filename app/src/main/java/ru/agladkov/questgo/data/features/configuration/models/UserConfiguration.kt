package ru.agladkov.questgo.data.features.configuration.models

import com.google.gson.JsonArray

data class UserConfiguration(
    val currentUserPage: Int,
    val currentQuestId: Int,
    val availableQuestCount: Int,
    val boughtQuestIdsList: JsonArray
) {

    companion object {
        fun getInstance(): UserConfiguration = UserConfiguration(
            currentUserPage = -1,
            currentQuestId = -1,
            availableQuestCount = 0,
            boughtQuestIdsList = JsonArray()
        )
    }
}