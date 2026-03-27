import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../l10n/app_strings.dart';

class LocaleState extends ChangeNotifier {
  static const _kKey = 'language_code';

  String _languageCode = 'en';

  String get languageCode => _languageCode;
  Locale get locale => Locale(_languageCode);

  /// Returns the system language code if it is supported, otherwise 'en'.
  static String _resolveSystemLanguage() {
    final supported =
        AppStrings.supportedLanguages.map((l) => l.code).toSet();
    for (final locale in WidgetsBinding.instance.platformDispatcher.locales) {
      if (supported.contains(locale.languageCode)) {
        return locale.languageCode;
      }
    }
    return 'en';
  }

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    // If no language was ever saved, default to the system language.
    _languageCode =
        prefs.getString(_kKey) ?? _resolveSystemLanguage();
  }

  Future<void> setLanguage(String code) async {
    if (_languageCode == code) return;
    _languageCode = code;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kKey, code);
  }
}
