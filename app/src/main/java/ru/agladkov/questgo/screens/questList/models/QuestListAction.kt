package ru.agladkov.questgo.screens.questList.models

import ru.agladkov.questgo.screens.questList.adapter.QuestCellModel

sealed class QuestListAction {
    data class OpenQuestInfo(val questCellModel: QuestCellModel) : QuestListAction()
    data class OpenQuestPage(val questId: Int, val questPage: Int) : QuestListAction()
}