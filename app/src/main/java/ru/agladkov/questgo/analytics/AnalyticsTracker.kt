package ru.agladkov.questgo.analytics

import javax.inject.Inject

class AnalyticsTracker @Inject constructor(private val analytics: Analytics) {

    fun AnalyticsEventFirebase.track() = analytics.trackEvent(this)
}