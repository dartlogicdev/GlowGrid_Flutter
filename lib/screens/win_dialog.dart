import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../state/game_state.dart';
import '../state/level_stars_state.dart';

class WinDialog extends StatefulWidget {
  const WinDialog({super.key});

  @override
  State<WinDialog> createState() => _WinDialogState();
}

class _WinDialogState extends State<WinDialog> {
  int _stars = 0;
  int _moveCount = 0;
  bool _hasMinMoves = false;
  bool _initialized = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_initialized) {
      _initialized = true;
      final gameState = context.read<GameState>();
      _stars = gameState.calculateStars();
      _moveCount = gameState.moveCount;
      _hasMinMoves = gameState.currentLevel.minMoves > 0;
      context
          .read<LevelStarsState>()
          .setStars(gameState.currentLevel.id, _stars);
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameState>();
    final s = AppStrings.of(context);
    final hasNext = state.currentIndex < state.totalLevels - 1;

    return Dialog(
      backgroundColor: const Color(0xFF0D0D1F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Check icon
            Container(
              width: 70,
              height: 70,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: const Color(0xFF00E5FF), width: 2),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withAlpha(80),
                    blurRadius: 20,
                    spreadRadius: 4,
                  )
                ],
              ),
              child: const Icon(
                Icons.check_rounded,
                color: Color(0xFF00E5FF),
                size: 40,
              ),
            ),
            const SizedBox(height: 24),

            Text(
              s.levelComplete,
              style: const TextStyle(
                color: Color(0xFF00E5FF),
                fontSize: 20,
                fontWeight: FontWeight.bold,
                letterSpacing: 4,
                shadows: [
                  Shadow(color: Color(0xFF00E5FF), blurRadius: 12),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              s.allReceiversActivated,
              style: TextStyle(
                color: Colors.white.withAlpha(160),
                fontSize: 13,
              ),
            ),

            // Star rating (only for placement levels with min_moves defined)
            if (_hasMinMoves) ...[
              const SizedBox(height: 28),
              _StarsDisplay(stars: _stars),
              const SizedBox(height: 10),
              Text(
                '${s.movesLabel}: $_moveCount',
                style: TextStyle(
                  color: Colors.white.withAlpha(130),
                  fontSize: 12,
                  letterSpacing: 1,
                ),
              ),
            ],

            const SizedBox(height: 32),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _DialogButton(
                  label: s.replay,
                  color: const Color(0xFF334477),
                  textColor: const Color(0xFF88AAFF),
                  onTap: () {
                    Navigator.pop(context);
                    state.resetLevel();
                  },
                ),
                if (hasNext) ...[
                  const SizedBox(width: 16),
                  _DialogButton(
                    label: s.next,
                    color: const Color(0xFF00E5FF),
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.pop(context);
                      state.nextLevel();
                    },
                  ),
                ] else ...[
                  const SizedBox(width: 16),
                  _DialogButton(
                    label: s.menu,
                    color: const Color(0xFF00E5FF),
                    textColor: Colors.black,
                    onTap: () {
                      Navigator.of(context).popUntil((route) => route.isFirst);
                    },
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ── Animated star row ─────────────────────────────────────────────────────────

class _StarsDisplay extends StatefulWidget {
  final int stars;
  const _StarsDisplay({required this.stars});

  @override
  State<_StarsDisplay> createState() => _StarsDisplayState();
}

class _StarsDisplayState extends State<_StarsDisplay>
    with TickerProviderStateMixin {
  late final List<AnimationController> _controllers;
  late final List<Animation<double>> _scales;

  @override
  void initState() {
    super.initState();
    _controllers = List.generate(
      5,
      (i) => AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 380),
      ),
    );
    _scales = _controllers
        .map((c) => CurvedAnimation(parent: c, curve: Curves.elasticOut))
        .toList();

    for (int i = 0; i < 5; i++) {
      Future.delayed(Duration(milliseconds: 120 + i * 130), () {
        if (mounted) { _controllers[i].forward(); }
      });
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(5, (i) {
        final earned = i < widget.stars;
        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: ScaleTransition(
            scale: _scales[i],
            child: Icon(
              earned ? Icons.star_rounded : Icons.star_outline_rounded,
              color: earned
                  ? const Color(0xFFFFCC00)
                  : Colors.white.withAlpha(55),
              size: 40,
            ),
          ),
        );
      }),
    );
  }
}

// ── Dialog button ─────────────────────────────────────────────────────────────

class _DialogButton extends StatelessWidget {
  final String label;
  final Color color;
  final Color textColor;
  final VoidCallback onTap;

  const _DialogButton({
    required this.label,
    required this.color,
    required this.textColor,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
            letterSpacing: 2,
            fontSize: 14,
          ),
        ),
      ),
    );
  }
}
