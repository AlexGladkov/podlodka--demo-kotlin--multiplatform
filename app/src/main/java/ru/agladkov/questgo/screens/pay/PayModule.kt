package ru.agladkov.questgo.screens.pay

import androidx.lifecycle.ViewModel
import dagger.Binds
import dagger.Module
import dagger.android.ContributesAndroidInjector
import dagger.multibindings.IntoMap
import ru.agladkov.questgo.di.ViewModelKey

@Module
abstract class PayModule {

    @Binds
    @IntoMap
    @ViewModelKey(PayViewModel::class)
    internal abstract fun payViewModel(viewModel: PayViewModel): ViewModel

    @ContributesAndroidInjector
    abstract fun payFragment(): PayFragment
}