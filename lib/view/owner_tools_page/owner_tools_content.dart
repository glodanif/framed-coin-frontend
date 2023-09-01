import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/view/common/part/column_divider.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/row_divider.dart';
import 'package:framed_coin_frontend/view/common/part/token_input_field.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/bloc/owner_tools_bloc.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/convert/owner_tools_view_model.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class OwnerToolsContent extends StatefulWidget {
  final OwnerToolsViewModel viewModel;

  const OwnerToolsContent({
    required this.viewModel,
    super.key,
  });

  @override
  State<OwnerToolsContent> createState() => _OwnerToolsContentState();
}

class _OwnerToolsContentState extends State<OwnerToolsContent> {
  String enteredMintFee = "";
  String enteredMinimumValueTooMint = "";

  @override
  Widget build(BuildContext context) {
    final viewModel = widget.viewModel;
    final scaledPadding =
        ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)
            ? 16.0
            : 64.0;
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(scaledPadding),
        child: ResponsiveBreakpoints.of(context).smallerOrEqualTo(TABLET)
            ? Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  _buildFeesView(viewModel),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    child: RowDivider(),
                  ),
                  _buildStatusView(viewModel),
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 18.0),
                    child: RowDivider(),
                  ),
                  _buildPauseStatusView(viewModel.isPaused),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildFeesView(viewModel),
                  const SizedBox(height: 512.0, child: ColumnDivider()),
                  _buildStatusView(viewModel),
                  const SizedBox(height: 512.0, child: ColumnDivider()),
                  _buildPauseStatusView(viewModel.isPaused),
                ],
              ),
      ),
    );
  }

  Widget _buildStatusView(OwnerToolsViewModel viewModel) {
    final bodyLarge = Theme.of(context).textTheme.bodyLarge;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Current token counter: ${viewModel.tokenCounter}",
          style: bodyLarge,
        ),
        const SizedBox(height: 12.0),
        Text(
          "Current exchange rate: ${viewModel.exchangeRateFormatted}",
          style: bodyLarge,
        ),
        const SizedBox(height: 12.0),
        Text(
          "Total NFTs value: ${viewModel.totalNftsValueFormatted} ${viewModel.tokenLabel}",
          style: bodyLarge,
        ),
        const SizedBox(height: 36.0),
        Text("Mint fee:", style: bodyLarge),
        Row(
          children: [
            SizedBox(
              height: 78.0,
              width: 224.0,
              child: TokenInputField(
                chainInfo: viewModel.chainInfo,
                hintText: "Mint fee",
                prefilledValue: viewModel.mintFeeFormatted,
                onChanged: (enteredValue) {
                  enteredMintFee = enteredValue;
                },
              ),
            ),
            const SizedBox(width: 12.0),
            MainButton(
              text: "Set",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context)
                    .setNewMintFee(enteredMintFee.parse18Decimals().toString());
              },
            ),
          ],
        ),
        const SizedBox(height: 36.0),
        Text("Minimum value to mint:", style: bodyLarge),
        Row(
          children: [
            SizedBox(
              height: 78.0,
              width: 224.0,
              child: TokenInputField(
                chainInfo: viewModel.chainInfo,
                hintText: "Minimum value to mint",
                prefilledValue: viewModel.minimumValueToMintFormatted,
                onChanged: (enteredValue) {
                  enteredMinimumValueTooMint = enteredValue;
                },
              ),
            ),
            const SizedBox(width: 12.0),
            MainButton(
              text: "Set",
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context)
                    .setNewMinimumValueToMint(enteredMinimumValueTooMint
                        .parse18Decimals()
                        .toString());
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFeesView(OwnerToolsViewModel viewModel) {
    return Column(
      children: [
        Text(
          "Available fees: ${viewModel.availableFeesFormatted} ${viewModel.tokenLabel}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24.0),
        MainButton(
          isEnabled: viewModel.availableFeesFormatted != "0",
          text: "Withdraw",
          onClick: () {
            BlocProvider.of<OwnerToolsBloc>(context).withdrawFees();
          },
        ),
      ],
    );
  }

  Widget _buildPauseStatusView(bool isPaused) {
    return Column(
      children: [
        Text(
          "Status: ${isPaused ? "PAUSED" : "RUNNING"}",
          style: Theme.of(context).textTheme.bodyLarge,
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            MainButton(
              text: "Pause",
              isEnabled: !isPaused,
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).pause();
              },
            ),
            MainButton(
              text: "Unpause",
              isEnabled: isPaused,
              onClick: () {
                BlocProvider.of<OwnerToolsBloc>(context).unPause();
              },
            ),
          ],
        ),
      ],
    );
  }
}
