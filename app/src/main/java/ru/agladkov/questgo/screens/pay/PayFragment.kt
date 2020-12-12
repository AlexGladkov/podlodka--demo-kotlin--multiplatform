package ru.agladkov.questgo.screens.pay

import android.os.Bundle
import android.util.Log
import android.view.LayoutInflater
import android.view.View
import android.view.ViewGroup
import android.widget.Toast
import androidx.lifecycle.Observer
import androidx.lifecycle.ViewModelProvider
import androidx.navigation.fragment.findNavController
import androidx.recyclerview.widget.LinearLayoutManager
import com.android.billingclient.api.BillingClient
import com.android.billingclient.api.PurchasesUpdatedListener
import com.google.android.material.bottomsheet.BottomSheetDialogFragment
import dagger.android.support.AndroidSupportInjection
import kotlinx.android.synthetic.main.fragment_quest_info.*
import ru.agladkov.questgo.R
import ru.agladkov.questgo.common.VisualComponentsAdapter
import ru.agladkov.questgo.common.models.ButtonCellModel
import ru.agladkov.questgo.common.models.TextButtonCellModel
import ru.agladkov.questgo.common.viewholders.ButtonCellDelegate
import ru.agladkov.questgo.common.viewholders.TextButtonCellDelegate
import ru.agladkov.questgo.helpers.getNavigationResult
import ru.agladkov.questgo.helpers.injectViewModel
import ru.agladkov.questgo.helpers.setNavigationResult
import ru.agladkov.questgo.screens.pay.models.PayAction
import ru.agladkov.questgo.screens.pay.models.PayEvent
import ru.agladkov.questgo.screens.pay.models.PayViewState
import ru.agladkov.questgo.screens.promo.PromoFragment.Companion.PROMO_RESULT_KEY
import javax.inject.Inject

class PayFragment : BottomSheetDialogFragment() {

    @Inject
    lateinit var viewModelFactory: ViewModelProvider.Factory
    lateinit var viewModel: PayViewModel

    private val visualComponentsAdapter = VisualComponentsAdapter()

    override fun onCreate(savedInstanceState: Bundle?) {
        AndroidSupportInjection.inject(this)
        super.onCreate(savedInstanceState)

        visualComponentsAdapter.textButtonCellDelegate = object : TextButtonCellDelegate {
            override fun onButtonClick(model: TextButtonCellModel) {
                findNavController().navigate(R.id.action_payFragment_to_promoFragment)
            }
        }

        visualComponentsAdapter.buttonCellDelegate = object : ButtonCellDelegate {
            override fun onButtonClick(model: ButtonCellModel) {
                viewModel.obtainEvent(PayEvent.BuyQuest)
            }
        }
    }

    override fun onCreateView(
        inflater: LayoutInflater,
        container: ViewGroup?,
        savedInstanceState: Bundle?
    ): View? = inflater.inflate(R.layout.fragment_pay, container, false)

    override fun onViewCreated(view: View, savedInstanceState: Bundle?) {
        super.onViewCreated(view, savedInstanceState)
        viewModel = injectViewModel(factory = viewModelFactory)

        itemsView.adapter = visualComponentsAdapter
        itemsView.layoutManager = LinearLayoutManager(context, LinearLayoutManager.VERTICAL, false)

        viewModel.viewStates().observe(viewLifecycleOwner, Observer { bindViewState(it) })
        viewModel.viewEffects().observe(viewLifecycleOwner, Observer { bindViewAction(it) })
        viewModel.obtainEvent(PayEvent.ScreenShown)

        findNavController().currentBackStackEntry?.savedStateHandle?.getLiveData<Boolean>(
            PROMO_RESULT_KEY
        )?.observe(viewLifecycleOwner, Observer {
            viewModel.obtainEvent(PayEvent.ScreenResumed(it))
        })
    }

    private fun bindViewState(viewState: PayViewState) {
        visualComponentsAdapter.setItems(viewState.renderItems)
    }

    private fun bindViewAction(viewAction: PayAction) {
        when (viewAction) {
            is PayAction.CloseWithResult -> {
                setNavigationResult(PAY_RESULT_KEY, viewAction.isSuccessful)
                setNavigationResult(PAY_STARTING_KEY, viewAction.isStartPay)
                activity?.onBackPressed()
            }

            is PayAction.ShowError -> {
                Toast.makeText(context, getString(viewAction.message), Toast.LENGTH_SHORT).show()
            }
        }
    }

    companion object {
        const val PAY_RESULT_KEY = "payResultKey"
        const val PAY_STARTING_KEY = "payStartingKey"
    }
}