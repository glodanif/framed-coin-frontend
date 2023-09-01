import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

const String nonExistent = "0";

class MiniatureNft extends StatelessWidget {
  final String id;
  final bool isCashedOut;
  final List<Color> gradientColors;

  const MiniatureNft({
    required this.id,
    required this.isCashedOut,
    this.gradientColors = const [],
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    const decoration = BoxDecoration(
      color: Colors.black54,
      borderRadius: BorderRadius.all(Radius.circular(4.0)),
    );

    return PhysicalModel(
      elevation: 4,
      color: Colors.grey,
      child: Container(
        width: 200.0,
        height: 200.0,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: const [0.25, 0.45, 0.65, 0.85],
            colors: gradientColors,
          ),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "#$id",
              style: GoogleFonts.righteous(
                textStyle: const TextStyle(
                  fontSize: 30.0,
                  color: Color(0XFF111111),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.end,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    decoration: decoration,
                    height: 16.0,
                    width: 54.0,
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
                          Container(
                            decoration: decoration,
                            height: 13.0,
                            width: 48.0,
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            decoration: decoration,
                            height: 13.0,
                            width: 72.0,
                          ),
                          const SizedBox(height: 4.0),
                          Container(
                            decoration: decoration,
                            height: 13.0,
                            width: 78.0,
                          ),
                        ],
                      ),
                      if (isCashedOut)
                        Column(
                          mainAxisAlignment: MainAxisAlignment.end,
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Container(
                              decoration: decoration,
                              height: 13.0,
                              width: 54.0,
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              decoration: decoration,
                              height: 13.0,
                              width: 70.0,
                            ),
                            const SizedBox(height: 4.0),
                            Container(
                              decoration: decoration,
                              height: 13.0,
                              width: 76.0,
                            ),
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
    );
  }
}
