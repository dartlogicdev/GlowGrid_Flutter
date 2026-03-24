import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../state/settings_state.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.watch<SettingsState>();

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
        title: const Text(
          'SETTINGS',
          style: TextStyle(
            color: Color(0xFF00E5FF),
            letterSpacing: 4,
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const _SectionHeader('RECEIVER EFFECT'),
              const SizedBox(height: 12),
              _EffectOption(
                label: 'Particle Explosion',
                subtitle: 'Sparks burst when a receiver is hit',
                icon: Icons.auto_awesome_rounded,
                selected: settings.receiverEffect == ReceiverEffect.particles,
                onTap: () => context
                    .read<SettingsState>()
                    .setReceiverEffect(ReceiverEffect.particles),
              ),
              const SizedBox(height: 10),
              _EffectOption(
                label: 'Soft Glow',
                subtitle: 'Receiver pulses with a gentle aura',
                icon: Icons.blur_on_rounded,
                selected: settings.receiverEffect == ReceiverEffect.glow,
                onTap: () => context
                    .read<SettingsState>()
                    .setReceiverEffect(ReceiverEffect.glow),
              ),
              const SizedBox(height: 10),
              _EffectOption(
                label: 'None',
                subtitle: 'Minimalist – no extra animation',
                icon: Icons.do_not_disturb_alt_rounded,
                selected: settings.receiverEffect == ReceiverEffect.none,
                onTap: () => context
                    .read<SettingsState>()
                    .setReceiverEffect(ReceiverEffect.none),
              ),
              const SizedBox(height: 28),
              const _SectionHeader('LIGHT COLORS'),
              const SizedBox(height: 12),
              _EffectOption(
                label: 'Gleiche Farbe',
                subtitle: 'Alle Strahlen leuchten in einer Farbe',
                icon: Icons.light_mode_rounded,
                selected: !settings.multiColorLight,
                onTap: () =>
                    context.read<SettingsState>().setMultiColorLight(false),
              ),
              const SizedBox(height: 10),
              _EffectOption(
                label: 'Verschiedene Farben',
                subtitle: 'Jeder Emitter strahlt in einer anderen Farbe',
                icon: Icons.palette_rounded,
                selected: settings.multiColorLight,
                onTap: () =>
                    context.read<SettingsState>().setMultiColorLight(true),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String text;
  const _SectionHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withAlpha(100),
        fontSize: 11,
        letterSpacing: 3,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _EffectOption extends StatelessWidget {
  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _EffectOption({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = selected ? const Color(0xFF00E5FF) : const Color(0xFF334477);
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: color, width: selected ? 1.5 : 1.0),
          color: selected
              ? const Color(0xFF00E5FF).withAlpha(18)
              : const Color(0xFF10101E),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: const Color(0xFF00E5FF).withAlpha(40),
                    blurRadius: 14,
                    spreadRadius: 1,
                  )
                ]
              : null,
        ),
        child: Row(
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      color: selected ? const Color(0xFF00E5FF) : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: TextStyle(
                      color: Colors.white.withAlpha(100),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(Icons.check_circle_rounded,
                  color: Color(0xFF00E5FF), size: 20),
          ],
        ),
      ),
    );
  }
}
