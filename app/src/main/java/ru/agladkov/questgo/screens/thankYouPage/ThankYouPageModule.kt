package ru.agladkov.questgo.screens.thankYouPage

import androidx.lifecycle.ViewModel
import dagger.Binds
import dagger.Module
import dagger.android.ContributesAndroidInjector
import dagger.multibindings.IntoMap
import ru.agladkov.questgo.di.ViewModelKey

@Module
abstract class ThankYouPageModule {

    @Binds
    @IntoMap
    @ViewModelKey(ThankYouPageViewModel::class)
    internal abstract fun thankYouPageViewModel(viewModel: ThankYouPageViewModel): ViewModel

    @ContributesAndroidInjector
    abstract fun thankYouPageFragment(): ThankYouPageFragment
}