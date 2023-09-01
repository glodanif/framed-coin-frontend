import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:framed_coin_frontend/domain/chain.dart';

class TokenInputField extends StatefulWidget {
  final ChainInfo chainInfo;
  final String hintText;
  final String prefilledValue;
  final Function(String)? onChanged;

  const TokenInputField({
    super.key,
    required this.chainInfo,
    required this.hintText,
    this.prefilledValue = "",
    this.onChanged,
  });

  @override
  State<TokenInputField> createState() => _TokenInputFieldState();
}

class _TokenInputFieldState extends State<TokenInputField> {
  final textController = TextEditingController();

  @override
  void initState() {
    textController.text = widget.prefilledValue;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: const BorderRadius.all(Radius.circular(18.0)),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              inputFormatters: [
                FilteringTextInputFormatter.allow(
                  RegExp(r'^\d+([.,]?\d{0,18})?$'),
                ),
              ],
              controller: textController,
              onChanged: (text) {
                setState(() {
                  final text = textController.text.replaceAll(",", ".");
                  final enteredNumber =
                      num.tryParse(text.isEmpty ? "0" : text).toString();
                  widget.onChanged?.call(enteredNumber);
                });
              },
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                hintText: widget.hintText,
                border: InputBorder.none,
              ),
            ),
          ),
          const SizedBox(width: 18.0),
          Image.asset(
            widget.chainInfo.tokenIcon,
            height: 32.0,
            width: 32.0,
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    textController.dispose();
    super.dispose();
  }
}
