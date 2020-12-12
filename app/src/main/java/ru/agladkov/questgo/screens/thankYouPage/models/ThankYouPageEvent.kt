package ru.agladkov.questgo.screens.thankYouPage.models

sealed class ThankYouPageEvent {
    object GoToMain : ThankYouPageEvent()
    object ScreenShown : ThankYouPageEvent()
}