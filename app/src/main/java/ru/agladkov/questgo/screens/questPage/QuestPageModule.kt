package ru.agladkov.questgo.screens.questPage

import androidx.lifecycle.ViewModel
import dagger.Binds
import dagger.Module
import dagger.android.ContributesAndroidInjector
import dagger.multibindings.IntoMap
import ru.agladkov.questgo.di.ViewModelKey
import ru.agladkov.questgo.screens.questList.QuestListFragment

@Module
abstract class QuestPageModule {

    @Binds
    @IntoMap
    @ViewModelKey(QuestPageViewModel::class)
    internal abstract fun questPageViewModel(viewModel: QuestPageViewModel): ViewModel

    @ContributesAndroidInjector
    abstract fun questPageFragment(): QuestPageFragment
}