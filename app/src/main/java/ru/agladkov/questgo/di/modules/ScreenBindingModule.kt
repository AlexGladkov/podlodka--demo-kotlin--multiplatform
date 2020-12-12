package ru.agladkov.questgo.di.modules

import dagger.Module
import dagger.android.ContributesAndroidInjector
import ru.agladkov.questgo.screens.questList.QuestListFragment

@Module
abstract class ScreenBindingModule {

    @ContributesAndroidInjector
    abstract fun questListFragment(): QuestListFragment


}