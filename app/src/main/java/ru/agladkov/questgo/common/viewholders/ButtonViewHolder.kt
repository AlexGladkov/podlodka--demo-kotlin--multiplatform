package ru.agladkov.questgo.common.viewholders

import android.view.View
import androidx.appcompat.widget.AppCompatButton
import androidx.recyclerview.widget.RecyclerView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.models.ButtonCellModel

interface ButtonCellDelegate {
    fun onButtonClick(model: ButtonCellModel)
}

class ButtonViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
    private val actionButtonView: AppCompatButton = itemView.findViewById(R.id.actionButtonView)

    var buttonCellDelegate: ButtonCellDelegate? = null

    fun bind(model: ButtonCellModel?) {
        actionButtonView.text = model?.title.orEmpty()
        actionButtonView.setOnClickListener {
            model?.let {
                buttonCellDelegate?.onButtonClick(it)
            }
        }
    }
}