package ru.agladkov.questgo.analytics

import javax.inject.Inject

class Analytics @Inject constructor(
    private val firebaseTracker: FirebaseTracker
) {

    private val stableParams = hashMapOf<String, Any?>()

    fun trackEvent(event: AnalyticsEventFirebase) {
        firebaseTracker.track(event)
    }

    fun updateStableParams(key: String, value: Any?) {
        stableParams[key] = value
        firebaseTracker.setStableParams(stableParams)
    }

    fun updateStableParams(params: Map<String, Any?>) {
        params.forEach { stableParams[it.key] = it.value }
        firebaseTracker.setStableParams(stableParams)
    }
}