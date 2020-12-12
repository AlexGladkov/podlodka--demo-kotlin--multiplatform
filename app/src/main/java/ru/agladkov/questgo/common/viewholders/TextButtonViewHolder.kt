package ru.agladkov.questgo.common.viewholders

import android.view.View
import androidx.appcompat.widget.AppCompatButton
import androidx.appcompat.widget.AppCompatTextView
import androidx.recyclerview.widget.RecyclerView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.TextButtonCellModel

interface TextButtonCellDelegate {
    fun onButtonClick(model: TextButtonCellModel)
}

class TextButtonViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
    private val actionButtonView: AppCompatTextView = itemView.findViewById(R.id.actionButtonView)

    var textButtonCellDelegate: TextButtonCellDelegate? = null

    fun bind(model: TextButtonCellModel?) {
        actionButtonView.text = model?.title.orEmpty()
        actionButtonView.setOnClickListener {
            model?.let {
                textButtonCellDelegate?.onButtonClick(it)
            }
        }
    }
}