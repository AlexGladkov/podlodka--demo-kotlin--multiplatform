package ru.agladkov.questgo.screens.questPage

import android.util.Log
import android.widget.Button
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import com.android.billingclient.api.*
import com.google.gson.Gson
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ru.agladkov.questgo.R
import ru.agladkov.questgo.analytics.AnalyticsTracker
import ru.agladkov.questgo.analytics.events.PurchaseEvents
import ru.agladkov.questgo.analytics.events.QuestPageEvents
import ru.agladkov.questgo.base.BaseViewModel
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.common.models.mapToUI
import ru.agladkov.questgo.data.features.configuration.UserConfigurationLocalDataSource
import ru.agladkov.questgo.data.features.quest.remote.quest.QuestApi
import ru.agladkov.questgo.screens.pay.models.PayAction
import ru.agladkov.questgo.screens.questPage.models.QuestPageAction
import ru.agladkov.questgo.screens.questPage.models.QuestPageEvent
import ru.agladkov.questgo.screens.questPage.models.QuestPageFetchStatus
import ru.agladkov.questgo.screens.questPage.models.QuestPageViewState
import java.lang.Exception
import javax.inject.Inject

sealed class QuestPageError {
    object RequestException : QuestPageError()
    object WrongAnswerException : QuestPageError()
}

