package ru.agladkov.questgo.screens.questInfo

import androidx.lifecycle.ViewModel
import dagger.Binds
import dagger.Module
import dagger.android.ContributesAndroidInjector
import dagger.multibindings.IntoMap
import ru.agladkov.questgo.di.ViewModelKey

@Module
abstract class QuestInfoModule {

    @Binds
    @IntoMap
    @ViewModelKey(QuestInfoViewModel::class)
    internal abstract fun questInfoViewModel(viewModel: QuestInfoViewModel): ViewModel

    @ContributesAndroidInjector
    abstract fun questInfoFragment(): QuestInfoFragment
}