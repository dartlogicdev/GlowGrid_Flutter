import 'tile.dart';
import 'tile_type.dart';

class Level {
  final int id;
  final int gridSize;
  final List<Tile> tiles;

  /// Minimum number of moves to solve this level optimally (0 = not tracked).
  final int minMoves;

  /// When true, the player may place inventory pieces on any empty cell
  /// (not just pre-defined slot tiles).
  final bool freePlacement;

  Level({
    required this.id,
    required this.gridSize,
    required this.tiles,
    this.minMoves = 0,
    this.freePlacement = false,
  });

  factory Level.fromJson(Map<String, dynamic> json) {
    final rawTiles = json['tiles'] as List<dynamic>;
    final tiles = rawTiles
        .map((t) => Tile.fromJson(t as Map<String, dynamic>))
        .toList();

    // Fill remaining cells as empty tiles.
    final int size = json['grid_size'] as int;
    final Set<String> occupied = {for (final t in tiles) '${t.x},${t.y}'};
    for (int y = 0; y < size; y++) {
      for (int x = 0; x < size; x++) {
        if (!occupied.contains('$x,$y')) {
          tiles.add(Tile(x: x, y: y, type: TileType.empty));
        }
      }
    }

    return Level(
      id: json['level_id'] as int,
      gridSize: size,
      tiles: tiles,
      minMoves: json['min_moves'] as int? ?? 0,
      freePlacement: json['free_placement'] as bool? ?? false,
    );
  }

  Tile tileAt(int x, int y) =>
      tiles.firstWhere((t) => t.x == x && t.y == y,
          orElse: () => Tile(x: x, y: y, type: TileType.empty));

  List<Tile> get receivers =>
      tiles.where((t) => t.type == TileType.receiver).toList();

  List<Tile> get emitters =>
      tiles.where((t) => t.type == TileType.emitter).toList();
}
