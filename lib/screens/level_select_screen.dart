import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../state/game_state.dart';
import '../state/level_stars_state.dart';
import 'game_screen.dart';

class LevelSelectScreen extends StatelessWidget {
  const LevelSelectScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final starsState = context.watch<LevelStarsState>();
    final s = AppStrings.of(context);

    return Scaffold(
      backgroundColor: const Color(0xFF070711),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Color(0xFF88AAFF)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          s.selectLevel,
          style: const TextStyle(
            color: Color(0xFF00E5FF),
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 4,
            crossAxisSpacing: 12,
            mainAxisSpacing: 12,
            childAspectRatio: 0.88,
          ),
          itemCount: state.totalLevels,
          itemBuilder: (context, index) {
            final isSolved = state.solved[index];
            final levelId = index + 1;
            final stars = starsState.getStars(levelId);
            final color = isSolved
                ? const Color(0xFF00E5FF)
                : const Color(0xFF334477);

            return GestureDetector(
              onTap: () {
                state.selectLevel(index);
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const GameScreen()),
                );
              },
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: color, width: 1.5),
                  boxShadow: isSolved
                      ? [
                          BoxShadow(
                            color: const Color(0xFF00E5FF).withAlpha(50),
                            blurRadius: 10,
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$levelId',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: color,
                      ),
                    ),
                    const SizedBox(height: 4),
                    _MiniStars(stars: stars),
                    if (isSolved && stars == 0) ...[
                      const SizedBox(height: 2),
                      const Icon(
                        Icons.check_circle_outline_rounded,
                        color: Color(0xFF00E5FF),
                        size: 12,
                      ),
                    ],
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _MiniStars extends StatelessWidget {
  final int stars;
  const _MiniStars({required this.stars});

  @override
  Widget build(BuildContext context) {
    if (stars == 0) return const SizedBox(height: 11);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: List.generate(5, (i) {
        final earned = i < stars;
        return Icon(
          earned ? Icons.star_rounded : Icons.star_outline_rounded,
          color: earned ? const Color(0xFFFFCC00) : Colors.white.withAlpha(35),
          size: 9,
        );
      }),
    );
  }
}
