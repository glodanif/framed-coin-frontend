import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/domain/chain.dart';
import 'package:framed_coin_frontend/view/common/part/testnet_label.dart';

class ChainSelectorDropdown extends StatefulWidget {
  final bool isLoading;
  List<ChainInfo> allChains;
  ChainInfo selectedChainInfo;
  final Function(int)? onSwitched;
  final Color? mainColor;
  final Color? secondaryColor;

  late List<ChainInfo> chains;

  ChainSelectorDropdown({
    required this.allChains,
    required this.selectedChainInfo,
    this.onSwitched,
    this.isLoading = false,
    this.mainColor,
    this.secondaryColor,
    Key? key,
  }) : super(key: key) {
    chains = List<ChainInfo>.empty(growable: true);
    if (selectedChainInfo == ChainInfo.unsupported()) {
      chains.add(ChainInfo.unsupported());
    }
    chains.addAll(allChains);
  }

  @override
  State<ChainSelectorDropdown> createState() => _ChainSelectorState();
}

class _ChainSelectorState extends State<ChainSelectorDropdown> {
  @override
  Widget build(BuildContext context) {
    final mainColor = widget.mainColor ?? Theme.of(context).colorScheme.secondary;
    final secondaryColor = widget.secondaryColor ?? Colors.white;
    return DropdownButtonHideUnderline(
      child: DropdownButton2<ChainInfo>(
        buttonStyleData: ButtonStyleData(
          overlayColor: MaterialStateProperty.all(const Color(0X00FFFFFF)),
        ),
        customButton: Material(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
          color: mainColor,
          clipBehavior: Clip.antiAlias,
          child: Padding(
            padding: const EdgeInsets.only(
                top: 8.0, bottom: 8.0, left: 12.0, right: 4.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  children: [
                    Image.asset(
                      widget.selectedChainInfo.chainIcon,
                      height: 32.0,
                      width: 32.0,
                    ),
                    if (widget.selectedChainInfo.isTestnet)
                      _buildTestnetIndicator()
                  ],
                ),
                const SizedBox(width: 8.0),
                Icon(
                  Icons.arrow_drop_down_sharp,
                  color: secondaryColor,
                  size: 24.0,
                ),
              ],
            ),
          ),
        ),
        isExpanded: true,
        items: [
          ...widget.chains.map(
            (item) => DropdownMenuItem<ChainInfo>(
              value: item,
              child: Row(
                children: [
                  Image.asset(item.chainIcon, height: 32, width: 32),
                  const SizedBox(width: 12.0),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        if (item.isTestnet) const TestnetLabel()
                      ],
                    ),
                  ),
                  if (item.id == widget.selectedChainInfo.id)
                    Icon(
                      Icons.check,
                      color: Theme.of(context).colorScheme.onBackground,
                      size: 24.0,
                    ),
                ],
              ),
            ),
          ),
        ],
        onChanged: (value) {
          setState(() {
            final chain = value as ChainInfo;
            widget.selectedChainInfo = chain;
            widget.onSwitched?.call(chain.id);
          });
        },
        dropdownStyleData: DropdownStyleData(
          width: 272.0,
          padding: const EdgeInsets.symmetric(vertical: 6.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(4.0),
            color: Theme.of(context).colorScheme.background,
          ),
          elevation: 8,
        ),
        menuItemStyleData: const MenuItemStyleData(
          height: 56.0,
          padding: EdgeInsets.only(left: 16, right: 16),
        ),
      ),
    );
  }

  Widget _buildTestnetIndicator() {
    return Container(
      height: 32.0,
      width: 32.0,
      alignment: Alignment.bottomRight,
      child: const Material(
        borderRadius: BorderRadius.all(Radius.circular(8.0)),
        color: Colors.lightBlue,
        elevation: 2.0,
        clipBehavior: Clip.antiAlias,
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 2.0, horizontal: 5.0),
          child: Text(
            'T',
            style: TextStyle(fontSize: 10.0, color: Colors.white),
          ),
        ),
      ),
    );
  }
}
