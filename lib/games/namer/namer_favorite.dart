import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/namer_favorites_provider.dart';

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({super.key});

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  late Future<void> _favoritesFuture;

  @override
  void initState() {
    super.initState();
    _favoritesFuture =
        Provider.of<NamerFavoriteProvider>(context, listen: false)
            .fetchAndSetFavorites();
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    final namer = Provider.of<NamerFavoriteProvider>(context);

    return FutureBuilder(
      future: _favoritesFuture,
      builder: (ctx, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          if (namer.favorites.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noFavorites),
            );
          }

          return Scaffold(
            backgroundColor: theme.colorScheme.primaryContainer,
            body: ListView(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Text(
                    AppLocalizations.of(context)!
                        .youHaveFavorites(namer.favorites.length),
                  ),
                ),
                for (var pair in namer.favorites)
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(
                        Icons.delete_outline,
                        semanticLabel: 'Delete',
                      ),
                      color: theme.colorScheme.primary,
                      onPressed: () {
                        namer.removeFavorite(pair.id);
                      },
                    ),
                    title: Text(pair.favoriteItem),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}
