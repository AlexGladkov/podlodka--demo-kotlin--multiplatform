package ru.agladkov.questgo.common.models

import android.os.Parcelable
import ru.agladkov.questgo.data.features.quest.remote.common.RemoteListItem

interface ListItem : Parcelable {
    fun uniqueViewTypeId(): Int
}

fun RemoteListItem.mapToUI(): ListItem {
    return when (this.type) {
        "header" -> HeaderCellModel(value = this.content)
        "text" -> TextCellModel(value = this.content)
        "image" -> ImageCellModel(value = this.content)
        "video" -> VideoCellModel(value = this.content)
        "button" -> ButtonCellModel(title = this.content)
        else -> throw NotImplementedError("This UI not implemented")
    }
}