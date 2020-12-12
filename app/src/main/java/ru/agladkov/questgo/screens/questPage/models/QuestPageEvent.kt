package ru.agladkov.questgo.screens.questPage.models

import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.Purchase

sealed class QuestPageEvent {
    data class FetchInitial(val questId: Int?, val questPage: Int?) : QuestPageEvent()
    data class SendAnswer(val code: String) : QuestPageEvent()
    data class ScreenResumed(val navigationResult: Boolean?) : QuestPageEvent()
    data class CheckBuyState(val billingClient: BillingClient, val navigationResult: Boolean?) : QuestPageEvent()
    data class HandlePayCode(val billingClient: BillingClient, val billingResult: BillingResult, val purchases: MutableList<Purchase>?) : QuestPageEvent()
    object ShowNextPage : QuestPageEvent()
}