class QuestPageViewModel @Inject constructor(
    private val questApi: QuestApi,
    private val localDataSource: UserConfigurationLocalDataSource,
    private val gson: Gson,
    private val analyticsTracker: AnalyticsTracker
) : BaseViewModel<QuestPageViewState, QuestPageAction, QuestPageEvent>() {

    private val compositeDisposable = CompositeDisposable()

    private val _items: MutableLiveData<List<ListItem>> = MutableLiveData(emptyList())

    val items: LiveData<List<ListItem>> = _items

    init {
        viewState = QuestPageViewState()
    }

    override fun onCleared() {
        compositeDisposable.dispose()
        super.onCleared()
    }

    override fun obtainEvent(viewEvent: QuestPageEvent) {
        when (viewEvent) {
            is QuestPageEvent.FetchInitial -> fetchPage(viewEvent.questId, viewEvent.questPage)
            is QuestPageEvent.SendAnswer -> checkAnswer(viewEvent.code)
            is QuestPageEvent.ShowNextPage -> checkNextPageAvailable()
            is QuestPageEvent.ScreenResumed -> checkPayResult(viewEvent.navigationResult)
            is QuestPageEvent.CheckBuyState -> performBuy(
                viewEvent.billingClient,
                viewEvent.navigationResult
            )
            is QuestPageEvent.HandlePayCode -> handlePayCode(
                viewEvent.billingClient,
                viewEvent.billingResult,
                viewEvent.purchases
            )
        }
    }


    private fun fetchPage(questId: Int?, questPage: Int?) {
        if (questId == null) {
            // Fallback to error
            return
        }

        viewState = viewState.copy(
            fetchStatus = QuestPageFetchStatus.Loading,
            currentQuestId = questId,
            currentPage = questPage ?: 0
        )

        compositeDisposable.add(
            questApi.getQuest(questId)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ response ->
                    viewState = try {
                        val currentPage = response.pages[viewState.currentPage]
                        val currentConfiguration = localDataSource.readConfiguration()
                        localDataSource.updateConfiguration(
                            currentConfiguration.copy(
                                currentQuestId = viewState.currentQuestId,
                                currentUserPage = viewState.currentPage
                            )
                        )

                        with(analyticsTracker) {
                            QuestPageEvents.PageLoaded(
                                questId = viewState.currentQuestId,
                                questPage = viewState.currentPage
                            ).track()
                        }

                        viewState.copy(
                            infoData = currentPage.info.map { it.mapToUI() },
                            currentQuestMaxPages = response.pages.count(),
                            correctAnswer = currentPage.code,
                            needsToPay = currentPage.needsToPay,
                            fetchStatus = QuestPageFetchStatus.ShowContent(
                                items = currentPage.components.map { it.mapToUI() }
                            )
                        )
                    } catch (e: Exception) {
                        viewState.copy(
                            fetchStatus = QuestPageFetchStatus.Error(QuestPageError.RequestException)
                        )
                    }
                }, {
                    viewState = viewState.copy(
                        fetchStatus = QuestPageFetchStatus.Error(QuestPageError.RequestException)
                    )
                })
        )
    }

    private fun handlePayCode(
        billingClient: BillingClient,
        billingResult: BillingResult,
        purchases: MutableList<Purchase>?
    ) {
        when (billingResult.responseCode) {
            BillingClient.BillingResponseCode.OK -> {
                purchases?.forEach {
                    finishPurchase(it, billingClient)
                }

                var currentUserConfiguration = localDataSource.readConfiguration()
                val currentQuestIds = currentUserConfiguration.boughtQuestIdsList
                currentQuestIds.add(viewState.currentQuestId)
                currentUserConfiguration = currentUserConfiguration.copy(
                    boughtQuestIdsList = currentQuestIds
                )

                with(analyticsTracker) {
                    PurchaseEvents.PurchaseSucceed(questId = viewState.currentQuestId).track()
                }

                localDataSource.updateConfiguration(currentUserConfiguration)

                viewAction = QuestPageAction.ShowError(R.string.successfull_bought)
                viewState = viewState.copy(needsToPay = false)
                checkNextPageAvailable()
            }
            BillingClient.BillingResponseCode.USER_CANCELED -> {
                with(analyticsTracker) {
                    PurchaseEvents.PurchaseCanceled(questId = viewState.currentQuestId).track()
                }

                viewAction =
                    QuestPageAction.ShowError(R.string.error_pay_canceled)
            }
            else -> viewAction = QuestPageAction.ShowError(R.string.error_pay_in_app)
        }
    }

    private fun finishPurchase(purchase: Purchase, billingClient: BillingClient) {
        val consumeParams =
            ConsumeParams.newBuilder()
                .setPurchaseToken(purchase.purchaseToken)
                .build()

        billingClient.consumeAsync(consumeParams) { billingResult, _ ->
            if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                // Handle the success of the consume operation.
            }
        }
    }

    private fun performBuy(billingClient: BillingClient, needsToBuy: Boolean?) {
        if (needsToBuy != true) return

        billingClient.startConnection(object : BillingClientStateListener {
            override fun onBillingSetupFinished(billingResult: BillingResult) {
                Log.e("TAG", "Billing -> start")
                if (billingResult.responseCode == BillingClient.BillingResponseCode.OK) {
                    Log.e("TAG", "Billing -> success")
                    val skuList = ArrayList<String>()
                    skuList.add("ru.quest.once")
                    val params = SkuDetailsParams.newBuilder()
                    params.setSkusList(skuList).setType(BillingClient.SkuType.INAPP)

                    viewModelScope.launch {
                        val skuDetailsResult = withContext(Dispatchers.IO) {
                            billingClient.querySkuDetails(params.build())
                        }

                        Log.e("TAG", "Billing -> list ${skuDetailsResult.skuDetailsList?.count()}")
                        val questSkuDetails = skuDetailsResult.skuDetailsList?.firstOrNull()
                        Log.e("TAG", "Billing -> details ${questSkuDetails?.price}")

                        viewAction = if (questSkuDetails == null) {
                            with(analyticsTracker) {
                                PurchaseEvents.PurchaseError(
                                    questId = viewState.currentQuestId,
                                    message = "error_pay_no_items"
                                ).track()
                            }

                            QuestPageAction.ShowError(R.string.error_pay_no_items)
                        } else {
                            val flowParams = BillingFlowParams.newBuilder()
                                .setSkuDetails(questSkuDetails)
                                .build()

                            QuestPageAction.ShowPayFlow(params = flowParams)
                        }
                    }
                } else {
                    with(analyticsTracker) {
                        PurchaseEvents.PurchaseError(
                            questId = viewState.currentQuestId,
                            message = "error_pay_code"
                        ).track()
                    }

                    viewAction = QuestPageAction.ShowError(message = R.string.error_pay_code)
                }
            }

            override fun onBillingServiceDisconnected() {
                with(analyticsTracker) {
                    PurchaseEvents.PurchaseError(
                        questId = viewState.currentQuestId,
                        message = "error_pay"
                    ).track()
                }

                viewAction = QuestPageAction.ShowError(message = R.string.error_pay)
            }
        })
    }

    private fun checkNextPageAvailable() {
        viewAction = if (viewState.currentQuestMaxPages == viewState.currentPage + 1) {
            QuestPageAction.OpenFinalPage
        } else {
            if (viewState.needsToPay && !localDataSource.readConfiguration()
                    .boughtQuestIdsList.contains(gson.toJsonTree(viewState.currentQuestId))
            ) {
                QuestPageAction.OpenPayPage
            } else {
                QuestPageAction.OpenNextPage(
                    questId = viewState.currentQuestId,
                    questPage = viewState.currentPage + 1
                )
            }
        }
    }

    private fun checkPayResult(isSuccessful: Boolean?) {
        if (isSuccessful == true) {
            viewAction = QuestPageAction.OpenNextPage(
                questId = viewState.currentQuestId,
                questPage = viewState.currentPage + 1
            )
        }
    }

    private fun checkAnswer(text: String) {
        viewState = if (text.equals(viewState.correctAnswer, ignoreCase = true)) {
            val currentInfoBlock = viewState.infoData.toMutableList()

            with(analyticsTracker) {
                QuestPageEvents.InfoLoaded(
                    questId = viewState.currentQuestId,
                    questPage = viewState.currentPage
                ).track()
            }

            viewState.copy(
                fetchStatus = QuestPageFetchStatus.ShowInfo(currentInfoBlock.apply {
                    this += ButtonCellModel("Продолжить")
                })
            )
        } else {
            viewState.copy(
                fetchStatus = QuestPageFetchStatus.Error(QuestPageError.WrongAnswerException)
            )
        }
    }
}