import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:game_launcher/providers/namer_favorites_provider.dart';
import 'package:provider/provider.dart';

import '../../components/cards.dart';
import '../../providers/game_provider.dart';
import '../../providers/namer_provider.dart';
import '../../theme/themes.dart';
import 'namer_favorite.dart';
import 'namer_history.dart';

class NamerGameScreen extends StatefulWidget {
  static const routeName = '/namer_game';

  const NamerGameScreen({super.key});

  @override
  State<NamerGameScreen> createState() => _NamerGameScreenState();
}

class _NamerGameScreenState extends State<NamerGameScreen> {
  @override
  Widget build(BuildContext context) {
    final gameId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedGames = Provider.of<GameProvider>(
      context,
      listen: false,
    ).findById(gameId);

    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    final namer = Provider.of<Namer>(context);

    Widget page = const Placeholder();
    switch (namer.selectedPageIndex) {
      case 0:
        page = const GeneratorPage();
        break;
      case 1:
        page = const FavoritesPage();
        break;
      case 2:
        page = const HistoryList();
        break;
    }
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedGames.title),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: customTheme?.backgroundGradient,
            ),
          ),
          Row(
            children: [
              SafeArea(
                child: NavigationRail(
                  extended: false,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.home),
                      label: Text(AppLocalizations.of(context)!.home),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.favorite),
                      label: Text(AppLocalizations.of(context)!.favorites),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.history),
                      label: Text(AppLocalizations.of(context)!.history),
                    ),
                  ],
                  selectedIndex: namer.selectedPageIndex,
                  onDestinationSelected: (value) {
                    setState(() {
                      namer.selectedPageIndex = value;
                    });
                  },
                ),
              ),
              Expanded(
                child: Container(
                  child: page,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class GeneratorPage extends StatefulWidget {
  const GeneratorPage({super.key});

  @override
  State<GeneratorPage> createState() => _GeneratorPageState();
}

class _GeneratorPageState extends State<GeneratorPage> {
  @override
  Widget build(BuildContext context) {
    final namer = Provider.of<Namer>(context);
    final namerFavorite = Provider.of<NamerFavoriteProvider>(context);

    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    var pair = namer.current;
    IconData newIcon;

    namerFavorite.isFavorite
        ? newIcon = Icons.favorite
        : newIcon = Icons.favorite_border;

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BigCard(pair: pair),
          const SizedBox(height: 10),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              ElevatedButton.icon(
                onPressed: () async {
                  await namerFavorite.toggleFavorite(pair);

                  setState(() {});
                },
                icon: Icon(newIcon, color: customTheme?.cardTextColor),
                label: Text(
                  AppLocalizations.of(context)!.like,
                  style: TextStyle(
                    color: customTheme?.cardTextColor ?? Colors.black,
                  ),
                ),
              ),
              const SizedBox(width: 10),
              ElevatedButton(
                onPressed: () {
                  namer.getNext(context);
                },
                child: Text(AppLocalizations.of(context)!.next,
                    style: TextStyle(
                      color: customTheme?.cardTextColor ?? Colors.black,
                    )),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
