import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'namer_history_provider.dart';

class Namer with ChangeNotifier {
  var current = WordPair.random();

  var selectedPageIndex = 0;

  Future<void> getNext(BuildContext context) async {
    final namerHistoryProvider =
        Provider.of<NamerHistoryProvider>(context, listen: false);
    var str = current.asString;
    await namerHistoryProvider.addToHistory(str);
    current = WordPair.random();
    notifyListeners();
  }
}
