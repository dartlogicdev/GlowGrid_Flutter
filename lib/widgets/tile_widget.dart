import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import '../models/tile.dart';
import '../models/tile_type.dart';
import '../state/game_state.dart';
import '../state/settings_state.dart';
import 'receiver_hit_effect.dart';

class TileWidget extends StatelessWidget {
  final Tile tile;

  const TileWidget({super.key, required this.tile});

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameState>();

    // ── Slot tile ──────────────────────────────────────────────────────────
    if (tile.type == TileType.slot) {
      return _SlotTileWidget(tile: tile);
    }

    // ── Wall tile ──────────────────────────────────────────────────────────
    if (tile.type == TileType.wall) {
      return _buildWallTile();
    }

    // ── Normal interactive tiles ───────────────────────────────────────────
    final bool interactive = tile.type == TileType.mirror ||
        tile.type == TileType.splitter ||
        tile.type == TileType.prism;

    Widget child = _buildTileContent(context);

    if (interactive) {
      child = GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          state.rotateTile(tile.x, tile.y);
        },
        child: child,
      );
    }

    return child;
  }

  Widget _buildWallTile() {
    return Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: const Color(0xFF1C0A00),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF663300), width: 1.2),
      ),
      child: const Center(
        child: Icon(Icons.square_rounded, color: Color(0xFF994400), size: 18),
      ),
    );
  }

  Widget _buildTileContent(BuildContext context) {
    final container = Container(
      margin: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: _borderColor,
          width: 1.2,
        ),
        boxShadow: tile.isLit
            ? [
                BoxShadow(
                  color: (tile.litColor ?? const Color(0xFF00E5FF)).withAlpha(120),
                  blurRadius: 12,
                  spreadRadius: 2,
                )
              ]
            : null,
      ),
      child: Center(child: _buildIcon()),
    );

    if (tile.type == TileType.receiver) {
      final effect = context.watch<SettingsState>().receiverEffect;
      return ReceiverHitEffect(
        isLit: tile.isLit,
        color: tile.litColor ?? tile.color ?? const Color(0xFF00E5FF),
        effect: effect,
        child: container,
      );
    }

    return container;
  }

  Color get _backgroundColor {
    switch (tile.type) {
      case TileType.emitter:
        return const Color(0xFF1A1A2E);
      case TileType.receiver:
        return tile.isLit
            ? (tile.litColor ?? const Color(0xFF00E5FF)).withAlpha(60)
            : const Color(0xFF1A1A2E);
      case TileType.mirror:
        return const Color(0xFF16213E);
      case TileType.splitter:
        return const Color(0xFF16213E);
      case TileType.prism:
        return const Color(0xFF16213E);
      case TileType.wall:
        return const Color(0xFF1C0A00);
      case TileType.slot:
        return const Color(0xFF0A120A);
      case TileType.empty:
        return const Color(0xFF0F0F1A);
    }
  }

  Color get _borderColor {
    switch (tile.type) {
      case TileType.emitter:
        return const Color(0xFF00E5FF);
      case TileType.receiver:
        return tile.isLit
            ? (tile.litColor ?? const Color(0xFF00E5FF))
            : const Color(0xFF444466);
      case TileType.mirror:
      case TileType.splitter:
      case TileType.prism:
        return const Color(0xFF334477);
      case TileType.wall:
        return const Color(0xFF663300);
      case TileType.slot:
        return const Color(0xFF1A3A1A);
      case TileType.empty:
        return const Color(0xFF1A1A2E);
    }
  }

  Widget _buildIcon() {
    switch (tile.type) {
      case TileType.emitter:
        return Icon(Icons.wb_sunny_rounded,
            color: tile.color ?? const Color(0xFF00E5FF), size: 22);
      case TileType.receiver:
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: tile.isLit
                ? (tile.litColor ?? const Color(0xFF00E5FF))
                : Colors.transparent,
            border: Border.all(
              color: tile.isLit
                  ? (tile.litColor ?? const Color(0xFF00E5FF))
                  : const Color(0xFF444466),
              width: 2,
            ),
          ),
        );
      case TileType.mirror:
        return _MirrorIcon(rotation: tile.rotation);
      case TileType.splitter:
        return _SplitterIcon(rotation: tile.rotation);
      case TileType.prism:
        return _PrismIcon();
      case TileType.wall:
        return const Icon(Icons.square_rounded, color: Color(0xFF994400), size: 18);
      case TileType.slot:
      case TileType.empty:
        return const SizedBox.shrink();
    }
  }
}

// ── Slot Tile Widget ──────────────────────────────────────────────────────────

class _SlotTileWidget extends StatelessWidget {
  final Tile tile;
  const _SlotTileWidget({required this.tile});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final key = '${tile.x},${tile.y}';
    final placed = state.placedTiles[key];

