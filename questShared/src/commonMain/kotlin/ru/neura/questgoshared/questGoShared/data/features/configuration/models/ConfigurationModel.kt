package ru.neura.questgoshared.questGoShared.data.features.configuration.models

data class ConfigurationModel(
    val currentQuestId: Long,
    val currentQuestPage: Long,
    val boughtQuestIds: List<Long>
)