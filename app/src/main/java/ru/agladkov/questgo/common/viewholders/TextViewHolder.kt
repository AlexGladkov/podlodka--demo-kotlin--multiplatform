package ru.agladkov.questgo.common.viewholders

import android.view.View
import androidx.appcompat.widget.AppCompatTextView
import androidx.recyclerview.widget.RecyclerView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.TextCellModel

class TextViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
    private val contentTextView: AppCompatTextView = itemView.findViewById(R.id.contentTextView)

    fun bind(model: TextCellModel?) {
        contentTextView.text = model?.value.orEmpty()
    }
}