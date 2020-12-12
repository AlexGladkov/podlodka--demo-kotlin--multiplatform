package ru.agladkov.questgo.data.features.quest.remote.quest

import io.reactivex.Single
import retrofit2.http.*

interface QuestApi {

    @GET("./stub")
    @Headers("Content-Type: application/json")
    fun getQuestList(): Single<QuestListResponse>

    @GET("./stub")
    @Headers("Content-Type: application/json")
    fun getQuest(@Query("questId") questId: Int): Single<QuestResponse>
}