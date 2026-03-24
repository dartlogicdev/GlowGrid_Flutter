import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'state/game_state.dart';
import 'state/settings_state.dart';
import 'screens/start_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Lock to portrait.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Full immersive dark status/nav bar.
  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
      systemNavigationBarColor: Color(0xFF070711),
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  final gameState = GameState();
  await gameState.init();

  final settingsState = SettingsState();
  await settingsState.init();

  // Sync light colour mode from settings into game state.
  gameState.setMultiColorLight(settingsState.multiColorLight);
  settingsState.addListener(() {
    gameState.setMultiColorLight(settingsState.multiColorLight);
  });

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: gameState),
        ChangeNotifierProvider.value(value: settingsState),
      ],
      child: const GlowGridApp(),
    ),
  );
}

class GlowGridApp extends StatelessWidget {
  const GlowGridApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GlowGrid',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark().copyWith(
        scaffoldBackgroundColor: const Color(0xFF070711),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00E5FF),
          secondary: Color(0xFFBB88FF),
          surface: Color(0xFF0D0D1F),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFF0D0D1F),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
        ),
      ),
      home: const StartScreen(),
    );
  }
}
