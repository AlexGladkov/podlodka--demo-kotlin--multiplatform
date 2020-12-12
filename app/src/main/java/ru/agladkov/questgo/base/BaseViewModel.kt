package ru.agladkov.questgo.base

import androidx.lifecycle.LiveData
import androidx.lifecycle.MutableLiveData
import androidx.lifecycle.ViewModel
import ru.agladkov.questgo.helpers.SingleLiveAction

abstract class BaseViewModel<S, A, E>: ViewModel() {

    private val TAG = BaseViewModel::class.java.simpleName
    private val _viewStates: MutableLiveData<S> = MutableLiveData()
    fun viewStates(): LiveData<S> = _viewStates

    private var _viewState: S? = null
    protected var viewState: S
        get() = _viewState
            ?: throw UninitializedPropertyAccessException("\"viewState\" was queried before being initialized")
        set(value) {
            _viewState = value
            _viewStates.postValue(value)
        }


    private val _viewActions: SingleLiveAction<A> = SingleLiveAction()
    fun viewEffects(): SingleLiveAction<A> = _viewActions

    private var _viewAction: A? = null
    protected var viewAction: A
        get() = _viewAction
            ?: throw UninitializedPropertyAccessException("\"viewAction\" was queried before being initialized")
        set(value) {
            _viewAction = value
            _viewActions.postValue(value)
        }

    abstract fun obtainEvent(viewEvent: E)
}