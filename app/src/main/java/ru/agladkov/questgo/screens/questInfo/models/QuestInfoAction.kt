package ru.agladkov.questgo.screens.questInfo.models

sealed class QuestInfoAction {
    data class OpenQuest(val questId: Int, val questPage: Int) : QuestInfoAction()
    data class ShowError(val message: Int) : QuestInfoAction()
}