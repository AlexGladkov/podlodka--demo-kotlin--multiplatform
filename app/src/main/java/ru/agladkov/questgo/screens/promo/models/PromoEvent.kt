package ru.agladkov.questgo.screens.promo.models

sealed class PromoEvent {
    data class CodeChanges(val newValue: String) : PromoEvent()
    object ApplyCode: PromoEvent()
    object RenderScreen : PromoEvent()
}