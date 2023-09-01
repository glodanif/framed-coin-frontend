import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/about_page/converter/contract_address_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/link.dart';
import 'package:framed_coin_frontend/view/common/part/testnet_label.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class ContractItem extends StatelessWidget {
  final ContractAddressViewModel contract;

  const ContractItem({required this.contract, super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: ResponsiveBreakpoints.of(context).largerOrEqualTo(DESKTOP)
          ? Row(
              children: [
                _buildChainLabel(context),
                Link(
                  text: contract.contractAddress,
                  uri: contract.explorerLink,
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildChainLabel(context),
                const SizedBox(height: 12.0),
                Link(
                  text: contract.contractAddress,
                  uri: contract.explorerLink,
                ),
              ],
            ),
    );
  }

  Widget _buildChainLabel(BuildContext context) {
    return Row(
      children: [
        Image.asset(
          contract.chainIcon,
          height: 32.0,
          width: 32.0,
        ),
        const SizedBox(width: 24.0),
        SizedBox(
          width: 196.0,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                contract.chainName,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              if (contract.isTestnet) const TestnetLabel()
            ],
          ),
        ),
      ],
    );
  }
}
