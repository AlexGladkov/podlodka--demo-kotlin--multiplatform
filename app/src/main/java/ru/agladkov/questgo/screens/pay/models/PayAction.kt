package ru.agladkov.questgo.screens.pay.models

import com.android.billingclient.api.BillingFlowParams

sealed class PayAction {
    data class CloseWithResult(val isSuccessful: Boolean, val isStartPay: Boolean) : PayAction()
    data class ShowError(val message: Int) : PayAction()
}