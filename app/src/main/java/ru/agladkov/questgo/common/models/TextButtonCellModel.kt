package ru.agladkov.questgo.common.models

import kotlinx.android.parcel.Parcelize

@Parcelize
data class TextButtonCellModel(val title: String) : ListItem {
    override fun uniqueViewTypeId(): Int = 5
}