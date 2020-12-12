package ru.agladkov.questgo.common

import android.view.LayoutInflater
import android.view.ViewGroup
import androidx.recyclerview.widget.RecyclerView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.models.*
import ru.agladkov.questgo.common.viewholders.*

class VisualComponentsAdapter: RecyclerView.Adapter<RecyclerView.ViewHolder>() {

    private val listItems: MutableList<ListItem> = ArrayList()

    var buttonCellDelegate: ButtonCellDelegate? = null
    var imageCellDelegate: ImageCellDelegate? = null
    var textButtonCellDelegate: TextButtonCellDelegate? = null
    var textFieldCellDelegate: TextFieldCellDelegate? = null

    fun setItems(newItems: List<ListItem>) {
        listItems.clear()
        listItems.addAll(newItems)

        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): RecyclerView.ViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        return when (viewType) {
            0 -> ButtonViewHolder(layoutInflater.inflate(R.layout.cell_button, parent, false))
            1 -> HeaderViewHolder(layoutInflater.inflate(R.layout.cell_header, parent, false))
            2 -> ImageViewHolder(layoutInflater.inflate(R.layout.cell_image, parent, false))
            3 -> TextViewHolder(layoutInflater.inflate(R.layout.cell_text, parent, false))
            4 -> VideoViewHolder(layoutInflater.inflate(R.layout.cell_video, parent, false))
            5 -> TextButtonViewHolder(layoutInflater.inflate(R.layout.cell_button_text, parent, false))
            6 -> TextFieldViewHolder(layoutInflater.inflate(R.layout.cell_text_field, parent, false))
            7 -> LoaderViewHolder(layoutInflater.inflate(R.layout.cell_loader, parent, false))
            else -> throw NotImplementedError("You don't implement this $viewType of holder")
        }
    }

    override fun getItemViewType(position: Int): Int = listItems[position].uniqueViewTypeId()

    override fun onBindViewHolder(holder: RecyclerView.ViewHolder, position: Int) {
        when (holder) {
            is ButtonViewHolder -> {
                holder.bind(listItems[position] as? ButtonCellModel)
                holder.buttonCellDelegate = buttonCellDelegate
            }
            is HeaderViewHolder -> holder.bind(listItems[position] as? HeaderCellModel)
            is ImageViewHolder -> {
                holder.bind(listItems[position] as? ImageCellModel)
                holder.imageCellDelegate = imageCellDelegate
            }
            is TextButtonViewHolder -> {
                holder.bind(listItems[position] as? TextButtonCellModel)
                holder.textButtonCellDelegate = textButtonCellDelegate
            }
            is TextViewHolder -> holder.bind(listItems[position] as? TextCellModel)
            is VideoViewHolder -> holder.bind(listItems[position] as? VideoCellModel)
            is TextFieldViewHolder -> {
                holder.bind(listItems[position] as? TextFieldCellModel)
                holder.textFieldCellDelegate = textFieldCellDelegate
            }
        }
    }

    override fun getItemCount(): Int = listItems.count()

}