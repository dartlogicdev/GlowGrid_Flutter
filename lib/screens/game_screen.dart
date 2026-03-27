import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../l10n/app_strings.dart';
import '../state/game_state.dart';
import '../widgets/game_grid.dart';
import 'win_dialog.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  bool _winShown = false;
  Timer? _winTimer;

  @override
  void dispose() {
    _winTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = context.watch<GameState>();
    final s = AppStrings.of(context);

    // Show win dialog once per completion, with a short delay.
    if (state.isWon && !_winShown) {
      _winShown = true;
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _winTimer?.cancel();
        _winTimer = Timer(const Duration(milliseconds: 1200), () {
          if (mounted) {
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (_) => const WinDialog(),
            ).then((_) {
              if (mounted) setState(() => _winShown = false);
            });
          }
        });
      });
    } else if (!state.isWon) {
      _winShown = false;
    }

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
          s.levelN(state.currentIndex + 1),
          style: const TextStyle(
            color: Color(0xFF00E5FF),
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh_rounded, color: Color(0xFF88AAFF)),
            tooltip: s.resetLevel,
            onPressed: () {
              state.resetLevel();
              setState(() => _winShown = false);
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Info bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _statChip(
                  icon: Icons.radio_button_checked_rounded,
                  label:
                      '${state.currentLevel.receivers.where((r) => r.isLit).length}'
                      '/${state.currentLevel.receivers.length} LIT',
                  color: const Color(0xFF00E5FF),
                ),
                _legendChip('/ Mirror',   const Color(0xFF88AAFF)),
                _legendChip('+ Split',    const Color(0xFFBB88FF)),
                _legendChip('△ Prism',   const Color(0xFF88FF88)),
              ],
            ),
          ),

          // Grid
          Expanded(child: const GameGrid()),

          // Inventory bar (only for placement levels)
          if (state.isPlacementLevel) ...[
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _InventoryChip(
                    icon: Icons.commit_rounded,
                    label: 'MIRROR',
                    count: state.inventoryMirrors,
                    color: const Color(0xFF88AAFF),
                  ),
                  const SizedBox(width: 16),
                  _InventoryChip(
                    icon: Icons.add_rounded,
                    label: 'SPLITTER',
                    count: state.inventorySplitters,
                    color: const Color(0xFFBB88FF),
                  ),
                ],
              ),
            ),
          ],

          // Hint text
          Padding(
            padding: const EdgeInsets.only(bottom: 12),
            child: Text(
              state.isPlacementLevel
                  ? _placementHint(s)
                  : s.gameHint,
              style: TextStyle(
                color: Colors.white.withAlpha(70),
                fontSize: 11,
                letterSpacing: 1,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statChip({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Row(
      children: [
        Icon(icon, color: color, size: 14),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(
                color: color, fontSize: 12, fontWeight: FontWeight.bold)),
      ],
    );
  }

  Widget _legendChip(String label, Color color) {
    return Text(
      label,
      style: TextStyle(
        color: color.withAlpha(160),
        fontSize: 10,
        letterSpacing: 1,
      ),
    );
  }

  String _placementHint(AppStrings s) {
    // Reuse the language system — just use a simple english-only fallback here,
    // the key will be added to AppStrings below.
    return s.placementHint;
  }
}

// ── Inventory Chip ─────────────────────────────────────────────────────────────

class _InventoryChip extends StatelessWidget {
  final IconData icon;
  final String label;
  final int count;
  final Color color;

  const _InventoryChip({
    required this.icon,
    required this.label,
    required this.count,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: count > 0 ? color : color.withAlpha(60),
          width: 1.2,
        ),
        color: count > 0 ? color.withAlpha(18) : Colors.transparent,
      ),
      child: Row(
        children: [
          Icon(icon, color: count > 0 ? color : color.withAlpha(80), size: 14),
          const SizedBox(width: 6),
          Text(
            '$label  ×$count',
            style: TextStyle(
              color: count > 0 ? color : color.withAlpha(80),
              fontSize: 11,
              fontWeight: FontWeight.w600,
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
