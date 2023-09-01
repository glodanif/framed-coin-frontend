import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/back_arrow_button.dart';
import 'package:framed_coin_frontend/view/common/part/contract_item.dart';
import 'package:framed_coin_frontend/view/common/part/link.dart';
import 'package:framed_coin_frontend/view/common/part/side_page_wrapper.dart';
import 'package:google_fonts/google_fonts.dart';

class AboutBody extends StatelessWidget {
  final email = "framed.coin@gmail.com";
  final contractCodeUrl = "https://github.com/glodanif/framed-coin";
  final frontendCodeUrl = "https://github.com/glodanif/framed-coin-frontend";
  final List<ContractAddressViewModel> contracts;

  const AboutBody({required this.contracts, super.key});

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onBackground;
    final textTheme = Theme.of(context).textTheme;
    final bodyLarge = textTheme.bodyLarge;
    final titleMedium = textTheme.titleMedium;
    return SidePageWrapper(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const BackArrowButton(),
          const SizedBox(height: 36.0),
          Text("Smart contracts", style: titleMedium),
          const SizedBox(height: 24.0),
          Text("Mainnets", style: bodyLarge),
          const SizedBox(height: 18.0),
          Text(
            "Coming after extensive testing on testnets",
            style: textTheme.bodyMedium,
          ),
          const SizedBox(height: 36.0),
          Text("Testnets", style: bodyLarge),
          const SizedBox(height: 18.0),
          ListView.separated(
            shrinkWrap: true,
            itemCount: contracts.length,
            physics: const NeverScrollableScrollPhysics(),
            separatorBuilder: (context, index) =>
                Divider(height: 1, color: color),
            itemBuilder: (context, index) {
              return ContractItem(contract: contracts[index]);
            },
          ),
          const SizedBox(height: 48.0),
          Text("Contact", style: titleMedium),
          const SizedBox(height: 24.0),
          Link(text: email, uri: Uri.parse("mailto:$email"), style: bodyLarge),
          const SizedBox(height: 48.0),
          Row(
            children: [
              Text("Source code", style: titleMedium),
              const SizedBox(width: 12.0),
              FaIcon(FontAwesomeIcons.github, size: 36.0, color: color)
            ],
          ),
          const SizedBox(height: 24.0),
          Text("Smart contract", style: bodyLarge),
          const SizedBox(height: 12.0),
          Link(
            text: contractCodeUrl,
            uri: Uri.parse(contractCodeUrl),
          ),
          const SizedBox(height: 36.0),
          Text("Frontend", style: bodyLarge),
          const SizedBox(height: 12.0),
          Link(
            text: frontendCodeUrl,
            uri: Uri.parse(frontendCodeUrl),
            style: GoogleFonts.montserrat(
              textStyle: const TextStyle(fontSize: 18.0),
            ),
          ),
          const SizedBox(height: 72.0),
        ],
      ),
    );
  }
}
