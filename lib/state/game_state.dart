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

  // ── Placement / Inventory ─────────────────────────────────────────────────

  /// Pieces placed by the player into slot cells: "x,y" → (type, rotation).
  final Map<String, (TileType, int)> _placedTiles = {};

  /// Remaining inventory: number of mirrors and splitters to place.
  int _inventoryMirrors = 0;
  int _inventorySplitters = 0;

  Map<String, (TileType, int)> get placedTiles =>
      Map.unmodifiable(_placedTiles);
  int get inventoryMirrors => _inventoryMirrors;
  int get inventorySplitters => _inventorySplitters;

  /// Whether the current level uses the placement mechanic.
  bool get isPlacementLevel =>
      currentLevel.tiles.any((t) => t.type == TileType.slot);

  /// Place a piece on a slot. Returns false if the slot is occupied or the
  /// inventory is empty / the tile is not a slot.
  bool placeTile(int x, int y, TileType type) {
    final tile = currentLevel.tileAt(x, y);
    if (tile.type != TileType.slot) return false;
    final key = '$x,$y';
    if (_placedTiles.containsKey(key)) return false;

    if (type == TileType.mirror) {
      if (_inventoryMirrors <= 0) return false;
      _inventoryMirrors--;
    } else if (type == TileType.splitter) {
      if (_inventorySplitters <= 0) return false;
      _inventorySplitters--;
    } else {
      return false;
    }

    _placedTiles[key] = (type, 0);
    _recalcLight();
    if (isWon) {
      _solved[_currentIndex] = true;
      _saveProgress();
    }
    notifyListeners();
    return true;
  }

  /// Remove a placed piece from a slot and return it to inventory.
  void removePlacedTile(int x, int y) {
    final key = '$x,$y';
    final placed = _placedTiles.remove(key);
    if (placed == null) return;
    final (type, _) = placed;
    if (type == TileType.mirror) _inventoryMirrors++;
    if (type == TileType.splitter) _inventorySplitters++;
    _recalcLight();
    notifyListeners();
  }

  /// Rotate a placed piece on a slot.
  void rotatePlacedTile(int x, int y) {
    final key = '$x,$y';
    final placed = _placedTiles[key];
    if (placed == null) return;
    final (type, rot) = placed;
    _placedTiles[key] = (type, (rot + 1) % 4);
    _recalcLight();
    if (isWon) {
      _solved[_currentIndex] = true;
      _saveProgress();
    }
    notifyListeners();
  }

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
    _placedTiles.clear();
    _rebuildLevel();
    notifyListeners();
  }

  void rotateTile(int x, int y) {
    final tile = currentLevel.tileAt(x, y);

    // Slot with placed piece → rotate it.
    if (tile.type == TileType.slot) {
      rotatePlacedTile(x, y);
      return;
    }

    if (tile.type == TileType.empty ||
        tile.type == TileType.emitter ||
        tile.type == TileType.receiver ||
        tile.type == TileType.wall) {
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
    _placedTiles.clear();
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
    _placedTiles.clear();
    final decoded =
        json.decode(_rawLevelJsons[_currentIndex]) as Map<String, dynamic>;
    _allLevels[_currentIndex] = Level.fromJson(decoded);
    // Restore inventory counts from level definition.
    _inventoryMirrors = decoded['inventory_mirrors'] as int? ?? 0;
    _inventorySplitters = decoded['inventory_splitters'] as int? ?? 0;
    _recalcLight();
  }

  void _recalcLight() {
    // Reset lit state.
    for (final tile in currentLevel.tiles) {
      tile.isLit = false;
      tile.litColor = null;
    }

    final result = LightEngine.trace(
      currentLevel,
      multiColor: _multiColorLight,
      placedTiles: Map.unmodifiable(_placedTiles),
    );
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
