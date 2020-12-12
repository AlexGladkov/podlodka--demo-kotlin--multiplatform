package ru.agladkov.questgo.analytics

abstract class AnalyticsEventFirebase : AnalyticsEvent {
    abstract val name: String
    open var params: Map<String, Any> = emptyMap()
}