package ru.agladkov.questgo.screens.questPage

import android.app.Activity
import android.os.Bundle
import android.util.Log
import android.view.View
import android.view.inputmethod.InputMethodManager
import android.widget.Toast
import androidx.core.os.bundleOf
import androidx.fragment.app.Fragment
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.PurchasesUpdatedListener
import dagger.android.support.AndroidSupportInjection
import kotlinx.android.synthetic.main.fragment_quest_page.*
import kotlinx.android.synthetic.main.fragment_quest_page.itemsView
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.VisualComponentsAdapter
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.ImageCellModel
import ru.agladkov.questgo.common.models.ListItem
import ru.agladkov.questgo.common.viewholders.ButtonCellDelegate
import ru.agladkov.questgo.common.viewholders.ImageCellDelegate
import ru.agladkov.questgo.helpers.getNavigationLiveData
import ru.agladkov.questgo.helpers.injectViewModel
import ru.agladkov.questgo.screens.fullImage.FullImageFragment.Companion.IMAGE_URL_KEY
import ru.agladkov.questgo.screens.pay.PayFragment
import ru.agladkov.questgo.screens.pay.models.PayEvent
import ru.agladkov.questgo.screens.promo.PromoFragment
import ru.agladkov.questgo.screens.questPage.models.QuestPageAction
import ru.agladkov.questgo.screens.questPage.models.QuestPageEvent
import ru.agladkov.questgo.screens.questPage.models.QuestPageFetchStatus
import ru.agladkov.questgo.screens.questPage.models.QuestPageViewState
import ru.agladkov.questgo.screens.thankYouPage.models.ThankYouPageEvent
import javax.inject.Inject

class QuestPageFragment : Fragment(R.layout.fragment_quest_page) {

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory
    lateinit var viewModel: QuestPageViewModel

    private val purchasesUpdatedListener =
        PurchasesUpdatedListener { billingResult, purchases ->
            viewModel.obtainEvent(
                QuestPageEvent.HandlePayCode(
                    billingResult = billingResult,
                    purchases = purchases,
                    billingClient = billingClient
                )
            )
        }

    private lateinit var billingClient: BillingClient

    private val visualComponentsAdapter = VisualComponentsAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        AndroidSupportInjection.inject(this)
        super.onCreate(savedInstanceState)

        visualComponentsAdapter.buttonCellDelegate = object : ButtonCellDelegate {
            override fun onButtonClick(model: ButtonCellModel) {
                viewModel.obtainEvent(QuestPageEvent.ShowNextPage)
            }
        }

