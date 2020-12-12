package ru.agladkov.questgo.screens.pay

import android.content.Context
import android.os.Handler
import android.util.Log
import androidx.lifecycle.viewModelScope
import com.android.billingclient.api.*
import kotlinx.coroutines.Dispatchers
import kotlinx.coroutines.launch
import kotlinx.coroutines.withContext
import ru.agladkov.questgo.R
import ru.agladkov.questgo.base.BaseViewModel
import ru.agladkov.questgo.common.models.*
import ru.agladkov.questgo.data.features.configuration.UserConfigurationLocalDataSource
import ru.agladkov.questgo.screens.pay.models.PayAction
import ru.agladkov.questgo.screens.pay.models.PayEvent
import ru.agladkov.questgo.screens.pay.models.PayViewState
import javax.inject.Inject

class PayViewModel @Inject constructor(
    private val context: Context
) : BaseViewModel<PayViewState, PayAction, PayEvent>() {

    init {
        viewState = PayViewState()
    }

    override fun obtainEvent(viewEvent: PayEvent) {
        when (viewEvent) {
            is PayEvent.BuyQuest -> performBuy()
            is PayEvent.ScreenShown -> renderScreen()
            is PayEvent.ScreenResumed -> parsePromoResult(viewEvent.navigationResult)
        }
    }

    private fun parsePromoResult(navigationResult: Boolean) {
        viewAction = PayAction.CloseWithResult(isSuccessful = navigationResult, isStartPay = false)
    }

    private fun renderScreen() {
        val items = ArrayList<ListItem>().apply {
            this += HeaderCellModel(value = context.getString(R.string.start_fragment_end_title))
            this += TextCellModel(value = context.getString(R.string.start_fragment_end_subtitle))
            this += ButtonCellModel(title = context.getString(R.string.action_buy))
            this += TextButtonCellModel(title = context.getString(R.string.action_promo))
        }

        viewState = viewState.copy(
            renderItems = items
        )
    }

    private fun performBuy() {
        viewAction = PayAction.CloseWithResult(isSuccessful = false, isStartPay = true)
    }
}