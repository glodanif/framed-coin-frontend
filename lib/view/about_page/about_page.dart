import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/about_page/about_body.dart';
import 'package:framed_coin_frontend/view/about_page/bloc/about_bloc.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => getIt<AboutBloc>()..loadContracts(),
      child: BlocBuilder<AboutBloc, AboutState>(
        builder: (context, state) {
          if (state is ContractAddressesState) {
            return AboutBody(contracts: state.contractAddresses);
          }
          return Container();
        },
      ),
    );
  }
}
