package ru.agladkov.questgo.screens.questList.models

import ru.agladkov.questgo.screens.questList.adapter.QuestCellModel

sealed class QuestListEvent {
    object FetchInitial : QuestListEvent()
    data class QuestClicks(val questCellModel: QuestCellModel) : QuestListEvent()
}