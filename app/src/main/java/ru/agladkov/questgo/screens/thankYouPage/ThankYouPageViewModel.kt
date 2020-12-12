package ru.agladkov.questgo.screens.thankYouPage

import ru.agladkov.questgo.base.BaseViewModel
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.HeaderCellModel
import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.common.models.TextCellModel
import ru.agladkov.questgo.data.features.configuration.UserConfigurationLocalDataSource
import ru.agladkov.questgo.screens.thankYouPage.models.ThankYouPageAction
import ru.agladkov.questgo.screens.thankYouPage.models.ThankYouPageEvent
import ru.agladkov.questgo.screens.thankYouPage.models.ThankYouPageViewState
import javax.inject.Inject

class ThankYouPageViewModel @Inject constructor(
    private val userConfigurationLocalDataSource: UserConfigurationLocalDataSource
) : BaseViewModel<ThankYouPageViewState, ThankYouPageAction, ThankYouPageEvent>() {

    override fun obtainEvent(viewEvent: ThankYouPageEvent) {
        when (viewEvent) {
            is ThankYouPageEvent.ScreenShown -> renderScreen()
            is ThankYouPageEvent.GoToMain -> clearHistoryAndOpenMain()
        }
    }

    private fun renderScreen() {
        val visualComponents = ArrayList<ListItem>().apply {
            this += HeaderCellModel("Поздравляем!")
            this += TextCellModel("Вы успешно завершили прохождение квеста. Надеюсь, вам понравилось. Вы также можете поделиться своими впечатлениями с друзьями, отправив им ссылку на квест! Спасибо, что были с нами")
            this += ButtonCellModel("Поделиться")
        }

        viewState = ThankYouPageViewState(screenRender = visualComponents)
    }

    private fun clearHistoryAndOpenMain() {
        val currentConfiguration = userConfigurationLocalDataSource.readConfiguration()
        userConfigurationLocalDataSource.updateConfiguration(
            currentConfiguration.copy(
                currentQuestId = -1,
                currentUserPage = -1
            )
        )

        viewAction = ThankYouPageAction.OpenMainScreen
    }
}