import 'dart:convert';

import 'package:english_words/english_words.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NamerFavorite with ChangeNotifier {
  NamerFavorite({
    required this.id,
    required this.favoriteItem,
  });

  final String id;
  final String favoriteItem;
}

class NamerFavoriteProvider extends ChangeNotifier {
  var favorites = <NamerFavorite>[];
  var isFavorite = false;

  List<NamerFavorite> get favoriteList => favorites.map((pair) {
        return NamerFavorite(
          id: "",
          favoriteItem: "",
        );
      }).toList();

  Future<bool> toggleFavorite(WordPair current) async {
    if (favorites.isNotEmpty) {
      await fetchAndSetFavorites();
    }

    final existingFavorite = favorites.firstWhere(
      (fav) => fav.favoriteItem == current.asString,
      orElse: () => NamerFavorite(id: '', favoriteItem: ''),
    );

    if (existingFavorite.id.isNotEmpty) {
      isFavorite = false;
      await removeFavorite(existingFavorite.id);
    } else {
      isFavorite = true;
      await addToFavorite(current.asString);
    }

    notifyListeners();
    return isFavorite;
  }

  Future<void> addToFavorite(String pair) async {
    const url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/namer/favorite.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'word': pair.toString(),
        }),
      );

      favorites.add(NamerFavorite(
        id: '',
        favoriteItem: pair.toString(),
      ));
      if (response.statusCode >= 400) {
        throw Exception('Failed to post data');
      }

      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }

      rethrow;
    }
  }

  Future<void> fetchAndSetFavorites() async {
    const url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/namer/favorite.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }

      favorites.clear();

      extractedData.forEach((favoriteId, favoriteItem) {
        favorites.add(NamerFavorite(
          id: favoriteId,
          favoriteItem: favoriteItem['word'] as String,
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

  Future<void> removeFavorite(String id) async {
    final url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/namer/favorite/$id.json';

    try {
      final response = await http.delete(
        Uri.parse(url),
      );

      if (response.statusCode >= 400) {
        throw Exception('Failed to delete data');
      }

      favorites.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }
}
