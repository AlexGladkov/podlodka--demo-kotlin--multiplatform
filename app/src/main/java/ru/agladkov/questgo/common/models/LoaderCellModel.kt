package ru.agladkov.questgo.common.models

import kotlinx.android.parcel.Parcelize

@Parcelize
data class LoaderCellModel(val identifier: Int): ListItem {
    override fun uniqueViewTypeId(): Int {
        return 7
    }
}