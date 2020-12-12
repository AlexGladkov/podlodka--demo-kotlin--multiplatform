package ru.agladkov.questgo.screens.promo

import androidx.lifecycle.ViewModel
import dagger.Binds
import dagger.Module
import dagger.android.ContributesAndroidInjector
import dagger.multibindings.IntoMap
import ru.agladkov.questgo.di.ViewModelKey

@Module
abstract class PromoModule {

    @Binds
    @IntoMap
    @ViewModelKey(PromoViewModel::class)
    internal abstract fun promoViewModel(viewModel: PromoViewModel): ViewModel

    @ContributesAndroidInjector
    abstract fun promoFragment(): PromoFragment
}