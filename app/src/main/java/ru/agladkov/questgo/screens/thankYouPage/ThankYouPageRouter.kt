package ru.agladkov.questgo.screens.thankYouPage

import android.content.Intent
import androidx.core.content.ContextCompat.startActivity
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.navigation.fragment.findNavController
import ru.agladkov.questgo.R
import ru.agladkov.questgo.screens.fullImage.FullImageFragment.Companion.IMAGE_URL_KEY


interface ThankYouPageRouter {
    // User click to share app
    fun routeToShare()

    // User click go to main
    fun routeToMain()
}

class ThankYouPageRouterImpl(private val fragment: Fragment) : ThankYouPageRouter {
    override fun routeToShare() {
        val textToShare = fragment.resources.getString(R.string.thank_you_page_share_text)
        val sendIntent = Intent()
        sendIntent.action = Intent.ACTION_SEND
        sendIntent.putExtra(
            Intent.EXTRA_TEXT,
            textToShare
        )

        sendIntent.type = "text/plain"
        fragment.activity?.startActivity(sendIntent)
    }

    override fun routeToMain() {
        fragment.findNavController().navigate(R.id.action_thankYouPageFragment_to_questListFragment)
    }
}