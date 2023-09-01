import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/common/part/blocking_text.dart';
import 'package:framed_coin_frontend/view/common/part/error_dialog.dart';
import 'package:framed_coin_frontend/view/common/part/loading_view.dart';
import 'package:framed_coin_frontend/view/common/part/transaction_progress.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/bloc/owner_tools_bloc.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/owner_tools_content.dart';

class OwnerToolsPage extends StatelessWidget with ErrorDialog {
  const OwnerToolsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<OwnerToolsBloc>()..loadContractState(),
      child: BlocConsumer<OwnerToolsBloc, OwnerToolsState>(
        listenWhen: (previous, current) => current is TransactionFailedState,
        listener: (context, state) async {
          final errorState = state as TransactionFailedState;
          await showErrorDialog(context, errorState.error);
          BlocProvider.of<OwnerToolsBloc>(context).loadContractState();
        },
        builder: (context, state) {
          if (state is PauseTxState) {
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Back to Owner Tools",
              completedMessage: "The contract is now PAUSED",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).loadContractState();
              },
            );
          } else if (state is UnPauseTxState) {
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Back to Owner Tools",
              completedMessage: "The contract is now UNPAUSED",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).loadContractState();
              },
            );
          } else if (state is WithdrawFeesTxState) {
            final result = state.tx.result.isEmpty
                ? "0"
                : state.tx.result.format18Decimals();
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Back to Owner Tools",
              completedMessage: "Successfully withdrawn fees: $result",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).loadContractState();
              },
            );
          } else if (state is NewMintFeeTxState) {
            final result = state.tx.result.isEmpty
                ? "0"
                : state.tx.result.format18Decimals();
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Back to Owner Tools",
              completedMessage: "Successfully set new mint fees: $result",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).loadContractState();
              },
            );
          } else if (state is NewMinimumValueToMintTxState) {
            final result = state.tx.result.isEmpty
                ? "0"
                : state.tx.result.format18Decimals();
            return TransactionProcess(
              transaction: state.tx,
              buttonLabel: "Back to Owner Tools",
              completedMessage:
                  "Successfully set new minimum value to mint: $result",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).loadContractState();
              },
            );
          } else if (state is OwnerToolsReceivedState) {
            return OwnerToolsContent(viewModel: state.viewModel);
          } else if (state is UnexpectedErrorState) {
            return BlockingText("Unexpected error\n${state.error.message}");
          } else if (state is NotAuthorizedState) {
            return BlockingText(state.error.message);
          } else {
            return const LoadingView();
          }
        },
      ),
    );
  }
}
