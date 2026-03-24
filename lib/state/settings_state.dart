import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Which visual effect fires when a receiver is activated.
enum ReceiverEffect { particles, glow, none }

class SettingsState extends ChangeNotifier {
  ReceiverEffect _receiverEffect = ReceiverEffect.particles;
  bool _multiColorLight = false;
  bool _introSeen = false;

  ReceiverEffect get receiverEffect => _receiverEffect;
  bool get multiColorLight => _multiColorLight;
  bool get introSeen => _introSeen;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString('receiver_effect') ?? 'particles';
    _receiverEffect = ReceiverEffect.values.firstWhere(
      (e) => e.name == raw,
      orElse: () => ReceiverEffect.particles,
    );
    _multiColorLight = prefs.getBool('multi_color_light') ?? false;
    _introSeen = prefs.getBool('intro_seen') ?? false;
  }

  Future<void> setReceiverEffect(ReceiverEffect effect) async {
    if (_receiverEffect == effect) return;
    _receiverEffect = effect;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('receiver_effect', effect.name);
  }

  Future<void> setMultiColorLight(bool v) async {
    if (_multiColorLight == v) return;
    _multiColorLight = v;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('multi_color_light', v);
  }

  Future<void> markIntroSeen() async {
    if (_introSeen) return;
    _introSeen = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('intro_seen', true);
  }
}
