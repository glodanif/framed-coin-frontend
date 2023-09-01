import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/part/back_arrow_button.dart';
import 'package:framed_coin_frontend/view/common/part/side_page_wrapper.dart';
import 'package:framed_coin_frontend/view/verification_page/verification_body.dart';

class VerificationPage extends StatelessWidget {
  const VerificationPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const SidePageWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BackArrowButton(),
          SizedBox(height: 36.0),
          VerificationBody(),
          SizedBox(height: 72.0),
        ],
      ),
    );
  }
}
