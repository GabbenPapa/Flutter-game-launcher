import 'package:flutter/material.dart';
import 'package:game_launcher/l10n/localization_extension.dart';
import 'package:provider/provider.dart';
import '../providers/game_provider.dart';
import '../screens/launcher_details_screen.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class GameItem extends StatelessWidget {
  const GameItem({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<Game>(
      builder: (context, game, child) {
        final localizations = AppLocalizations.of(context)!.localizedMap;

        final longTitleKey = "${game.gameType}_title";
        final longDescriptionKey = "${game.gameType}_description";

        final title = localizations[longTitleKey] ?? game.title;
        final description =
            localizations[longDescriptionKey] ?? game.description;

        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Colors.grey, width: 1),
            borderRadius: BorderRadius.circular(10),
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 5,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: GridTile(
              footer: GridTileBar(
                backgroundColor: Colors.black54,
                title: Center(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 4.0),
                    child: Column(
                      children: [
                        Text(
                          title,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          description,
                          style: const TextStyle(color: Colors.white),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pushNamed(GameDetailScreen.routeName,
                      arguments: game.id);
                },
                child: Hero(
                  tag: game.id,
                  child: FadeInImage(
                    placeholder:
                        const AssetImage('assets/images/GameDefault.png'),
                    image: NetworkImage(game.imageUrl),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
