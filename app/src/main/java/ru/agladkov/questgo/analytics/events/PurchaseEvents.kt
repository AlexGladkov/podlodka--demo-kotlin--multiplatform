package ru.agladkov.questgo.analytics.events

import ru.agladkov.questgo.analytics.AnalyticsEventFirebase

sealed class PurchaseEvents(
    override val name: String,
    override var params: Map<String, Any>
) : AnalyticsEventFirebase() {

    data class PurchaseSucceed(val questId: Int) : PurchaseEvents(
        name = "main_purchase_success_bought",
        params = HashMap<String, Any>().apply {
            put("questId", questId)
        }
    )

    data class PurchaseCanceled(val questId: Int) : PurchaseEvents(
        name = "main_purchase_canceled",
        params = HashMap<String, Any>().apply {
            put("questId", questId)
        }
    )

    data class PurchaseError(val questId: Int, val message: String) : PurchaseEvents(
        name = "main_error_purchase_loading",
        params = HashMap<String, Any>().apply {
            put("questId", questId)
            put("message", message)
        }
    )
}