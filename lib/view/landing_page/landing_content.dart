import 'dart:html';

import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:framed_coin_frontend/view/common/part/main_button.dart';
import 'package:framed_coin_frontend/view/common/part/nft_list_item.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:url_launcher/url_launcher.dart';

class LandingContent extends StatelessWidget {
  final String totalNftsValueUsd;
  final String totalSupply;
  final int totalChains;
  final NftViewModel dummyNft;
  final NftViewModel dummySoldNft;

  const LandingContent({
    super.key,
    required this.totalNftsValueUsd,
    required this.totalSupply,
    required this.totalChains,
    required this.dummyNft,
    required this.dummySoldNft,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.topCenter,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.50, 0.85],
          colors: [Color(0XFF17212B), Colors.black],
        ),
      ),
      width: double.infinity,
      height: MediaQuery.of(context).size.height,
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Wrap(
          children: [
            Container(
              width: 1300.0,
              padding: const EdgeInsets.all(24.0),
              child: _buildLayout(context),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLayout(BuildContext context) {
    if (ResponsiveBreakpoints.of(context).smallerOrEqualTo(MOBILE)) {
      return _buildMobileContent(context);
    } else if (ResponsiveBreakpoints.of(context).isTablet) {
      return _buildTabledContent(context);
    } else {
      return _buildDesktopContent(context);
    }
  }

  Widget _buildDesktopContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BrandLabel(),
            SizedBox(width: 24.0),
            TestingLabel(),
            Expanded(child: SizedBox()),
            VerifyButton(),
            AboutButton(),
            LaunchButton(),
          ],
        ),
        const SizedBox(height: 24.0),
        BalanceLabel(
          totalSupply: totalSupply,
          totalNftsValueUsd: totalNftsValueUsd,
          totalChains: totalChains,
        ),
        const SizedBox(height: 96.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(child: FirstTextBlock()),
            const SizedBox(width: 36.0),
            NftListItem(nft: dummyNft),
          ],
        ),
        const SizedBox(height: 64.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NftListItem(nft: dummySoldNft),
            const SizedBox(width: 36.0),
            const Flexible(child: SecondTextBlock()),
          ],
        ),
      ],
    );
  }

  Widget _buildTabledContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [BrandLabel(), SizedBox(width: 24.0), TestingLabel()],
        ),
        const SizedBox(height: 24.0),
        const Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [VerifyButton(), AboutButton(), LaunchButton()],
        ),
        const SizedBox(height: 24.0),
        BalanceLabel(
          totalSupply: totalSupply,
          totalNftsValueUsd: totalNftsValueUsd,
          totalChains: totalChains,
        ),
        const SizedBox(height: 96.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Flexible(child: FirstTextBlock()),
            const SizedBox(width: 36.0),
            NftListItem(nft: dummyNft),
          ],
        ),
        const SizedBox(height: 64.0),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            NftListItem(nft: dummySoldNft),
            const SizedBox(width: 36.0),
            const Flexible(child: SecondTextBlock()),
          ],
        ),
      ],
    );
  }

  Widget _buildMobileContent(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const BrandLabel(),
        const TestingLabel(),
        const SizedBox(height: 24.0),
        const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [VerifyButton(), AboutButton()],
        ),
        const SizedBox(height: 24.0),
        const LaunchButton(),
        const SizedBox(height: 24.0),
        BalanceLabel(
          totalSupply: totalSupply,
          totalNftsValueUsd: totalNftsValueUsd,
          totalChains: totalChains,
        ),
        const SizedBox(height: 96.0),
        const FirstTextBlock(),
        const SizedBox(height: 36.0),
        NftListItem(nft: dummyNft),
        const SizedBox(height: 36.0),
        const SecondTextBlock(),
        const SizedBox(height: 36.0),
        NftListItem(nft: dummySoldNft),
      ],
    );
  }
}

class FirstTextBlock extends StatelessWidget {
  const FirstTextBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Get a unique NFT that holds your tokens\n\nFramed Coin smart contract holds your funds alongside the USD price and date of minting",
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 36.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class SecondTextBlock extends StatelessWidget {
  const SecondTextBlock({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "You can always cash out your NFT and it will remember the cash out price and date, but it will lose its uniqueness",
      style: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          fontSize: 36.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class AboutButton extends StatelessWidget {
  const AboutButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainButton(
      text: "About",
      color: const Color(0XFF2B3752),
      textColor: Colors.white,
      onClick: () {
        context.go('/about');
      },
    );
  }
}

class VerifyButton extends StatelessWidget {
  const VerifyButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainButton(
      text: "Verify NFT",
      color: const Color(0XFF2B3752),
      textColor: Colors.white,
      onClick: () {
        context.go('/verify');
      },
    );
  }
}

class LaunchButton extends StatelessWidget {
  const LaunchButton({super.key});

  @override
  Widget build(BuildContext context) {
    return MainButton(
      text: "Launch app",
      color: Colors.white,
      textColor: const Color(0XFF212A3E),
      onClick: () {
        final uri = Uri.parse(window.location.href);
        Uri rootUri = Uri(
          scheme: uri.scheme,
          host: uri.host,
          port: uri.port,
          path: "app",
        );
        launchUrl(rootUri);
      },
    );
  }
}

class BrandLabel extends StatelessWidget {
  const BrandLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Text(
      "Framed Coin",
      textAlign: TextAlign.center,
      style: GoogleFonts.righteous(
        textStyle: const TextStyle(
          fontSize: 72.0,
          color: Colors.white,
        ),
      ),
    );
  }
}

class BalanceLabel extends StatelessWidget {
  final String totalSupply;
  final String totalNftsValueUsd;
  final int totalChains;

  const BalanceLabel({
    required this.totalSupply,
    required this.totalNftsValueUsd,
    required this.totalChains,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: const BoxDecoration(
        color: Color(0XFF2B3752),
        borderRadius: BorderRadius.all(Radius.circular(32.0)),
      ),
      child: Text(
        "${totalSupply.isEmpty ? "\$..." : totalSupply} NFTs holding ${totalNftsValueUsd.isEmpty ? "..." : totalNftsValueUsd} of value across $totalChains chains",
        style: GoogleFonts.montserrat(
          textStyle: const TextStyle(
            fontSize: 28.0,
            color: Colors.white,
          ),
        ),
      ),
    );
  }
}

class TestingLabel extends StatelessWidget {
  const TestingLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
        decoration: const BoxDecoration(
          color: Colors.deepOrangeAccent,
          borderRadius: BorderRadius.all(Radius.circular(12.0)),
        ),
        child: Text(
          "Public testing",
          style: GoogleFonts.montserrat(
            textStyle: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
