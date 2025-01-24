import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../providers/namer_history_provider.dart';

class HistoryList extends StatefulWidget {
  const HistoryList({super.key});

  @override
  State<HistoryList> createState() => _HistoryListState();
}

class _HistoryListState extends State<HistoryList> {
  bool _isFirstLoad = true;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return FutureBuilder(
      future: _isFirstLoad
          ? Provider.of<NamerHistoryProvider>(context, listen: false)
              .fetchAndSetHistory()
          : null,
      builder: (ctx, snapshot) {
        if (_isFirstLoad &&
            snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        } else {
          _isFirstLoad = false;
          final namer = Provider.of<NamerHistoryProvider>(context);

          if (namer.history.isEmpty) {
            return Center(
              child: Text(AppLocalizations.of(context)!.noHistory),
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
                        .youHaveHistory(namer.history.length),
                  ),
                ),
                for (var item in namer.history)
                  ListTile(
                    leading: IconButton(
                      icon: const Icon(Icons.delete_outline,
                          semanticLabel: 'Delete'),
                      color: theme.colorScheme.primary,
                      onPressed: () async {
                        await namer.removeHistory(item.id);
                      },
                    ),
                    title: Text(item.historyItem),
                  ),
              ],
            ),
          );
        }
      },
    );
  }
}
