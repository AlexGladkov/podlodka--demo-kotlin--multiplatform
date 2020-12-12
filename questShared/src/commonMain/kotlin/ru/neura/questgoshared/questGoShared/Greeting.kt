package ru.neura.questgoshared.questGoShared


class Greeting {
    fun greeting(): String {
        return "Hello, ${Platform().platform}!"
    }
}
