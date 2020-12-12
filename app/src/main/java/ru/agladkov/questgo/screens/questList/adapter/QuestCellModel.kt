package ru.agladkov.questgo.screens.questList.adapter

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize
import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.common.models.mapToUI
import ru.agladkov.questgo.data.features.quest.remote.quest.QuestListItem

@Parcelize
data class QuestCellModel(
    val questId: Int, val title: String, val subtitle: String, val image: String,
    val description: List<ListItem>
) : Parcelable

fun QuestListItem.mapToUI(): QuestCellModel {
    return QuestCellModel(
        questId = this.questId,
        title = this.name,
        subtitle = this.subtitle,
        image = this.image,
        description = this.items.map { it.mapToUI() }
    )
}