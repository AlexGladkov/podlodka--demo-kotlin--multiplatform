package ru.agladkov.questgo.data.features.quest.remote.promo

import io.reactivex.Single
import retrofit2.http.GET
import retrofit2.http.Headers
import retrofit2.http.Query

interface PromoApi {

    @GET("./stub")
    @Headers("Content-Type: application/json")
    fun getPromo(@Query("code") code: String): Single<PromoResponse>
}