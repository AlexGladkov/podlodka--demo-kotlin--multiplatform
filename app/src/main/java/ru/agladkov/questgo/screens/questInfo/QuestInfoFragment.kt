package ru.agladkov.questgo.screens.questInfo

import android.os.Bundle
import android.view.View
import android.widget.Button
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.BillingClientStateListener
import com.android.billingclient.api.BillingResult
import com.android.billingclient.api.PurchasesUpdatedListener
import dagger.android.support.AndroidSupportInjection
import kotlinx.android.synthetic.main.cell_button.*
import kotlinx.android.synthetic.main.fragment_quest_info.*
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.VisualComponentsAdapter
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.common.models.TextButtonCellModel
import ru.agladkov.questgo.common.viewholders.ButtonCellDelegate
import ru.agladkov.questgo.common.viewholders.TextButtonCellDelegate
import ru.agladkov.questgo.helpers.injectViewModel
import ru.agladkov.questgo.screens.questInfo.models.QuestInfoAction
import ru.agladkov.questgo.screens.questInfo.models.QuestInfoEvent
import ru.agladkov.questgo.screens.questInfo.models.QuestInfoViewState
import ru.agladkov.questgo.screens.questList.adapter.QuestCellModel
import ru.agladkov.questgo.screens.questPage.QuestPageFragment.Companion.PAGE_ID
import ru.agladkov.questgo.screens.questPage.QuestPageFragment.Companion.QUEST_ID
import ru.agladkov.questgo.screens.questPage.QuestPageViewModel
import javax.inject.Inject

class QuestInfoFragment : Fragment(R.layout.fragment_quest_info) {

    private val visualComponentsAdapter = VisualComponentsAdapter()

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory
    lateinit var viewModel: QuestInfoViewModel

    override fun onCreate(savedInstanceState: Bundle?) {
        AndroidSupportInjection.inject(this)
        super.onCreate(savedInstanceState)

        visualComponentsAdapter.buttonCellDelegate = object : ButtonCellDelegate {
            override fun onButtonClick(model: ButtonCellModel) {
                viewModel.obtainEvent(QuestInfoEvent.BuyQuest)
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = injectViewModel(factory = viewModelFactory)

        itemsView.adapter = visualComponentsAdapter
        itemsView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        viewModel.viewStates().observe(viewLifecycleOwner, Observer { bindViewState(it) })
        viewModel.viewEffects().observe(viewLifecycleOwner, Observer { bindViewAction(it) })
        viewModel.obtainEvent(
            QuestInfoEvent.StartBillingConnection(
                questCellModel = arguments?.get(QUEST) as? QuestCellModel
            )
        )
    }

    private fun bindViewAction(viewAction: QuestInfoAction) {
        when (viewAction) {
            is QuestInfoAction.OpenQuest -> routeToQuest(
                questId = viewAction.questId,
                questPage = viewAction.questPage
            )

            is QuestInfoAction.ShowError -> {
                Toast.makeText(context, getString(viewAction.message), Toast.LENGTH_SHORT).show()
            }
        }
    }

    private fun bindViewState(viewState: QuestInfoViewState) {
        when {
            viewState.isLoading -> {
                itemsView.visibility = View.GONE
                loaderView.visibility = View.VISIBLE
            }

            !viewState.isLoading -> {
                itemsView.visibility = View.VISIBLE
                loaderView.visibility = View.GONE
                visualComponentsAdapter.setItems(viewState.visualItems)
            }
        }
    }

    private fun routeToQuest(questId: Int, questPage: Int) {
        findNavController().navigate(
            R.id.action_questInfoFragment_to_questPageFragment,
            bundleOf(
                QUEST_ID to questId,
                PAGE_ID to questPage
            )
        )
    }

    companion object {
        const val QUEST = "quest_key"
    }
}