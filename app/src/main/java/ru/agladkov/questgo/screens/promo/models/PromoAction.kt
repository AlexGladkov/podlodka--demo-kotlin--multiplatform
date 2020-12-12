package ru.agladkov.questgo.screens.promo.models

sealed class PromoAction {
    data class ShowError(val message: Int) : PromoAction()
    object ApplyResult : PromoAction()
}