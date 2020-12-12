package ru.agladkov.questgo.screens.questList.adapter

import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import androidx.appcompat.widget.AppCompatImageView
import androidx.appcompat.widget.AppCompatTextView
import androidx.recyclerview.widget.RecyclerView
import com.bumptech.glide.Glide
import ru.agladkov.questgo.R

interface QuestListAdapterClicks {
    fun onItemClick(model: QuestCellModel)
}

class QuestListAdapter : RecyclerView.Adapter<QuestListAdapter.QuestViewHolder>() {

    private val items: MutableList<QuestCellModel> = ArrayList()
    private var questListAdapterClicks: QuestListAdapterClicks? = null

    fun attachClicks(questListAdapterClicks: QuestListAdapterClicks) {
        this.questListAdapterClicks = questListAdapterClicks
    }

    fun setItems(newItems: List<QuestCellModel>) {
        items.clear()
        items.addAll(newItems)

        notifyDataSetChanged()
    }

    override fun onCreateViewHolder(parent: ViewGroup, viewType: Int): QuestViewHolder {
        val layoutInflater = LayoutInflater.from(parent.context)
        return QuestViewHolder(layoutInflater.inflate(R.layout.cell_quest, parent, false))
    }

    override fun onBindViewHolder(holder: QuestViewHolder, position: Int) {
        holder.bind(items[position])

        holder.itemView.setOnClickListener {
            questListAdapterClicks?.onItemClick(items[position])
        }
    }

    override fun getItemCount(): Int = items.count()

    class QuestViewHolder(itemView: View) : RecyclerView.ViewHolder(itemView) {
        private val imageView: AppCompatImageView = itemView.findViewById(R.id.questImageView)
        private val titleView: AppCompatTextView = itemView.findViewById(R.id.titleTextView)
        private val subtitleView: AppCompatTextView = itemView.findViewById(R.id.subtitleTextView)

        fun bind(model: QuestCellModel) {
            titleView.text = model.title
            subtitleView.text = model.subtitle

            Glide
                .with(imageView)
                .load(model.image)
                .into(imageView)
        }
    }
}