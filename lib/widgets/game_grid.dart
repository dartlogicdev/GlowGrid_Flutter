import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';
import '../widgets/tile_widget.dart';
import '../widgets/light_painter.dart';

class GameGrid extends StatelessWidget {
  const GameGrid({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final level = state.currentLevel;

    return LayoutBuilder(builder: (context, constraints) {
      final size = constraints.biggest;
      final padding = 16.0;
      final availableSize =
          (size.shortestSide - padding * 2).clamp(100.0, 500.0);
      final cellSize = availableSize / level.gridSize;
      final offsetX = (size.width - availableSize) / 2;
      final offsetY = (size.height - availableSize) / 2;

      return Stack(
        children: [
          // Tile grid.
          Positioned(
            left: offsetX,
            top: offsetY,
            width: availableSize,
            height: availableSize,
            child: Column(
              children: List.generate(level.gridSize, (y) {
                return Expanded(
                  child: Row(
                    children: List.generate(level.gridSize, (x) {
                      return Expanded(
                        child: TileWidget(
                          key: ValueKey('$x,$y'),
                          tile: level.tileAt(x, y),
                        ),
                      );
                    }),
                  ),
                );
              }),
            ),
          ),

          // Light beam overlay (IgnorePointer so taps reach the tiles below).
          Positioned.fill(
            child: IgnorePointer(
              child: CustomPaint(
                painter: LightPainter(
                  segments: state.segments,
                  cellSize: cellSize,
                  offsetX: offsetX,
                  offsetY: offsetY,
                ),
              ),
            ),
          ),
        ],
      );
    });
  }
}
