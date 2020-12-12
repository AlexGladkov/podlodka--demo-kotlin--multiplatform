package ru.agladkov.questgo.common.models

import kotlinx.android.parcel.Parcelize

@Parcelize
data class TextFieldCellModel(val hint: String): ListItem {
    override fun uniqueViewTypeId(): Int = 6
}