import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:framed_coin_frontend/data/js/js_layer.dart';
import 'package:framed_coin_frontend/firebase_options.dart';
import 'package:framed_coin_frontend/logging/bloc_logging.dart';
import 'package:framed_coin_frontend/sl/get_it.dart';
import 'package:framed_coin_frontend/view/about_page/about_page.dart';
import 'package:framed_coin_frontend/view/landing_page/landing_page.dart';
import 'package:framed_coin_frontend/view/main_page/main_page.dart';
import 'package:framed_coin_frontend/view/nft_details_page/details_page.dart';
import 'package:framed_coin_frontend/view/nft_minting_page/minting_page.dart';
import 'package:framed_coin_frontend/view/nfts_list_page/nft_list_page.dart';
import 'package:framed_coin_frontend/view/owner_tools_page/owner_tools_page.dart';
import 'package:framed_coin_frontend/view/public_view_page/public_view_page.dart';
import 'package:framed_coin_frontend/view/verification_page/verification_page.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_framework/breakpoint.dart';
import 'package:responsive_framework/responsive_breakpoints.dart';
import 'package:theme_provider/theme_provider.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

const lightTheme = "light";
const darkTheme = "dark";

void main() async {
  //debugPaintSizeEnabled = true;
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: '.env');
  await setupDependencies();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  usePathUrlStrategy();
  initBlocLogging(enabled: false);
  LicenseRegistry.addLicense(() async* {
    final licenseLato = await rootBundle.loadString('fonts/Lato-OFL.txt');
    yield LicenseEntryWithLineBreaks(['lato'], licenseLato);
    final licenseMontserrat =
        await rootBundle.loadString('fonts/Montserrat-OFL.txt');
    yield LicenseEntryWithLineBreaks(['montserrat'], licenseMontserrat);
    final licenseRighteous =
        await rootBundle.loadString('fonts/Righteous-OFL.txt');
    yield LicenseEntryWithLineBreaks(['righteous'], licenseRighteous);
    final licenseComfortaa =
        await rootBundle.loadString('fonts/Comfortaa-OFL.txt');
    yield LicenseEntryWithLineBreaks(['comfortaa'], licenseComfortaa);
  });
  runApp(FramedCoinApp());
}

Future<void> setupDependencies() async {
  final smartContractsJson =
      await rootBundle.loadString('assets/smart_contracts.json');
  final smartContracts =
      Map<String, String>.from(json.decode(smartContractsJson));
  initDependencies(smartContracts);
  initJsBridge(smartContractsJson);
}

class FramedCoinApp extends StatelessWidget {
  FramedCoinApp({Key? key}) : super(key: key);

