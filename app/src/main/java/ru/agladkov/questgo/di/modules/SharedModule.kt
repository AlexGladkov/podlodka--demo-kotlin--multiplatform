package ru.agladkov.questgo.di.modules

import android.content.Context
import dagger.Module
import dagger.Provides
import ru.neura.questgoshared.questGoShared.data.features.configuration.CommonConfigurationDataSource
import ru.neura.questgoshared.questGoShared.data.features.configuration.ConfigurationRepository
import ru.neura.questgoshared.questGoShared.data.features.configuration.MockConfigurationDataSource

@Module
class SharedModule {

    @Provides
    fun provideConfigurationRepository(context: Context): ConfigurationRepository =
        ConfigurationRepository(
            localDataSource = CommonConfigurationDataSource(context),
            remoteDataSource = MockConfigurationDataSource()
        )
}