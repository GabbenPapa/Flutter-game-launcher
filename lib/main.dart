import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:game_launcher/screens/settings.dart';
import 'package:provider/provider.dart';

import 'games/darts/darts_game_screen.dart';
import 'games/darts/darts_setup_screen.dart';
import 'games/dice/dice_game.dart';
import 'games/dice/pig_game.dart';
import 'games/fun_o_meter/fun_o_meter.dart';
import 'games/namer/namer_game.dart';
import 'games/rps_game.dart';
import 'providers/game_provider.dart';
import 'providers/intro_provider.dart';
import 'providers/settings_provider.dart';
import 'providers/namer_favorites_provider.dart';
import 'providers/namer_history_provider.dart';
import 'providers/namer_provider.dart';
import 'screens/intro_screen.dart';
import 'screens/launcher_details_screen.dart';
import 'screens/launcher_screen.dart';
import 'theme/themes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final languageProvider = LanguageProvider();
  await languageProvider.getLanguage();

  final themeProvider = ThemeProvider();
  await themeProvider.initializePreferences();

  runApp(MyApp(languageProvider, themeProvider));
}

class MyApp extends StatelessWidget {
  final LanguageProvider languageProvider;
  final ThemeProvider themeProvider;

  const MyApp(this.languageProvider, this.themeProvider, {super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (ctx) => IntroProvider()),
        ChangeNotifierProvider.value(value: languageProvider),
        ChangeNotifierProvider.value(value: themeProvider),
        ChangeNotifierProvider(create: (ctx) => GameProvider()),
        ChangeNotifierProvider(create: (ctx) => Namer()),
        ChangeNotifierProvider(create: (ctx) => NamerHistoryProvider()),
        ChangeNotifierProvider(create: (ctx) => NamerFavoriteProvider()),
      ],
      child: Consumer2<LanguageProvider, ThemeProvider>(
        builder: (ctx, languageProvider, themeProvider, _) {
          return MaterialApp(
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: const [
              Locale('en'),
              Locale('hu'),
              Locale('de'),
            ],
            locale: Locale(languageProvider.currentLanguage),
            debugShowCheckedModeBanner: false,
            title: 'Game Launcher',
            theme: lightMode,
            darkTheme: darkMode,
            themeMode: themeProvider.useSystemTheme
                ? ThemeMode.system
                : themeProvider.isDarkTheme
                    ? ThemeMode.dark
                    : ThemeMode.light,
            home: const HomeSelector(),
            routes: {
              LauncherScreen.routeName: (ctx) => const LauncherScreen(),
              GameDetailScreen.routeName: (ctx) => const GameDetailScreen(),
              NamerGameScreen.routeName: (ctx) => const NamerGameScreen(),
              DartsSetupScreen.routeName: (ctx) => const DartsSetupScreen(),
              DartsGameScreen.routeName: (ctx) => const DartsGameScreen(),
              PigGameScreen.routeName: (ctx) => const PigGameScreen(),
              DiceGameScreen.routeName: (ctx) => const DiceGameScreen(),
              RpsGameScreen.routeName: (ctx) => const RpsGameScreen(),
              FunOMeter.routeName: (ctx) => const FunOMeter(),
              Settings.routeName: (ctx) => const Settings(),
            },
          );
        },
      ),
    );
  }
}

class HomeSelector extends StatefulWidget {
  const HomeSelector({super.key});

  @override
  State<HomeSelector> createState() => _HomeSelectorState();
}

class _HomeSelectorState extends State<HomeSelector> {
  bool _introCompleted = false;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadIntroStatus();
  }

  Future<void> _loadIntroStatus() async {
    final completed = await IntroProvider.getIntroCompleted();
    setState(() {
      _introCompleted = completed;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<IntroProvider>(
      builder: (ctx, introProvider, _) {
        return _isLoading
            ? const Center(child: CircularProgressIndicator())
            : _introCompleted
                ? const LauncherScreen()
                : const IntroScreen();
      },
    );
  }
}