  final GoRouter _router = GoRouter(
    observers: <NavigatorObserver>[
      FirebaseAnalyticsObserver(analytics: FirebaseAnalytics.instance),
    ],
    navigatorKey: _rootNavigatorKey,
    debugLogDiagnostics: !kReleaseMode,
    initialLocation: '/',
    routes: <RouteBase>[
      GoRoute(
        path: '/',
        builder: (context, state) => const LandingPage(),
        routes: [
          GoRoute(
            path: 'about',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: AboutPage());
            },
          ),
          GoRoute(
            path: 'verify',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: VerificationPage());
            },
          ),
          GoRoute(
            path: 'public_view',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final chainId = state.queryParameters['chainId'] ?? '0';
              final tokenId = state.queryParameters['tokenId'] ?? '0';
              return NoTransitionPage(
                child: PublicViewPage(chainId: chainId, tokenId: tokenId),
              );
            },
          ),
        ],
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (BuildContext context, GoRouterState state, Widget child) {
          return MainPage(child: child);
        },
        routes: <RouteBase>[
          GoRoute(
            path: '/app',
            pageBuilder: (BuildContext context, GoRouterState state) {
              final t = state.queryParameters['t'] ?? '';
              final key = t.isEmpty ? null : Key(t);
              return NoTransitionPage(child: NftListPage(key: key));
            },
            routes: <RouteBase>[
              GoRoute(
                path: 'mint',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  return const NoTransitionPage(child: MintingPage());
                },
              ),
              GoRoute(
                path: ':tokenId',
                pageBuilder: (BuildContext context, GoRouterState state) {
                  final update = state.queryParameters['update'] ?? '';
                  return NoTransitionPage(
                    child: DetailsPage(
                      tokenId: state.pathParameters['tokenId'] ?? '0',
                      updateOnPop: update.isNotEmpty,
                    ),
                  );
                },
              ),
            ],
          ),
          GoRoute(
            path: '/owner_tools',
            pageBuilder: (BuildContext context, GoRouterState state) {
              return const NoTransitionPage(child: OwnerToolsPage());
            },
          ),
        ],
      ),
    ],
  );

  final _lightTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0XFFF1F6F9),
    colorScheme: const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0XFF394867),
      onPrimary: Color(0XFFF1F6F9),
      secondary: Color(0XFF212A3E),
      onSecondary: Color(0XFF000000),
      background: Color(0XFFF1F6F9),
      onBackground: Color(0XFF000000),
      surface: Colors.black12,
      onSurface: Color(0XFF000000),
      error: Colors.redAccent,
      onError: Color(0XFFFFFFFF),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.righteous(
        textStyle: const TextStyle(
          fontSize: 28.0,
          color: Color(0XFFEEEEEA),
        ),
      ),
      bodyMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      titleMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyLarge: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 24.0,
        ),
      ),
      labelMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFF000B1A),
          fontSize: 18.0,
        ),
      ),
      bodySmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          color: Colors.black54,
          fontSize: 16.0,
        ),
      ),
    ),
  );

  final _darkTheme = ThemeData(
    scaffoldBackgroundColor: const Color(0XFF17212B),
    colorScheme: const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0XFF0E1621),
      onPrimary: Color(0XFF000000),
      secondary: Color(0XFF2B5278),
      onSecondary: Color(0XFF000000),
      background: Color(0XFF17212B),
      onBackground: Color(0XFFEEEEEA),
      surface: Colors.white12,
      onSurface: Color(0XFF000000),
      error: Colors.redAccent,
      onError: Color(0XFFFFFFFF),
    ),
    textTheme: TextTheme(
      titleLarge: GoogleFonts.righteous(
        textStyle: const TextStyle(
          fontSize: 28.0,
          color: Color(0XFFEEEEEA),
        ),
      ),
      bodyMedium: GoogleFonts.lato(
        textStyle: const TextStyle(fontSize: 18.0),
      ),
      titleMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFFEEEEEA),
          fontSize: 28.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      bodyLarge: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFFEEEEEA),
          fontSize: 24.0,
        ),
      ),
      labelMedium: GoogleFonts.montserrat(
        textStyle: const TextStyle(
          color: Color(0XFFEEEEEA),
          fontSize: 18.0,
        ),
      ),
      bodySmall: GoogleFonts.lato(
        textStyle: const TextStyle(
          color: Colors.white54,
          fontSize: 16.0,
        ),
      ),
    ),
  );

  final _breakpoints = [
    const Breakpoint(start: 0, end: 450, name: 'TINY'),
    const Breakpoint(start: 451, end: 750, name: MOBILE),
    const Breakpoint(start: 751, end: 1200, name: TABLET),
    const Breakpoint(start: 1201, end: double.infinity, name: DESKTOP),
  ];

  @override
  Widget build(BuildContext context) {
    return ThemeProvider(
      saveThemesOnChange: true,
      loadThemeOnInit: true,
      themes: [
        AppTheme(
          id: lightTheme,
          description: "Light Theme",
          data: _lightTheme,
        ),
        AppTheme(
          id: darkTheme,
          description: "Dark Theme",
          data: _darkTheme,
        ),
      ],
      child: ThemeConsumer(
        child: Builder(builder: (themeContext) {
          return MaterialApp.router(
            title: 'Framed Coin',
            theme: ThemeProvider.themeOf(themeContext).data,
            routerConfig: _router,
            debugShowCheckedModeBanner: !kReleaseMode,
            builder: (context, child) => ResponsiveBreakpoints.builder(
              child: child ?? const Placeholder(),
              breakpoints: _breakpoints,
            ),
          );
        }),
      ),
    );
  }
}
