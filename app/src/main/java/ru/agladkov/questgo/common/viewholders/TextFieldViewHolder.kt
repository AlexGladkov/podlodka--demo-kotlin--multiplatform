package ru.agladkov.questgo.common.viewholders

import android.text.Editable
import android.text.TextWatcher
import android.view.View
import androidx.appcompat.widget.AppCompatEditText
import androidx.recyclerview.widget.RecyclerView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.models.TextFieldCellModel

interface TextFieldCellDelegate {
    fun onTextChanged(newValue: String, model: TextFieldCellModel)
}

class TextFieldViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
    private val textFieldView: AppCompatEditText = itemView.findViewById(R.id.textFieldView)

    var textFieldCellDelegate: TextFieldCellDelegate? = null

    fun bind(model: TextFieldCellModel?) {
        textFieldView.hint = model?.hint.orEmpty()

        textFieldView.addTextChangedListener(object: TextWatcher {
            override fun beforeTextChanged(s: CharSequence?, start: Int, count: Int, after: Int) {

            }

            override fun onTextChanged(s: CharSequence?, start: Int, before: Int, count: Int) {
                model?.let {
                    textFieldCellDelegate?.onTextChanged(s?.toString().orEmpty(), model = model)
                }
            }

            override fun afterTextChanged(s: Editable?) {

            }
        })
    }
}