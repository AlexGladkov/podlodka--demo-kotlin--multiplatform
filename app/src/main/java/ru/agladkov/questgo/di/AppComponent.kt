package ru.agladkov.questgo.di

import android.app.Application
import dagger.BindsInstance
import dagger.Component
import dagger.android.AndroidInjectionModule
import dagger.android.AndroidInjector
import ru.agladkov.QuestApp
import ru.agladkov.questgo.di.modules.*
import ru.agladkov.questgo.screens.pay.PayModule
import ru.agladkov.questgo.screens.promo.PromoModule
import ru.agladkov.questgo.screens.questInfo.QuestInfoModule
import ru.agladkov.questgo.screens.questList.QuestListModule
import ru.agladkov.questgo.screens.questList.QuestListViewModel
import ru.agladkov.questgo.screens.questPage.QuestPageModule
import ru.agladkov.questgo.screens.thankYouPage.ThankYouPageModule

@Component(
    modules = [
        AndroidInjectionModule::class,
        ActivityBindingModule::class,
        ScreenBindingModule::class,
        ViewModelModule::class,
        RemoteModule::class,
        QuestListModule::class,
        QuestPageModule::class,
        QuestInfoModule::class,
        ThankYouPageModule::class,
        RepositoryModule::class,
        PayModule::class,
        AppModule::class,
        PromoModule::class,
        SharedModule::class,
    ]
)
@AppScope
interface AppComponent : AndroidInjector<QuestApp> {

    @Component.Builder
    interface Builder {
        @BindsInstance
        fun application(application: Application): AppComponent.Builder

        fun build(): AppComponent
    }
}