package ru.agladkov.questgo.analytics

import android.content.Context
import android.os.Bundle
import android.util.Log
import com.google.firebase.analytics.FirebaseAnalytics
import javax.inject.Inject

class FirebaseTracker @Inject constructor(val context: Context) {

    private val firebaseAnalytics: FirebaseAnalytics by lazy { FirebaseAnalytics.getInstance(context) }

    fun track(event: AnalyticsEventFirebase) {
        firebaseAnalytics.logEvent(
            event.name,
            Bundle().apply {
                event.params.forEach { (key, value) ->
                    Log.e("TAG", "key = $key value = ${value.javaClass.simpleName} $value")
                    when (value) {
                        is String -> putString(key, value)
                        is Boolean -> putString(key, value.toString())
                        is Double -> putDouble(key, value)
                        is Float -> putFloat(key, value)
                        is Int -> putInt(key, value)
                        else -> error("Unexpected parameter type: ${value.javaClass} for parameter: '$key' event: '${event.name}'")
                    }
                }
            }
        )
    }

    fun setStableParams(stableParams: Map<String, Any?>) {
        stableParams.forEach {
            firebaseAnalytics.setUserProperty(it.key, it.value.toString())
        }
    }
}