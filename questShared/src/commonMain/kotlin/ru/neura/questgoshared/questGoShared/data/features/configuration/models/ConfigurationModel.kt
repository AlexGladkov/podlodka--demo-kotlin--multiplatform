package ru.neura.questgoshared.questGoShared.data.features.configuration.models

data class ConfigurationModel(
    val currentQuestId: Int,
    val currentQuestPage: Int,
    val boughtQuestIds: List<Int>
)