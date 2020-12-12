package ru.agladkov.questgo.screens.questPage.models

import com.android.billingclient.api.BillingFlowParams

sealed class QuestPageAction {
    data class OpenNextPage(val questId: Int, val questPage: Int): QuestPageAction()
    data class ShowError(val message: Int) : QuestPageAction()
    data class ShowPayFlow(val params: BillingFlowParams) : QuestPageAction()
    object OpenFinalPage : QuestPageAction()
    object OpenPayPage : QuestPageAction()
}