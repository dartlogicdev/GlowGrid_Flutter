import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/level.dart';
import '../models/tile_type.dart';
import '../models/light_segment.dart';
import '../engine/light_engine.dart';

class GameState extends ChangeNotifier {
  // ── Level Management ──────────────────────────────────────────────────────

  List<Level> _allLevels = [];
  List<String> _rawLevelJsons = [];
  List<bool> _solved = [];
  int _currentIndex = 0;

  Level get currentLevel => _allLevels[_currentIndex];
  List<bool> get solved => List.unmodifiable(_solved);
  int get totalLevels => _allLevels.length;
  int get currentIndex => _currentIndex;

  // ── Light State ───────────────────────────────────────────────────────────

  List<LightSegment> _segments = [];
  Map<String, Color> _litReceivers = {};
  bool _multiColorLight = false;

  List<LightSegment> get segments => _segments;
  bool get isWon => _checkWin();

  // ── Init ──────────────────────────────────────────────────────────────────

  Future<void> init() async {
    await _loadLevels();
    await _loadProgress();
    _recalcLight();
  }

  Future<void> _loadLevels() async {
    final manifest = await AssetManifest.loadFromAssetBundle(rootBundle);
    final levelPaths = manifest
        .listAssets()
        .where((k) => k.startsWith('assets/levels/') && k.endsWith('.json'))
        .toList()
      ..sort();

    _allLevels = [];
    _rawLevelJsons = [];
    for (final path in levelPaths) {
      final raw = await rootBundle.loadString(path);
      _rawLevelJsons.add(raw);
      _allLevels.add(Level.fromJson(json.decode(raw) as Map<String, dynamic>));
    }
    _solved = List.filled(_allLevels.length, false);
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList('solved') ?? [];
    for (int i = 0; i < raw.length && i < _solved.length; i++) {
      _solved[i] = raw[i] == '1';
    }
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('solved', _solved.map((b) => b ? '1' : '0').toList());
  }

  // ── Public Actions ────────────────────────────────────────────────────────

  void selectLevel(int index) {
    _currentIndex = index.clamp(0, _allLevels.length - 1);
    _rebuildLevel();
    notifyListeners();
  }

  void rotateTile(int x, int y) {
    final tile = currentLevel.tileAt(x, y);
    if (tile.type == TileType.empty ||
        tile.type == TileType.emitter ||
        tile.type == TileType.receiver) {
      return;
    }

    tile.rotate();
    _recalcLight();

    if (isWon) {
      _solved[_currentIndex] = true;
      _saveProgress();
    }

    notifyListeners();
  }

  void resetLevel() {
    _rebuildLevel();
    notifyListeners();
  }

  void nextLevel() {
    if (_currentIndex < _allLevels.length - 1) {
      _currentIndex++;
      _rebuildLevel();
      notifyListeners();
    }
  }

  void setMultiColorLight(bool v) {
    if (_multiColorLight == v) return;
    _multiColorLight = v;
    _recalcLight();
    notifyListeners();
  }

  // ── Private ───────────────────────────────────────────────────────────────

  /// Reload current level from its original JSON data (fresh state).
  void _rebuildLevel() {
    _allLevels[_currentIndex] = Level.fromJson(
      json.decode(_rawLevelJsons[_currentIndex]) as Map<String, dynamic>,
    );
    _recalcLight();
  }

  void _recalcLight() {
    // Reset lit state.
    for (final tile in currentLevel.tiles) {
      tile.isLit = false;
      tile.litColor = null;
    }

    final result = LightEngine.trace(currentLevel, multiColor: _multiColorLight);
    _segments = result.segments;
    _litReceivers = result.litReceivers;

    // Apply lit state back to tiles.
    for (final entry in _litReceivers.entries) {
      final parts = entry.key.split(',');
      final x = int.parse(parts[0]);
      final y = int.parse(parts[1]);
      final tile = currentLevel.tileAt(x, y);
      if (tile.type == TileType.receiver) {
        tile.isLit = true;
        tile.litColor = entry.value;
      }
    }
  }

  bool _checkWin() {
    if (_allLevels.isEmpty) return false;
    return currentLevel.receivers.isNotEmpty &&
        currentLevel.receivers.every((t) => t.isLit);
  }
}
