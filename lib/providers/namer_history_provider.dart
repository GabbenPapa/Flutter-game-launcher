import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

class NamerHistory with ChangeNotifier {
  NamerHistory({
    required this.id,
    required this.historyItem,
  });

  final String id;
  final String historyItem;
}

class NamerHistoryProvider extends ChangeNotifier {
  var history = <NamerHistory>[];

  List<NamerHistory> get historyList => history.map((pair) {
        return NamerHistory(
          id: "",
          historyItem: "",
        );
      }).toList();

  Future<void> fetchAndSetHistory() async {
    const url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/namer/history.json';
    try {
      final response = await http.get(Uri.parse(url));
      final extractedData = json.decode(response.body) as Map<String, dynamic>;

      if (extractedData.isEmpty) {
        return;
      }

      history.clear();

      extractedData.forEach((historyId, historyItem) {
        history.add(NamerHistory(
          historyItem: historyItem['word'] as String,
          id: historyId,
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

  Future<void> addToHistory(String pair) async {
    const url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/namer/history.json';
    try {
      final response = await http.post(
        Uri.parse(url),
        body: json.encode({
          'word': pair.toString(),
        }),
      );

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

  Future<void> removeHistory(String id) async {
    final url =
        'https://game-launcher-1915c-default-rtdb.europe-west1.firebasedatabase.app/namer/history/$id.json';

    try {
      final response = await http.delete(
        Uri.parse(url),
      );

      if (response.statusCode >= 400) {
        throw Exception('Failed to delete data');
      }

      history.removeWhere((item) => item.id == id);
      notifyListeners();
    } catch (error) {
      if (kDebugMode) {
        print(error);
      }
      rethrow;
    }
  }
}
