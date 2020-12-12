package ru.agladkov.questgo.screens.questList

import android.os.Bundle
import android.view.View
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import dagger.android.support.AndroidSupportInjection
import kotlinx.android.synthetic.main.fragment_quest_list.*
import ru.agladkov.questgo.R
import ru.agladkov.questgo.helpers.injectViewModel
import ru.agladkov.questgo.screens.questInfo.QuestInfoFragment
import ru.agladkov.questgo.screens.questList.adapter.QuestCellModel
import ru.agladkov.questgo.screens.questList.adapter.QuestListAdapter
import ru.agladkov.questgo.screens.questList.adapter.QuestListAdapterClicks
import ru.agladkov.questgo.screens.questList.models.QuestListAction
import ru.agladkov.questgo.screens.questList.models.QuestListEvent
import ru.agladkov.questgo.screens.questList.models.QuestListViewState
import ru.agladkov.questgo.screens.questPage.QuestPageFragment.Companion.PAGE_ID
import ru.agladkov.questgo.screens.questPage.QuestPageFragment.Companion.QUEST_ID
import javax.inject.Inject

class QuestListFragment : Fragment(R.layout.fragment_quest_list) {

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory
    lateinit var viewModel: QuestListViewModel

    private val questListAdapter = QuestListAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        AndroidSupportInjection.inject(this)
        super.onCreate(savedInstanceState)

        questListAdapter.attachClicks(object : QuestListAdapterClicks {
            override fun onItemClick(model: QuestCellModel) {
                routeToQuest(model = model)
            }
        })
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = injectViewModel(factory = viewModelFactory)

        itemsView.adapter = questListAdapter
        itemsView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        viewModel.viewStates().observe(viewLifecycleOwner, Observer { bindViewState(it) })
        viewModel.viewEffects().observe(viewLifecycleOwner, Observer { bindViewAction(it) })
        viewModel.obtainEvent(QuestListEvent.FetchInitial)
    }

    private fun bindViewState(viewState: QuestListViewState) {
        when (viewState) {
            is QuestListViewState.Loading -> {
                itemsView.visibility = View.GONE
                loaderView.visibility = View.VISIBLE
            }

            is QuestListViewState.Success -> {
                questListAdapter.setItems(viewState.items)
                itemsView.visibility = View.VISIBLE
                loaderView.visibility = View.GONE
            }

            is QuestListViewState.Error -> {
                // fallback to error
            }
        }
    }

    private fun bindViewAction(viewAction: QuestListAction) {
        when (viewAction) {
            is QuestListAction.OpenQuestInfo -> routeToQuest(viewAction.questCellModel)
            is QuestListAction.OpenQuestPage -> routeToQuestPage(
                viewAction.questId,
                viewAction.questPage
            )
        }
    }

    private fun routeToQuestPage(questId: Int, questPage: Int) {
        findNavController().navigate(
            R.id.action_questListFragment_to_questPageFragment,
            bundleOf(
                QUEST_ID to questId,
                PAGE_ID to questPage
            )
        )
    }

    private fun routeToQuest(model: QuestCellModel) {
        findNavController().navigate(
            R.id.action_questListFragment_to_questInfoFragment,
            bundleOf(QuestInfoFragment.QUEST to model)
        )
    }
}