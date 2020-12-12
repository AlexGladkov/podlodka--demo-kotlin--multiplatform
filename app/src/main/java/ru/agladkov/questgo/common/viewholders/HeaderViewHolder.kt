package ru.agladkov.questgo.common.viewholders

import android.view.View
import androidx.appcompat.widget.AppCompatTextView
import androidx.recyclerview.widget.RecyclerView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.HeaderCellModel

class HeaderViewHolder(itemView: View): RecyclerView.ViewHolder(itemView) {
    private val headerTextView: AppCompatTextView = itemView.findViewById(R.id.headerTextView)

    fun bind(model: HeaderCellModel?) {
        headerTextView.text = model?.value.orEmpty()
    }
}