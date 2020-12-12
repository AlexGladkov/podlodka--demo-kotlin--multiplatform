package ru.agladkov.questgo.analytics.events

import ru.agladkov.questgo.analytics.AnalyticsEventFirebase

sealed class QuestPageEvents(
    override val name: String,
    override var params: Map<String, Any>
) : AnalyticsEventFirebase() {

    data class PageLoaded(val questId: Int, val questPage: Int) : QuestPageEvents(
        name = "main_page_loaded",
        params = HashMap<String, Any>().apply {
            put("questId", questId)
            put("questPage", questPage)
        }
    )

    data class InfoLoaded(val questId: Int, val questPage: Int) : QuestPageEvents(
        name = "main_info_loaded",
        params = HashMap<String, Any>().apply {
            put("questId", questId)
            put("questPage", questPage)
        }
    )
}