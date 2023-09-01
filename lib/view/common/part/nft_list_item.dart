import 'package:flutter/material.dart';
import 'package:framed_coin_frontend/view/common/nft_view_model.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';

class NftListItem extends StatelessWidget {
  final NftViewModel nft;
  final globalKey = GlobalKey();

  NftListItem({super.key, required this.nft});

  @override
  Widget build(BuildContext context) {
    final isTiny = ResponsiveBreakpoints.of(context).smallerOrEqualTo('TINY');
    final scaledEdge = 400.0 * (isTiny ? 0.82 : 1);
    final scaledFont = 18.0 * (isTiny ? 0.87 : 1);
    final textStyle = GoogleFonts.comfortaa(
      textStyle: TextStyle(
        fontSize: scaledFont,
        color: const Color(0XFF111111),
        shadows: const [
          Shadow(blurRadius: 2.0, offset: Offset(1, 1), color: Colors.grey),
        ],
      ),
    );

    return Container(
      width: scaledEdge,
      height: scaledEdge,
      padding: const EdgeInsets.all(8.0),
      child: PhysicalModel(
        elevation: 4,
        color: Colors.grey,
        child: Container(
          key: globalKey,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              stops: const [0.25, 0.45, 0.65, 0.85],
              colors: nft.gradientColors,
            ),
          ),
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                nft.idLabel,
                style: GoogleFonts.righteous(
                  textStyle: const TextStyle(
                    fontSize: 56.0,
                    color: Color(0XFF111111),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          nft.value,
                          style: GoogleFonts.righteous(
                            textStyle: const TextStyle(
                              fontSize: 36.0,
                              color: Color(0XFF111111),
                              fontWeight: FontWeight.bold,
                              shadows: [
                                Shadow(
                                  blurRadius: 2.0,
                                  offset: Offset(1, 1),
                                  color: Colors.grey,
                                ),
                              ],
                            ),
                          ),
                        ),
                        const SizedBox(width: 8.0),
                        ColorFiltered(
                          colorFilter: nft.colorFilter,
                          child: Image.asset(
                            nft.tokenIcon,
                            filterQuality: FilterQuality.medium,
                            height: 30.0,
                            width: 30.0,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12.0),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Text(
                              'Bought',
                              style: textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8.0),
                            Text("for ${nft.boughtFor}", style: textStyle),
                            const SizedBox(height: 4.0),
                            Text("at ${nft.boughtAt}", style: textStyle),
                          ],
                        ),
                        if (nft.isCashedOut)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.end,
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                'Sold',
                                style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8.0),
                              Text("for ${nft.soldFor}", style: textStyle),
                              const SizedBox(height: 4.0),
                              Text("at ${nft.soldAt}", style: textStyle),
                            ],
                          ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<Rect> getBoundaries() async {
    await Future<dynamic>.delayed(const Duration(milliseconds: 100));
    return globalKey.globalPaintBounds!;
  }
}

extension GlobalKeyExtension on GlobalKey {
  Rect? get globalPaintBounds {
    final RenderObject? renderObject = currentContext?.findRenderObject();
    final translation = renderObject?.getTransformTo(null).getTranslation();
    if (translation != null && renderObject?.paintBounds != null) {
      return renderObject!.paintBounds
          .shift(Offset(translation.x, translation.y));
    } else {
      return null;
    }
  }
}
