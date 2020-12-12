package ru.agladkov.questgo.screens.pay.models

import com.android.billingclient.api.BillingClient

sealed class PayEvent {
    object ScreenShown : PayEvent()
    object BuyQuest : PayEvent()
    data class ScreenResumed(val navigationResult: Boolean) : PayEvent()
}