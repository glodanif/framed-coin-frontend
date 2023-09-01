import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/domain/minting_settings.dart';
import 'package:framed_coin_frontend/extensions.dart';
import 'package:framed_coin_frontend/view/common/part/back_arrow_button.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/token_input_field.dart';
import 'package:intl/intl.dart';

class MintingFormView extends StatefulWidget {
  final MintingSettings settings;
  final ChainInfo chainInfo;
  final Function(BigInt)? onMintPressed;

  const MintingFormView({
    required this.settings,
    required this.chainInfo,
    this.onMintPressed,
    super.key,
  });

  @override
  State<MintingFormView> createState() => _MintingFormViewState();
}

class _MintingFormViewState extends State<MintingFormView> {
  bool isNotEnough = false;
  String enteredValueToMint = "0";

  @override
  Widget build(BuildContext context) {
    final settings = widget.settings;
    final chainInfo = widget.chainInfo;
    final textTheme = Theme.of(context).textTheme.bodyMedium;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const BackArrowButton(),
        const SizedBox(height: 36.0),
        Text("Mint your NFT", style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 48.0),
        Align(
          alignment: Alignment.centerRight,
          child: Text(
            "Your balance: ${double.parse(settings.userBalance.format18Decimals()).toStringAsFixed(7)} ${chainInfo.tokenName}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        const SizedBox(height: 8.0),
        TokenInputField(
          chainInfo: chainInfo,
          hintText: "Attached value",
          onChanged: (enteredValue) {
            setState(() {
              isNotEnough = false;
              final newValue = num.tryParse(
                  enteredValue.isEmpty ? enteredValueToMint : enteredValue);
              enteredValueToMint = newValue.toString();
            });
          },
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Minimal attached value", style: textTheme),
            Text(
              "${settings.minimumValueToMint.format18Decimals()} ${chainInfo.tokenName}",
              style: isNotEnough
                  ? textTheme?.copyWith(
                      color: Theme.of(context).colorScheme.error,
                    )
                  : textTheme,
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Attached value in USD", style: textTheme),
            Text(
              (double.parse(enteredValueToMint) *
                      double.parse(settings.exchangeRate.format18Decimals()))
                  .toString()
                  .parse18Decimals()
                  .toString()
                  .formatDollars(),
              style: textTheme,
            ),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("${chainInfo.tokenName} price", style: textTheme),
            Text(settings.exchangeRate.formatDollars(), style: textTheme),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mint date", style: textTheme),
            Text(DateFormat('yMd').format(DateTime.now()), style: textTheme),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Mint fee", style: textTheme),
            Text(
                "${settings.mintFee.format18Decimals()} ${chainInfo.tokenName}",
                style: textTheme),
          ],
        ),
        const SizedBox(height: 24.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Total payment", style: textTheme),
            Text(
              "${enteredValueToMint.isEmpty || enteredValueToMint == "0" ? "0" : (enteredValueToMint.parse18Decimals() + BigInt.parse(settings.mintFee)).toString().format18Decimals()} ${chainInfo.tokenName}",
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
        const SizedBox(height: 64.0),
        Builder(
          builder: (context) {
            return SizedBox(
              width: 512.0,
              height: 64.0,
              child: MainButton(
                text: "Mint",
                onClick: () {
                  if (double.parse(enteredValueToMint) <
                      double.parse(
                          settings.minimumValueToMint.format18Decimals())) {
                    setState(() {
                      isNotEnough = true;
                    });
                    return;
                  }
                  widget.onMintPressed?.call(
                    enteredValueToMint.parse18Decimals() +
                        BigInt.parse(settings.mintFee),
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
