package ru.agladkov.questgo.data.features.quest.remote.quest

import ru.agladkov.questgo.data.features.quest.remote.common.RemoteListItem

data class QuestResponse(
    val questId: Int,
    val pages: List<QuestPage>
)

data class QuestPage(
    val pageId: Int,
    val code: String,
    val needsToPay: Boolean,
    val components: List<RemoteListItem>,
    val info: List<RemoteListItem>
)