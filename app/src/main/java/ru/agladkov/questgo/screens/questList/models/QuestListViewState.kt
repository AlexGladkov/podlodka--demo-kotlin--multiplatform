package ru.agladkov.questgo.screens.questList.models

import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.screens.questList.adapter.QuestCellModel

sealed class QuestListViewState {
    data class Success(val items: List<QuestCellModel>) : QuestListViewState()
    data class Error(val message: Int) : QuestListViewState()
    object Loading : QuestListViewState()
}