package ru.agladkov.questgo.data.features.quest.remote.quest

import com.google.gson.annotations.SerializedName
import ru.agladkov.questgo.data.features.quest.remote.common.RemoteListItem

data class QuestListResponse(val items: List<QuestListItem>)

data class QuestListItem(
    @SerializedName("questId")
    val questId: Int,

    @SerializedName("questName")
    val name: String,

    @SerializedName("questSubtitle")
    val subtitle: String,

    @SerializedName("questImage")
    val image: String,

    @SerializedName("description")
    val items: List<RemoteListItem>
)