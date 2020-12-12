package ru.agladkov.questgo.helpers

import androidx.fragment.app.Fragment
import androidx.lifecycle.LiveData
import androidx.navigation.fragment.findNavController

fun <T> Fragment.getNavigationResult(key: String): T? =
    findNavController().currentBackStackEntry?.savedStateHandle?.getLiveData<T>(key)?.value

fun <T> Fragment.setNavigationResult(key: String, value: T) =
    findNavController().previousBackStackEntry?.savedStateHandle?.set(key, value)

fun <T> Fragment.getNavigationLiveData(key: String): LiveData<T>? =
    findNavController().currentBackStackEntry?.savedStateHandle?.getLiveData<T>(key)
