package ru.agladkov.questgo.screens.promo

import android.content.Context
import androidx.loader.content.Loader
import io.reactivex.android.schedulers.AndroidSchedulers
import io.reactivex.disposables.CompositeDisposable
import io.reactivex.schedulers.Schedulers
import ru.agladkov.questgo.R
import ru.agladkov.questgo.base.BaseViewModel
import ru.agladkov.questgo.common.models.*
import ru.agladkov.questgo.data.features.quest.remote.promo.PromoApi
import ru.agladkov.questgo.screens.promo.models.PromoAction
import ru.agladkov.questgo.screens.promo.models.PromoEvent
import ru.agladkov.questgo.screens.promo.models.PromoViewState
import javax.inject.Inject

class PromoViewModel @Inject constructor(
    private val promoApi: PromoApi,
    private val context: Context
) : BaseViewModel<PromoViewState, PromoAction, PromoEvent>() {

    private val compositeDisposable = CompositeDisposable()

    init {
        viewState = PromoViewState()
    }

    override fun onCleared() {
        compositeDisposable.clear()
        super.onCleared()
    }

    override fun obtainEvent(viewEvent: PromoEvent) {
        when (viewEvent) {
            is PromoEvent.CodeChanges -> viewState = viewState.copy(code = viewEvent.newValue)
            is PromoEvent.ApplyCode -> performApply()
            is PromoEvent.RenderScreen -> renderScreen()
        }
    }

    private fun renderScreen() {
        val renderData = ArrayList<ListItem>().apply {
            this += HeaderCellModel(value = context.getString(R.string.promo_title))
            this += TextFieldCellModel(hint = context.getString(R.string.promo_hint))
            this += ButtonCellModel(title = context.getString(R.string.promo_buy))
        }

        viewState = viewState.copy(renderData = renderData)
    }

    private fun setSending(sendingStatus: Boolean) {
        val currentRender = viewState.renderData.toMutableList()
        when (sendingStatus) {
            true -> {
                currentRender.removeAll { it is ButtonCellModel }
                currentRender.add(LoaderCellModel(identifier = 0))
            }

            else -> {
                currentRender.removeAll { it is LoaderCellModel }
                currentRender.add(ButtonCellModel(title = context.getString(R.string.promo_buy)))
            }
        }

        viewState = viewState.copy(renderData = currentRender)
    }

    private fun performApply() {
        setSending(true)

        compositeDisposable.add(
            promoApi.getPromo(code = viewState.code)
                .subscribeOn(Schedulers.io())
                .observeOn(AndroidSchedulers.mainThread())
                .subscribe({
                    viewAction = if (it.isValid) {
                        PromoAction.ApplyResult
                    } else {
                        setSending(false)
                        PromoAction.ShowError(message = R.string.promo_not_valid)
                    }
                }, {
                    setSending(false)
                    viewAction = PromoAction.ShowError(message = R.string.promo_error)
                })
        )
    }
}