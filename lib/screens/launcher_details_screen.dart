import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:game_launcher/providers/game_provider.dart';
import 'package:provider/provider.dart';
import 'package:game_launcher/l10n/localization_extension.dart';

import '../games/darts/darts_setup_screen.dart';
import '../games/dice/dice_game.dart';
import '../games/dice/pig_game.dart';
import '../games/fun_o_meter/fun_o_meter.dart';
import '../games/namer/namer_game.dart';
import '../games/rps_game.dart';
import '../theme/themes.dart';

class GameDetailScreen extends StatelessWidget {
  static const routeName = '/game_detail';

  const GameDetailScreen({super.key});

  void getGameTypeToSelect(BuildContext context, loadedGames) {
    String selectedGame;
    if (loadedGames.gameType == "pig_game") {
      selectedGame = PigGameScreen.routeName;
    } else if (loadedGames.gameType == "game_namer") {
      selectedGame = NamerGameScreen.routeName;
    } else if (loadedGames.gameType == "game_darts") {
      selectedGame = DartsSetupScreen.routeName;
    } else if (loadedGames.gameType == "game_rps") {
      selectedGame = RpsGameScreen.routeName;
    } else if (loadedGames.gameType == "game_dice") {
      selectedGame = DiceGameScreen.routeName;
    } else if (loadedGames.gameType == "fun") {
      selectedGame = FunOMeter.routeName;
    } else {
      if (kDebugMode) {
        print("No game selected");
      }
      return;
    }

    Navigator.of(context).pushNamed(
      selectedGame,
      arguments: loadedGames.id,
    );
  }

  @override
  Widget build(BuildContext context) {
    final gameId = ModalRoute.of(context)!.settings.arguments as String;
    final loadedGames = Provider.of<GameProvider>(
      context,
      listen: false,
    ).findById(gameId);

    final theme = Theme.of(context);
    final customTheme = theme.extension<CustomThemeExtension>();

    final longtitleKey = "${loadedGames.gameType}_title";
    final localizedTitle =
        AppLocalizations.of(context)?.localizedMap[longtitleKey] ??
            loadedGames.title;

    final longDescriptionKey = "${loadedGames.gameType}_long_description";
    final localizedDescription =
        AppLocalizations.of(context)?.localizedMap[longDescriptionKey] ??
            loadedGames.longDescription;

    return Scaffold(
      appBar: AppBar(
        title: Text(localizedTitle),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: customTheme?.backgroundGradient,
            ),
          ),
          Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const SizedBox(height: 10),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20),
                            ),
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(20),
                            child: Hero(
                              tag: loadedGames.id,
                              child: Image.network(
                                loadedGames.imageUrl,
                                fit: BoxFit.cover,
                                height: 300,
                                width: 400,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        width: double.infinity,
                        child: Text(
                          localizedDescription,
                          style: const TextStyle(fontSize: 18),
                          textAlign: TextAlign.justify,
                          softWrap: true,
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: SizedBox(
                  width: double.infinity,
                  height: 80,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.green),
                    onPressed: () => getGameTypeToSelect(context, loadedGames),
                    child: Text(
                      AppLocalizations.of(context)!.startgame,
                      style: const TextStyle(fontSize: 25),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ],
      ),
    );
  }
}
