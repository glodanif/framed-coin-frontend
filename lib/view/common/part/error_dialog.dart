import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/domain/js_layer_error.dart';
import 'package:framed_coin_frontend/view/common/part/dialog_background.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:google_fonts/google_fonts.dart';

mixin ErrorDialog {
  Future<void> showErrorDialog(
    BuildContext context,
    JsLayerError error,
  ) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          elevation: 0.0,
          contentPadding: const EdgeInsets.all(16.0),
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(10.0),
          content: ErrorDialogLayout(error: error),
        );
      },
    );
  }
}

class ErrorDialogLayout extends StatefulWidget {
  final JsLayerError error;

  const ErrorDialogLayout({required this.error, super.key});

  @override
  State<ErrorDialogLayout> createState() => _ErrorDialogLayoutState();
}

class _ErrorDialogLayoutState extends State<ErrorDialogLayout> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return DialogBackground(
      width: 512.0,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(widget.error.name),
            const SizedBox(height: 22.0),
            Text(widget.error.message,
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 24.0),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                borderRadius: const BorderRadius.all(Radius.circular(12.0)),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 8.0),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        isExpanded = !isExpanded;
                      });
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("Raw error message",
                            style: Theme.of(context).textTheme.bodyMedium),
                        Icon(
                          isExpanded
                              ? Icons.arrow_drop_up_sharp
                              : Icons.arrow_drop_down_sharp,
                          color: Theme.of(context).colorScheme.secondary,
                          size: 24.0,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 8.0),
                  Visibility(
                    visible: isExpanded,
                    child: SizedBox(
                      height: 128.0,
                      child: SingleChildScrollView(
                        child: SelectableText(
                          widget.error.raw,
                          style: GoogleFonts.montserrat(
                            textStyle: const TextStyle(
                              fontSize: 16.0,
                              fontWeight: FontWeight.w300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
            const SizedBox(height: 36.0),
            MainButton(
              text: 'OK',
              onClick: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }
}
