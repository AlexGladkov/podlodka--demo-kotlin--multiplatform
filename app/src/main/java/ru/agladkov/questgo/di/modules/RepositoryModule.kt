package ru.agladkov.questgo.di.modules

import dagger.Binds
import dagger.Module
import ru.agladkov.questgo.data.features.configuration.UserConfigurationLocalDataSource
import ru.agladkov.questgo.data.features.configuration.sharedprefs.SharedPreferencesConfigurationLocalDataSource

@Module
abstract class RepositoryModule {

    @Binds
    abstract fun bindUserConfigurationDataSource(
        sharedPreferencesConfigurationLocalDataSource:
        SharedPreferencesConfigurationLocalDataSource
    ): UserConfigurationLocalDataSource
}