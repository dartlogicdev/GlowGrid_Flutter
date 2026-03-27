import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../state/game_state.dart';
import '../state/settings_state.dart';
import 'intro_screen.dart';
import 'level_select_screen.dart';
import 'settings_screen.dart';

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final s = AppStrings.of(context);
    final solvedCount = state.solved.where((s) => s).length;

    return Scaffold(
      backgroundColor: const Color(0xFF070711),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Logo / Title
              _GlowText(
                'GLOW',
                fontSize: 64,
                color: const Color(0xFF00E5FF),
              ),
              _GlowText(
                'GRID',
                fontSize: 64,
                color: const Color(0xFFBB88FF),
              ),
              const SizedBox(height: 12),
              Text(
                s.lightBeamPuzzle,
                style: TextStyle(
                  color: Colors.white.withAlpha(120),
                  fontSize: 14,
                  letterSpacing: 3,
                ),
              ),
              const SizedBox(height: 60),

              // Stat badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0xFF334477)),
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Text(
                  s.levelsSolved(solvedCount, state.totalLevels),
                  style: const TextStyle(
                    color: Color(0xFF88AAFF),
                    fontSize: 13,
                    letterSpacing: 2,
                  ),
                ),
              ),
              const SizedBox(height: 40),

              // Play button
              _NeonButton(
                label: s.play,
                color: const Color(0xFF00E5FF),
                onPressed: () {
                  final settings = context.read<SettingsState>();
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => settings.introSeen
                          ? const LevelSelectScreen()
                          : const IntroScreen(),
                    ),
                  );
                },
              ),
              const SizedBox(height: 16),
              _NeonButton(
                label: s.settings,
                color: const Color(0xFFBB88FF),
                onPressed: () => Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const SettingsScreen()),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Reusable widgets ──────────────────────────────────────────────────────────

class _GlowText extends StatelessWidget {
  final String text;
  final double fontSize;
  final Color color;

  const _GlowText(this.text, {required this.fontSize, required this.color});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.w900,
        letterSpacing: 10,
        color: color,
        shadows: [
          Shadow(color: color.withAlpha(180), blurRadius: 20),
          Shadow(color: color.withAlpha(80),  blurRadius: 60),
        ],
      ),
    );
  }
}

class _NeonButton extends StatelessWidget {
  final String label;
  final Color color;
  final VoidCallback onPressed;

  const _NeonButton({
    required this.label,
    required this.color,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        width: 200,
        height: 52,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          border: Border.all(color: color, width: 1.5),
          boxShadow: [
            BoxShadow(color: color.withAlpha(60), blurRadius: 20, spreadRadius: 2),
          ],
        ),
        child: Center(
          child: Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 4,
            ),
          ),
        ),
      ),
    );
  }
}
