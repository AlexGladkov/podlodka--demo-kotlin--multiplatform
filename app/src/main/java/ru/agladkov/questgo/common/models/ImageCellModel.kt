package ru.agladkov.questgo.common.models

import android.os.Parcelable
import kotlinx.android.parcel.Parcelize

@Parcelize
data class ImageCellModel(val value: String): ListItem, Parcelable {
    override fun uniqueViewTypeId(): Int = 2
}