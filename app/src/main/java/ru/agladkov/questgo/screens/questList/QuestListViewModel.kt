package ru.agladkov.questgo.screens.questList

import android.os.Handler
import android.os.Looper
import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import androidx.lifecycle.viewModelScope
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import kotlinx.coroutines.launch
import ru.agladkov.questgo.R
import ru.agladkov.questgo.analytics.AnalyticsTracker
import ru.agladkov.questgo.analytics.events.PurchaseEvents
import ru.agladkov.questgo.analytics.events.QuestListEvents
import ru.agladkov.questgo.base.BaseViewModel
import ru.agladkov.questgo.data.features.configuration.UserConfigurationLocalDataSource
import ru.agladkov.questgo.data.features.quest.remote.quest.QuestApi
import ru.agladkov.questgo.screens.questInfo.models.QuestInfoAction
import ru.agladkov.questgo.screens.questInfo.models.QuestInfoEvent
import ru.agladkov.questgo.screens.questInfo.models.QuestInfoViewState
import ru.agladkov.questgo.screens.questList.adapter.QuestCellModel
import ru.agladkov.questgo.screens.questList.adapter.mapToUI
import ru.agladkov.questgo.screens.questList.models.QuestListAction
import ru.agladkov.questgo.screens.questList.models.QuestListEvent
import ru.agladkov.questgo.screens.questList.models.QuestListViewState
import ru.neura.questgoshared.questGoShared.data.features.configuration.ConfigurationRepository
import javax.inject.Inject

class QuestListViewModel @Inject constructor(
    private val questApi: QuestApi,
    private val userConfigurationLocalDataSource: UserConfigurationLocalDataSource,
    private val configurationRepository: ConfigurationRepository,
    private val analyticsTracker: AnalyticsTracker
) : BaseViewModel<QuestListViewState, QuestListAction, QuestListEvent>() {

    private val compositeDisposable = CompositeDisposable()

    init {
        viewState = QuestListViewState.Loading
    }

    override fun onCleared() {
        compositeDisposable.dispose()
        super.onCleared()
    }

    override fun obtainEvent(viewEvent: QuestListEvent) {
        when (viewEvent) {
            is QuestListEvent.FetchInitial -> checkOpenedQuest()
            is QuestListEvent.QuestClicks -> openQuest(model = viewEvent.questCellModel)
        }
    }

    private fun checkOpenedQuest() {
        viewModelScope.launch {
            val userConfiguration = configurationRepository.fetchConfiguration()

            if (userConfiguration.currentQuestId >= 0) {
                viewAction = QuestListAction.OpenQuestPage(
                    questId = userConfiguration.currentQuestId.toInt(),
                    questPage = userConfiguration.currentQuestPage.toInt()
                )
            } else {
                fetchQuestList()
            }
        }
    }

    private fun openQuest(model: QuestCellModel) {
        viewAction = QuestListAction.OpenQuestInfo(questCellModel = model)
    }

    private val maxFetchAttempts = 3
    private var currentFetchAttempt = 0
    private fun fetchQuestList() {
        viewState = QuestListViewState.Loading
        compositeDisposable.add(
            questApi.getQuestList()
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({ response ->
                    currentFetchAttempt = 0

                    with(analyticsTracker) {
                        QuestListEvents.ListLoaded(response.items.count()).track()
                    }

                    viewState = QuestListViewState.Success(response.items.map { it.mapToUI() })
                }, {
                    currentFetchAttempt += 1

                    if (currentFetchAttempt > maxFetchAttempts) {
                        with(analyticsTracker) {
                            QuestListEvents.ListError(attemptsCount = currentFetchAttempt).track()
                        }

                        viewState = QuestListViewState.Error(message = R.string.error_loading_data)
                    } else {
                        Handler(Looper.getMainLooper()).postDelayed({
                            fetchQuestList()
                        }, 5000)
                    }
                })
        )
    }
}