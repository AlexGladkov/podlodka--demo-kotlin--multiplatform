package ru.agladkov.questgo.analytics.events

import ru.agladkov.questgo.analytics.AnalyticsEventFirebase

sealed class QuestListEvents(
    override val name: String,
    override var params: Map<String, Any>
) : AnalyticsEventFirebase() {

    data class ListLoaded(val questCount: Int) : QuestListEvents(
        name = "main_page_loaded",
        params = HashMap<String, Any>().apply {
            put("questCount", questCount)
        }
    )

    data class ListError(val attemptsCount: Int) : QuestListEvents(
        name = "main_error_page_loaded",
        params = HashMap<String, Any>().apply {
            put("attemptsCount", attemptsCount)
        }
    )
}