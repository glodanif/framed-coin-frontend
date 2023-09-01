import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/landing_page/bloc/landing_page_bloc.dart';
import 'package:framed_coin_frontend/view/landing_page/landing_content.dart';

class LandingPage extends StatefulWidget {
  const LandingPage({super.key});

  @override
  State<LandingPage> createState() => _LandingPageState();
}

class _LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocProvider(
        create: (context) => getIt<LandingPageBloc>()..loadContractsBalance(),
        child: BlocBuilder<LandingPageBloc, LandingPageState>(
          builder: (context, state) {
            if (state is ContractsBalanceState) {
              return LandingContent(
                totalNftsValueUsd: state.totalNftsValueUsd,
                totalSupply: state.totalSupply,
                totalChains: state.totalChains,
                dummyNft: state.dummyNft,
                dummySoldNft: state.dummySoldNft,
              );
            } else {
              return Container();
            }
          },
        ),
      ),
    );
  }
}