        visualComponentsAdapter.imageCellDelegate = object : ImageCellDelegate {
            override fun onImageClick(model: ImageCellModel) {
                routeToFullImage(model)
            }
        }
    }

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = injectViewModel(factory = viewModelFactory)


        itemsView.adapter = visualComponentsAdapter
        itemsView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        sendButtonView.setOnClickListener {
            viewModel.obtainEvent(QuestPageEvent.SendAnswer(answerTextFieldView.text.toString()))
        }

        answerTextFieldView.setOnEditorActionListener { _, _, _ ->
            viewModel.obtainEvent(QuestPageEvent.SendAnswer(answerTextFieldView.text.toString()))
            true
        }

        viewModel.viewStates().observe(viewLifecycleOwner, Observer { bindViewState(it) })
        viewModel.viewEffects().observe(viewLifecycleOwner, Observer { bindViewAction(it) })
        viewModel.obtainEvent(
            QuestPageEvent.FetchInitial(
                questPage = arguments?.getInt(PAGE_ID),
                questId = arguments?.getInt(QUEST_ID)
            )
        )

        setupBillingSystem()

        getNavigationLiveData<Boolean>(PayFragment.PAY_RESULT_KEY)?.observe(
            viewLifecycleOwner,
            Observer {
                viewModel.obtainEvent(QuestPageEvent.ScreenResumed(it))
            })

        getNavigationLiveData<Boolean>(PayFragment.PAY_STARTING_KEY)?.observe(
            viewLifecycleOwner,
            Observer {
                viewModel.obtainEvent(
                    QuestPageEvent.CheckBuyState(
                        billingClient = billingClient,
                        navigationResult = it
                    )
                )
            })
    }

    private fun setupBillingSystem() {
        activity?.let {
            billingClient = BillingClient.newBuilder(it)
                .setListener(purchasesUpdatedListener)                .enablePendingPurchases()
                .build()
        }
    }

    private fun bindViewAction(viewAction: QuestPageAction) {
        when (viewAction) {
            is QuestPageAction.OpenNextPage -> routeToNextPage(
                questId = viewAction.questId,
                questPage = viewAction.questPage
            )

            is QuestPageAction.ShowError -> Toast.makeText(
                context,
                getString(viewAction.message),
                Toast.LENGTH_SHORT
            ).show()

            is QuestPageAction.ShowPayFlow -> {
                activity?.let {
                    val responseCode =
                        billingClient.launchBillingFlow(it, viewAction.params).responseCode
                }
            }

            is QuestPageAction.OpenFinalPage -> routeToThankYouPage()
            is QuestPageAction.OpenPayPage -> routeToPayPage()
        }
    }

    private fun bindViewState(viewState: QuestPageViewState) {
        when (val status = viewState.fetchStatus) {
            is QuestPageFetchStatus.Loading -> performLoading()
            is QuestPageFetchStatus.Error -> performError(error = status.error)
            is QuestPageFetchStatus.ShowInfo -> performShowingInfo(info = status.items)
            is QuestPageFetchStatus.ShowContent -> performShowingContent(content = status.items)
        }
    }

    private fun performLoading() {
        pageLoaderView.visibility = View.VISIBLE
        itemsView.visibility = View.GONE
        answerHolderCardView.visibility = View.GONE
    }

    private fun performShowingContent(content: List<ListItem>) {
        itemsView.visibility = View.VISIBLE
        answerHolderCardView.visibility = View.VISIBLE
        pageLoaderView.visibility = View.GONE

        visualComponentsAdapter.setItems(content)
    }

    private fun performShowingInfo(info: List<ListItem>) {
        itemsView.visibility = View.VISIBLE
        answerHolderCardView.visibility = View.GONE
        pageLoaderView.visibility = View.GONE

        visualComponentsAdapter.setItems(info)

        val imm: InputMethodManager? =
            context?.getSystemService(Activity.INPUT_METHOD_SERVICE) as? InputMethodManager
        imm?.hideSoftInputFromWindow(view?.windowToken, 0)

        itemsView.smoothScrollToPosition(0)
    }

    private fun performError(error: QuestPageError) {
        when (error) {
            is QuestPageError.RequestException -> Log.e("TAG", "Some loading error")
            is QuestPageError.WrongAnswerException -> findNavController().navigate(R.id.action_questPageFragment_to_errorFragment)
        }
    }

    private fun routeToNextPage(questId: Int, questPage: Int) {
        findNavController().navigate(
            R.id.action_questPageFragment_self,
            bundleOf(
                QUEST_ID to questId,
                PAGE_ID to questPage
            )
        )
    }

    private fun routeToThankYouPage() {
        findNavController().navigate(
            R.id.action_questPageFragment_to_thankYouPageFragment
        )
    }

    private fun routeToFullImage(model: ImageCellModel) {
        findNavController().navigate(
            R.id.action_questPageFragment_to_fullImageFragment,
            bundleOf(IMAGE_URL_KEY to model.value)
        )
    }

    private fun routeToPayPage() {
        findNavController().navigate(
            R.id.action_questPageFragment_to_payFragment
        )
    }

    companion object {
        const val QUEST_ID = "questIDKey"
        const val PAGE_ID = "pageIDKey"
    }
}