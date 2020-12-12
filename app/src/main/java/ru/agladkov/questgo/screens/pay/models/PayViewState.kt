package ru.agladkov.questgo.screens.pay.models

import ru.agladkov.questgo.common.models.ListItem

data class PayViewState(
    val isBuying: Boolean = false,
    val renderItems: List<ListItem> = emptyList()
)