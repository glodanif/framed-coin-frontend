import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:framed_coin_frontend/view/common/part/link.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/narrow_container.dart';
import 'package:framed_coin_frontend/domain/transaction.dart';

class TransactionProcess extends StatelessWidget {
  final Transaction transaction;
  final String completedMessage;
  final String buttonLabel;
  final VoidCallback onClick;

  const TransactionProcess({
    super.key,
    required this.transaction,
    required this.completedMessage,
    required this.buttonLabel,
    required this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    return NarrowContainer(
      width: 600.0,
      padding: const EdgeInsets.symmetric(vertical: 36.0, horizontal: 16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          _buildMilestone(
            context: context,
            isInProgress: transaction.isWaitingForUserConfirmation(),
            isPassed: transaction.isSent,
            textBefore: 'Confirm transaction in your Metamask',
            textAfter: 'Transaction confirmed',
          ),
          const SizedBox(height: 24.0),
          _buildMilestone(
            context: context,
            isInProgress: transaction.isSending(),
            isPassed: transaction.isSent,
            textBefore: 'Sending transaction',
            textAfter: 'Transaction sent',
          ),
          if (transaction.isSent)
            Padding(
              padding: const EdgeInsets.only(left: 36.0, top: 8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("Hash:"),
                  Link(
                    text: transaction.hash,
                    uri: Uri.parse(transaction.explorerLink),
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          const SizedBox(height: 24.0),
          _buildMilestone(
            context: context,
            isInProgress: transaction.isWaitingForChainConfirmations(),
            isPassed: transaction.isConfirmed,
            textBefore: 'Waiting for transaction confirmations on chain',
            textAfter: "Transaction confirmed on chain",
          ),
          if (transaction.isConfirmed)
            Container(
              padding: const EdgeInsets.only(left: 36.0, top: 8.0),
              alignment: Alignment.centerLeft,
              child: Text(completedMessage),
            ),
          const SizedBox(height: 36.0),
          if (transaction.isConfirmed)
            MainButton(
              text: buttonLabel,
              onClick: () {
                onClick.call();
              },
            ),
        ],
      ),
    );
  }

  Widget _buildMilestone({
    required BuildContext context,
    required bool isPassed,
    required bool isInProgress,
    required String textBefore,
    required String textAfter,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isInProgress)
          SpinKitRotatingPlain(
            size: 24.0,
            color: Theme.of(context).colorScheme.onBackground,
          )
        else
          Icon(
            isPassed ? Icons.check_circle_outline : Icons.access_time_rounded,
            color: isPassed
                ? Colors.green
                : Theme.of(context).colorScheme.onBackground,
            size: 24.0,
          ),
        const SizedBox(width: 12.0),
        Flexible(child: Text(isPassed ? textAfter : textBefore)),
      ],
    );
  }
}
