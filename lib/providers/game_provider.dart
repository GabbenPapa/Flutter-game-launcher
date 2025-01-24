import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class Game with ChangeNotifier {
  Game({
    required this.id,
    required this.title,
    required this.description,
    required this.longDescription,
    required this.imageUrl,
    required this.gameType,
  });

  final String id;
  final String title;
  final String description;
  final String longDescription;
  final String imageUrl;
  final String gameType;

  void updateGame(String newTitle) {
    notifyListeners();
  }
}

class GameProvider with ChangeNotifier {
  final List<Game> _loadedGames = [];
  List<Game> get loadedGames => [..._loadedGames];

  Future<void> fetchAndSetGames() async {
    const url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/games.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData.isEmpty) {
        return;
      }
      _loadedGames.clear();
      extractedData.forEach((gameId, gameData) {
        _loadedGames.add(Game(
          id: gameId,
          title: gameData['title'] ?? '',
          description: gameData['description'] ?? '',
          longDescription: gameData['longDescription'] ?? '',
          imageUrl: gameData['imageUrl'] ?? '',
          gameType: gameData['gameType'] ?? '',
        ));
      });
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }

  Game findById(String id) {
    return _loadedGames.firstWhere((game) => game.id == id);
  }
}
