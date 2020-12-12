package ru.agladkov.questgo.screens.fullImage

import android.graphics.Color
import android.os.Bundle
import android.view.View
import android.widget.Toast
import androidx.fragment.app.Fragment
import com.bumptech.glide.Glide
import kotlinx.android.synthetic.main.fragment_full_image.*
import ru.agladkov.questgo.R
import kotlin.math.roundToInt

class FullImageFragment : Fragment(R.layout.fragment_full_image) {

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        Glide.with(fullScreenContentImageView.context)
            .load(arguments?.getString(IMAGE_URL_KEY).orEmpty())
            .into(fullScreenContentImageView)
    }

    companion object {
        const val IMAGE_URL_KEY = "imageUrlKey"
    }
}