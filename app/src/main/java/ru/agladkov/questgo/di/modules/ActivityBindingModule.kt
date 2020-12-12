package ru.agladkov.questgo.di.modules

import dagger.Module
import dagger.android.ContributesAndroidInjector
import ru.agladkov.questgo.MainActivity

@Module
abstract class ActivityBindingModule {

    @ContributesAndroidInjector
    abstract fun mainActivity(): MainActivity
}