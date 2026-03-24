import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/game_state.dart';

class WinDialog extends StatelessWidget {
  const WinDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.read<GameState>();
    final hasNext = state.currentIndex < state.totalLevels - 1;

    return Dialog(
      backgroundColor: const Color(0xFF0D0D1F),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Icon
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

            const Text(
              'LEVEL COMPLETE',
              style: TextStyle(
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
              'All receivers activated!',
              style: TextStyle(
                color: Colors.white.withAlpha(160),
                fontSize: 13,
              ),
            ),
            const SizedBox(height: 32),

            // Buttons row
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Replay button
                _DialogButton(
                  label: 'REPLAY',
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
                    label: 'NEXT',
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
                    label: 'MENU',
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
