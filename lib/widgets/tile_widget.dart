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
    final bool interactive = tile.type == TileType.mirror ||
        tile.type == TileType.splitter ||
        tile.type == TileType.prism;

    Widget child = _buildTileContent(context);

    if (interactive) {
      child = GestureDetector(
        onTap: () {
          HapticFeedback.lightImpact();
          context.read<GameState>().rotateTile(tile.x, tile.y);
        },
        child: child,
      );
    }

    return child;
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
      case TileType.empty:
        return const SizedBox.shrink();
    }
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
