import 'package:flutter/material.dart';

class FavoritesManager extends ChangeNotifier {
  // Singleton pattern
  FavoritesManager._privateConstructor();
  static final FavoritesManager instance =
      FavoritesManager._privateConstructor();

  /// List of favorite plants
  final List<Map<String, dynamic>> _favoritePlants = [];

  List<Map<String, dynamic>> get favoritePlants => _favoritePlants;

  void addFavorite(Map<String, dynamic> plant) {
    if (!_favoritePlants.any((p) => p["displayName"] == plant["displayName"])) {
      _favoritePlants.add(plant);
      notifyListeners();
    }
  }

  void removeFavorite(Map<String, dynamic> plant) {
    _favoritePlants.removeWhere(
      (p) => p["displayName"] == plant["displayName"],
    );
    notifyListeners();
  }

  bool isFavorite(Map<String, dynamic> plant) {
    return _favoritePlants.any((p) => p["displayName"] == plant["displayName"]);
  }
}
