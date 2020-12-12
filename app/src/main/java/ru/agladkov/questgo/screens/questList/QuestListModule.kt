package ru.agladkov.questgo.screens.questList

import androidx.lifecycle.ViewModel
import dagger.Binds
import dagger.Module
import dagger.multibindings.IntoMap
import ru.agladkov.questgo.di.ViewModelKey

@Module
abstract class QuestListModule {

    @Binds
    @IntoMap
    @ViewModelKey(QuestListViewModel::class)
    internal abstract fun questListViewModel(viewModel: QuestListViewModel): ViewModel
}