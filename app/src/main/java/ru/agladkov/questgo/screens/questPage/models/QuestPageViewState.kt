package ru.agladkov.questgo.screens.questPage.models

import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.screens.questPage.QuestPageError

data class QuestPageViewState(
    val currentQuestId: Int = -1,
    val currentPage: Int = 0,
    val currentQuestMaxPages: Int = 0,
    val correctAnswer: String = "",
    val needsToPay: Boolean = false,
    val infoData: List<ListItem> = emptyList(),
    val fetchStatus: QuestPageFetchStatus = QuestPageFetchStatus.Loading
)

sealed class QuestPageFetchStatus {
    object Loading : QuestPageFetchStatus()
    data class Error(val error: QuestPageError) : QuestPageFetchStatus()
    data class ShowContent(val items: List<ListItem>) : QuestPageFetchStatus()
    data class ShowInfo(val items: List<ListItem>) : QuestPageFetchStatus()
}