    if (placed != null) {
      final (type, rot) = placed;
      return GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          state.rotatePlacedTile(tile.x, tile.y);
        },
        onLongPress: () {
          HapticFeedback.mediumImpact();
          state.removePlacedTile(tile.x, tile.y);
        },
        child: Container(
          margin: const EdgeInsets.all(2),
          decoration: BoxDecoration(
            color: const Color(0xFF0A2A0A),
            borderRadius: BorderRadius.circular(6),
            border: Border.all(color: const Color(0xFF33AA33), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF33AA33).withAlpha(60),
                blurRadius: 8,
              )
            ],
          ),
          child: Center(
            child: type == TileType.mirror
                ? _MirrorIcon(rotation: rot)
                : _SplitterIcon(rotation: rot),
          ),
        ),
      );
    }

    // Empty slot — tap to open placement picker.
    return GestureDetector(
      onTap: () => _showPlacePicker(context, state),
      child: Container(
        margin: const EdgeInsets.all(2),
        decoration: BoxDecoration(
          color: const Color(0xFF0A120A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: const Color(0xFF1A3A1A),
            width: 1.2,
          ),
        ),
        child: Center(
          child: Icon(
            Icons.add_rounded,
            color: const Color(0xFF33AA33).withAlpha(140),
            size: 16,
          ),
        ),
      ),
    );
  }

  void _showPlacePicker(BuildContext context, GameState state) {
    final hasMirror = state.inventoryMirrors > 0;
    final hasSplitter = state.inventorySplitters > 0;
    if (!hasMirror && !hasSplitter) return;

    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF0D0D1F),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'PLACE ELEMENT',
              style: TextStyle(
                color: const Color(0xFF33AA33),
                letterSpacing: 3,
                fontSize: 13,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                if (hasMirror)
                  _PickerButton(
                    label: 'MIRROR',
                    count: state.inventoryMirrors,
                    icon: CustomPaint(
                      size: const Size(32, 32),
                      painter: _MirrorPainter(rotation: 0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      state.placeTile(tile.x, tile.y, TileType.mirror);
                    },
                  ),
                if (hasSplitter)
                  _PickerButton(
                    label: 'SPLITTER',
                    count: state.inventorySplitters,
                    icon: CustomPaint(
                      size: const Size(32, 32),
                      painter: _SplitterPainter(rotation: 0),
                    ),
                    onTap: () {
                      Navigator.pop(context);
                      state.placeTile(tile.x, tile.y, TileType.splitter);
                    },
                  ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}

class _PickerButton extends StatelessWidget {
  final String label;
  final int count;
  final Widget icon;
  final VoidCallback onTap;
  const _PickerButton(
      {required this.label,
      required this.count,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFF33AA33), width: 1.5),
          color: const Color(0xFF0A2A0A),
        ),
        child: Column(
          children: [
            icon,
            const SizedBox(height: 10),
            Text(label,
                style: const TextStyle(
                    color: Color(0xFF88FFAA),
                    fontSize: 12,
                    letterSpacing: 2)),
            Text('x$count',
                style: TextStyle(
                    color: Colors.white.withAlpha(160), fontSize: 11)),
          ],
        ),
      ),
    );
  }
}

// ── Tile Icon Widgets ─────────────────────────────────────────────────────────

class _MirrorIcon extends StatelessWidget {
  final int rotation;
  const _MirrorIcon({required this.rotation});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _MirrorPainter(rotation: rotation),
    );
  }
}

class _MirrorPainter extends CustomPainter {
  final int rotation;
  const _MirrorPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFF88AAFF)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    if (rotation % 2 == 0) {
      // "/" mirror
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.9),
        Offset(size.width * 0.9, size.height * 0.1),
        paint,
      );
    } else {
      // "\" mirror
      canvas.drawLine(
        Offset(size.width * 0.1, size.height * 0.1),
        Offset(size.width * 0.9, size.height * 0.9),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_MirrorPainter old) => old.rotation != rotation;
}

class _SplitterIcon extends StatelessWidget {
  final int rotation;
  const _SplitterIcon({required this.rotation});

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _SplitterPainter(rotation: rotation),
    );
  }
}

class _SplitterPainter extends CustomPainter {
  final int rotation;
  const _SplitterPainter({required this.rotation});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = const Color(0xFFBB88FF)
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    if (rotation % 2 == 0) {
      // "—" horizontal splitter
      canvas.drawLine(
        Offset(size.width * 0.05, size.height * 0.5),
        Offset(size.width * 0.95, size.height * 0.5),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.05),
        Offset(size.width * 0.5, size.height * 0.45),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.55),
        Offset(size.width * 0.5, size.height * 0.95),
        paint,
      );
    } else {
      // "|" vertical splitter
      canvas.drawLine(
        Offset(size.width * 0.5, size.height * 0.05),
        Offset(size.width * 0.5, size.height * 0.95),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.05, size.height * 0.5),
        Offset(size.width * 0.45, size.height * 0.5),
        paint,
      );
      canvas.drawLine(
        Offset(size.width * 0.55, size.height * 0.5),
        Offset(size.width * 0.95, size.height * 0.5),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_SplitterPainter old) => old.rotation != rotation;
}

class _PrismIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      size: const Size(24, 24),
      painter: _PrismPainter(),
    );
  }
}

class _PrismPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path()
      ..moveTo(size.width * 0.5, size.height * 0.05)
      ..lineTo(size.width * 0.95, size.height * 0.9)
      ..lineTo(size.width * 0.05, size.height * 0.9)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..shader = const LinearGradient(
          colors: [Color(0xFFFF0080), Color(0xFF00E5FF), Color(0xFF66FF00)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ).createShader(Rect.fromLTWH(0, 0, size.width, size.height))
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
