import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Persists the best star rating per level (key = level_id).
class LevelStarsState extends ChangeNotifier {
  final Map<int, int> _stars = {};

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    for (final key in prefs.getKeys()) {
      if (key.startsWith('stars_')) {
        final levelId = int.tryParse(key.substring(6));
        if (levelId != null) {
          _stars[levelId] = prefs.getInt(key) ?? 0;
        }
      }
    }
  }

  /// Returns 0 if the level has never been completed.
  int getStars(int levelId) => _stars[levelId] ?? 0;

  /// Saves stars only if it's a new personal best.
  Future<void> setStars(int levelId, int stars) async {
    final current = _stars[levelId] ?? 0;
    if (stars <= current) return;
    _stars[levelId] = stars;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('stars_$levelId', stars);
    notifyListeners();
  }
}
