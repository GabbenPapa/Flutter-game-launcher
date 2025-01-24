import 'package:flutter/material.dart';
import 'package:game_launcher/screens/settings.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

import '../providers/game_provider.dart';
import '../widgets.dart/game_item.dart';
import '../theme/themes.dart';

class LauncherScreen extends StatefulWidget {
  static const routeName = '/launcher';

  const LauncherScreen({super.key});

  @override
  State<LauncherScreen> createState() => _LauncherScreenState();
}

class _LauncherScreenState extends State<LauncherScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = <Widget>[
    const LauncherScreenContent(),
    const Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.game_launcher_title),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        backgroundColor: theme.colorScheme.surface,
        onTap: (index) {
          setState(() {
            _selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            icon: const Icon(Icons.home),
            label: AppLocalizations.of(context)!.home,
          ),
          BottomNavigationBarItem(
            icon: const Icon(Icons.settings),
            label: AppLocalizations.of(context)!.settings,
          ),
        ],
      ),
    );
  }
}

class LauncherScreenContent extends StatefulWidget {
  static const routeName = '/launcher';

  const LauncherScreenContent({super.key});

  @override
  State<LauncherScreenContent> createState() => _LauncherScreenContentState();
}

class _LauncherScreenContentState extends State<LauncherScreenContent> {
  var _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (!_isLoading) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<GameProvider>(context, listen: false)
          .fetchAndSetGames()
          .then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final games = Provider.of<GameProvider>(context).loadedGames;
    final theme = Theme.of(context);

    final customTheme = theme.extension<CustomThemeExtension>();

    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            gradient: customTheme?.backgroundGradient,
          ),
        ),
        _isLoading
            ? const Center(child: CircularProgressIndicator())
            : GridView.builder(
                padding: const EdgeInsets.all(10),
                itemCount: games.length,
                itemBuilder: (context, index) => ChangeNotifierProvider.value(
                  value: games[index],
                  child: const GameItem(),
                ),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  childAspectRatio: 1,
                  crossAxisSpacing: 10,
                  mainAxisSpacing: 10,
                ),
              ),
      ],
    );
  }
}
