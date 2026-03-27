import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../l10n/app_strings.dart';
import '../state/settings_state.dart';
import 'level_select_screen.dart';

const Color _kCyan   = Color(0xFF00E5FF);
const Color _kPurple = Color(0xFFBB88FF);
const Color _kBlue   = Color(0xFF88AAFF);
const Color _kBg     = Color(0xFF070711);
const Color _kTile   = Color(0xFF1A1A2E);
const Color _kTile2  = Color(0xFF16213E);

class IntroScreen extends StatefulWidget {
  const IntroScreen({super.key});

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen>
    with TickerProviderStateMixin {
  final PageController _pageCtrl = PageController();
  int _page = 0;
  static const int _total = 5;

  late final AnimationController _pulseCtrl;
  late final AnimationController _beamCtrl;
  late final AnimationController _altCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);
    _beamCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1600))
      ..repeat();
    _altCtrl = AnimationController(
        vsync: this, duration: const Duration(seconds: 3))
      ..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _beamCtrl.dispose();
    _altCtrl.dispose();
    _pageCtrl.dispose();
    super.dispose();
  }

  Future<void> _finish() async {
    await context.read<SettingsState>().markIntroSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const LevelSelectScreen()),
    );
  }

  void _next() {
    if (_page < _total - 1) {
      _pageCtrl.nextPage(
          duration: const Duration(milliseconds: 350), curve: Curves.easeInOut);
    } else {
      _finish();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: _kBg,
      body: SafeArea(
        child: Column(
          children: [
            // ── Top bar ───────────────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('${_page + 1} / $_total',
                      style: TextStyle(
                          color: _kCyan.withAlpha(140),
                          fontSize: 12,
                          letterSpacing: 2)),
                  TextButton(
                    onPressed: _finish,
                    child: Text(AppStrings.of(context).skip,
                        style: TextStyle(
                            color: _kBlue.withAlpha(160),
                            letterSpacing: 2,
                            fontSize: 12)),
                  ),
                ],
              ),
            ),

            // ── Pages ─────────────────────────────────────────────────────
            Expanded(
              child: PageView(
                controller: _pageCtrl,
                onPageChanged: (i) => setState(() => _page = i),
                children: [
                  _WelcomePage(pulse: _pulseCtrl),
                  _ElementPage(
                    title: AppStrings.of(context).emitterTitle,
                    color: _kCyan,
                    description: AppStrings.of(context).emitterDesc,
                    visual: AnimatedBuilder(
                      animation: _beamCtrl,
                      builder: (_, __) => CustomPaint(
                        size: const Size(220, 160),
                        painter: _EmitterPainter(_beamCtrl.value),
                      ),
                    ),
                  ),
                  _ElementPage(
                    title: AppStrings.of(context).mirrorTitle,
                    color: _kBlue,
                    description: AppStrings.of(context).mirrorDesc,
                    visual: AnimatedBuilder(
                      animation: Listenable.merge([_beamCtrl, _altCtrl]),
                      builder: (_, __) => CustomPaint(
                        size: const Size(220, 160),
                        painter: _MirrorPainter(_beamCtrl.value, _altCtrl.value),
                      ),
                    ),
                  ),
                  _ElementPage(
                    title: AppStrings.of(context).splitterTitle,
                    color: _kPurple,
                    description: AppStrings.of(context).splitterDesc,
                    visual: AnimatedBuilder(
                      animation: _beamCtrl,
                      builder: (_, __) => CustomPaint(
                        size: const Size(220, 160),
                        painter: _SplitterPainter(_beamCtrl.value),
                      ),
                    ),
                  ),
                  _ElementPage(
                    title: AppStrings.of(context).receiverTitle,
                    color: _kCyan,
                    description: AppStrings.of(context).receiverDesc,
                    visual: AnimatedBuilder(
                      animation: _pulseCtrl,
                      builder: (_, __) => CustomPaint(
                        size: const Size(220, 160),
                        painter: _ReceiverPainter(_pulseCtrl.value),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ── Page indicator dots ────────────────────────────────────────
            Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(
                  _total,
                  (i) => AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: _page == i ? 24 : 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: _page == i ? _kCyan : _kCyan.withAlpha(60),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // ── Next / Start button ────────────────────────────────────────
            GestureDetector(
              onTap: _next,
              child: Container(
                margin: const EdgeInsets.fromLTRB(32, 0, 32, 32),
                height: 52,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(color: _kCyan, width: 1.5),
                  boxShadow: [
                    BoxShadow(
                        color: _kCyan.withAlpha(60),
                        blurRadius: 20,
                        spreadRadius: 2)
                  ],
                ),
                child: Center(
                  child: Text(
                    _page == _total - 1 ? AppStrings.of(context).letsPlay : AppStrings.of(context).nextArrow,
                    style: const TextStyle(
                      color: _kCyan,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 3,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ── Page widgets ──────────────────────────────────────────────────────────────

class _WelcomePage extends StatelessWidget {
  final AnimationController pulse;
  const _WelcomePage({required this.pulse});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          AnimatedBuilder(
            animation: pulse,
            builder: (_, __) => Column(
              children: [
                Text(
                  'GLOW',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: _kCyan,
                    shadows: [
                      Shadow(
                        color: _kCyan
                            .withAlpha((100 + 120 * pulse.value).toInt()),
                        blurRadius: 20 + 16 * pulse.value,
                      )
                    ],
                  ),
                ),
                Text(
                  'GRID',
                  style: TextStyle(
                    fontSize: 56,
                    fontWeight: FontWeight.w900,
                    letterSpacing: 8,
                    color: _kPurple,
                    shadows: [
                      Shadow(
                        color: _kPurple
                            .withAlpha((100 + 120 * pulse.value).toInt()),
                        blurRadius: 20 + 16 * pulse.value,
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 36),
          Text(
            AppStrings.of(context).welcomeDescription,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withAlpha(180), fontSize: 15, height: 1.7),
          ),
          const SizedBox(height: 16),
          Text(
            AppStrings.of(context).swipeToLearn,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: _kCyan.withAlpha(160), fontSize: 13, letterSpacing: 1),
          ),
        ],
      ),
    );
  }
}

class _ElementPage extends StatelessWidget {
  final String title;
  final Color color;
  final String description;
  final Widget visual;

  const _ElementPage({
    required this.title,
    required this.color,
    required this.description,
    required this.visual,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 180, child: Center(child: visual)),
          const SizedBox(height: 28),
          Text(
            title,
            style: TextStyle(
              color: color,
              fontSize: 22,
              fontWeight: FontWeight.bold,
              letterSpacing: 5,
              shadows: [Shadow(color: color.withAlpha(160), blurRadius: 16)],
            ),
          ),
          const SizedBox(height: 14),
          Text(
            description,
            textAlign: TextAlign.center,
            style: TextStyle(
                color: Colors.white.withAlpha(180), fontSize: 14, height: 1.7),
          ),
        ],
      ),
    );
  }
}

// ── Custom Painters ───────────────────────────────────────────────────────────

/// Emitter: tile with sun icon + animated beam growing to the right.
class _EmitterPainter extends CustomPainter {
  final double t;
  const _EmitterPainter(this.t);

  @override
  void paint(Canvas canvas, Size s) {
    const double ts = 52;
    final tileTop = (s.height - ts) / 2;
    final tileBounds = Rect.fromLTWH(8, tileTop, ts, ts);

    _drawTile(canvas, tileBounds, _kCyan, _kTile);

    // Sun icon
    final c = tileBounds.center;
    final sunPaint = Paint()
      ..color = _kCyan
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;
    canvas.drawCircle(c, 9, sunPaint);
    for (int i = 0; i < 8; i++) {
      final a = i * math.pi / 4;
      canvas.drawLine(
        Offset(c.dx + 12 * math.cos(a), c.dy + 12 * math.sin(a)),
        Offset(c.dx + 16 * math.cos(a), c.dy + 16 * math.sin(a)),
        sunPaint,
      );
    }

    // Animated beam
    final beamFrom = Offset(tileBounds.right, c.dy);
    final maxLen = s.width - tileBounds.right - 10;
    final beamTo = Offset(beamFrom.dx + maxLen * t, c.dy);
    _drawBeam(canvas, beamFrom, beamTo, _kCyan);
  }

  @override
  bool shouldRepaint(_EmitterPainter o) => o.t != t;
}

/// Mirror: beam from left hits diagonal mirror, deflects up or down.
/// alt < 0.5 → '/' mirror (up);  alt ≥ 0.5 → '\' mirror (down).
class _MirrorPainter extends CustomPainter {
  final double beam;
  final double alt;
  const _MirrorPainter(this.beam, this.alt);

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    const double ts = 52;
    final tb = Rect.fromLTWH(cx - ts / 2, cy - ts / 2, ts, ts);
    final bool isSlash = alt < 0.5;

    _drawTile(canvas, tb, _kBlue, _kTile2);

    // Mirror line
    final mp = Paint()
      ..color = _kBlue
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    if (isSlash) {
      canvas.drawLine(Offset(cx - 14, cy + 14), Offset(cx + 14, cy - 14), mp);
    } else {
      canvas.drawLine(Offset(cx - 14, cy - 14), Offset(cx + 14, cy + 14), mp);
    }

    // Incoming beam
    final inLen = (tb.left - 10) * math.min(1.0, beam * 1.6);
    _drawBeam(canvas, Offset(10, cy), Offset(10 + inLen, cy), _kCyan);

    // Outgoing beam
    if (beam > 0.6) {
      final outT = ((beam - 0.6) / 0.4).clamp(0.0, 1.0);
      if (isSlash) {
        _drawBeam(canvas, Offset(cx, tb.top),
            Offset(cx, tb.top - (cy - 10) * outT), _kCyan);
      } else {
        _drawBeam(canvas, Offset(cx, tb.bottom),
            Offset(cx, tb.bottom + (s.height - cy - 10) * outT), _kCyan);
      }
    }

    // Hint label
    final tp = TextPainter(
      text: TextSpan(
          text: '⟳  TAP TO ROTATE',
          style: TextStyle(
              color: _kBlue.withAlpha(180), fontSize: 10, letterSpacing: 1.5)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(cx - tp.width / 2, tb.bottom + 8));
  }

  @override
  bool shouldRepaint(_MirrorPainter o) => o.beam != beam || o.alt != alt;
}

/// Splitter: beam from left hits center, splits up AND down.
class _SplitterPainter extends CustomPainter {
  final double t;
  const _SplitterPainter(this.t);

  @override
  void paint(Canvas canvas, Size s) {
    final cx = s.width / 2;
    final cy = s.height / 2;
    const double ts = 52;
    final tb = Rect.fromLTWH(cx - ts / 2, cy - ts / 2, ts, ts);

    _drawTile(canvas, tb, _kPurple, _kTile2);

    // Splitter icon (vertical | with horizontal arms)
    final sp = Paint()
      ..color = _kPurple
      ..strokeWidth = 3
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(Offset(cx, cy - 14), Offset(cx, cy + 14), sp);
    canvas.drawLine(Offset(cx - 14, cy), Offset(cx - 4, cy), sp);
    canvas.drawLine(Offset(cx + 4, cy), Offset(cx + 14, cy), sp);

    // Incoming beam
    final inLen = (tb.left - 10) * math.min(1.0, t * 1.5);
    _drawBeam(canvas, Offset(10, cy), Offset(10 + inLen, cy), _kCyan);

    // Split beams
    if (t > 0.4) {
      final outT = ((t - 0.4) / 0.6).clamp(0.0, 1.0);
      _drawBeam(canvas, Offset(cx, tb.top),
          Offset(cx, tb.top - (tb.top - 10) * outT), _kCyan);
      _drawBeam(canvas, Offset(cx, tb.bottom),
          Offset(cx, tb.bottom + (s.height - tb.bottom - 10) * outT), _kCyan);
    }
  }

  @override
  bool shouldRepaint(_SplitterPainter o) => o.t != t;
}

/// Receiver: inactive (left) vs pulsing lit receiver (right).
class _ReceiverPainter extends CustomPainter {
  final double t;
  const _ReceiverPainter(this.t);

  @override
  void paint(Canvas canvas, Size s) {
    final cy = s.height / 2;
    const double ts = 52;
    const double gap = 20;
    final leftX  = s.width / 2 - ts - gap / 2;
    final rightX = s.width / 2 + gap / 2;

    // ── Inactive (left) ──
    _drawTile(canvas,
        Rect.fromLTWH(leftX, cy - ts / 2, ts, ts),
        const Color(0xFF444466), _kTile);
    canvas.drawCircle(
      Offset(leftX + ts / 2, cy), 10,
      Paint()
        ..color = const Color(0xFF444466)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawLabel(canvas, 'INACTIVE',
        Offset(leftX + ts / 2, cy + ts / 2 + 10), Colors.white.withAlpha(80));

    // ── Lit (right) with pulse ──
    final litColor = _kCyan;
    _drawTile(canvas,
        Rect.fromLTWH(rightX, cy - ts / 2, ts, ts),
        litColor,
        Color.lerp(_kTile, litColor.withAlpha(60), t)!);
    final rcx = rightX + ts / 2;
    // Glow
    canvas.drawCircle(
      Offset(rcx, cy), 12 + 4 * t,
      Paint()
        ..color = litColor.withAlpha((60 * t).toInt())
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 10),
    );
    // Dot
    canvas.drawCircle(Offset(rcx, cy), 10,
        Paint()..color = litColor.withAlpha((200 * t + 40).toInt()));
    // Border
    canvas.drawCircle(
      Offset(rcx, cy), 12,
      Paint()
        ..color = litColor
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
    _drawLabel(canvas, 'ACTIVATED!',
        Offset(rcx, cy + ts / 2 + 10),
        litColor.withAlpha((200 * t + 40).toInt()));
  }

  void _drawLabel(Canvas canvas, String text, Offset pos, Color color) {
    final tp = TextPainter(
      text: TextSpan(
          text: text,
          style: TextStyle(color: color, fontSize: 10, letterSpacing: 1)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(canvas, Offset(pos.dx - tp.width / 2, pos.dy));
  }

  @override
  bool shouldRepaint(_ReceiverPainter o) => o.t != t;
}

// ── Shared drawing helpers ────────────────────────────────────────────────────

void _drawTile(Canvas canvas, Rect rect, Color border, Color bg) {
  final rr = RRect.fromRectAndRadius(rect, const Radius.circular(8));
  canvas.drawRRect(rr, Paint()..color = bg);
  canvas.drawRRect(rr,
      Paint()
        ..color = border
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5);
}

void _drawBeam(Canvas canvas, Offset from, Offset to, Color color) {
  if ((from - to).distance < 1) return;
  canvas.drawLine(from, to,
      Paint()
        ..color = color.withAlpha(40)
        ..strokeWidth = 14
        ..strokeCap = StrokeCap.round);
  canvas.drawLine(from, to,
      Paint()
        ..color = color.withAlpha(200)
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round);
}
