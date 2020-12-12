package ru.agladkov.questgo.screens.error

import android.os.Bundle
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Button
import android.widget.LinearLayout
import androidx.recyclerview.widget.LinearLayoutManager
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import kotlinx.android.synthetic.main.fragment_error.*
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.VisualComponentsAdapter
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.HeaderCellModel
import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.common.models.TextCellModel
import ru.agladkov.questgo.common.viewholders.ButtonCellDelegate

class ErrorFragment : BottomSheetDialogFragment() {

    private val visualComponentsAdapter = VisualComponentsAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)

        visualComponentsAdapter.buttonCellDelegate = object: ButtonCellDelegate {
            override fun onButtonClick(model: ButtonCellModel) {
                activity?.onBackPressed()
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? = inflater.inflate(R.layout.fragment_error, container, false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)

        val viewData = ArrayList<ListItem>().apply {
            this += HeaderCellModel(getString(R.string.wrong_answer_title))
            this += TextCellModel(getString(R.string.wrong_answer_text))
            this += ButtonCellModel(getString(R.string.action_close))
        }

        itemsView.adapter = visualComponentsAdapter
        itemsView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        visualComponentsAdapter.setItems(viewData)
    }
}