import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:cozzy_cruise/screens/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF111111);
    const yellow = Color(0xFFF6C945);
    const beige = Color(0xFFF4E7D3);
    const white = Color(0xFFFDFDFB);

    return MaterialApp.router(
      title: 'CozzyCruise',
      debugShowCheckedModeBanner: false,
      routerConfig: router,
      theme: ThemeData(
        useMaterial3: true,
        brightness: Brightness.dark,
        scaffoldBackgroundColor: black,
        colorScheme: ColorScheme.fromSeed(
          seedColor: yellow,
          brightness: Brightness.dark,
          primary: yellow,
          secondary: beige,
          surface: const Color(0xFF1A1A1A),
          onPrimary: black,
          onSecondary: black,
          onSurface: white,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          foregroundColor: white,
          elevation: 0,
          centerTitle: true,
        ),
        textTheme: const TextTheme(
          bodyMedium: TextStyle(color: white),
          bodyLarge: TextStyle(color: white),
          titleLarge: TextStyle(color: white, fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(color: white, fontWeight: FontWeight.w800),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: true,
          fillColor: Colors.white.withValues(alpha: 0.08),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(24),
            borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.16)),
          ),
          focusedBorder: const OutlineInputBorder(
            borderRadius: BorderRadius.all(Radius.circular(24)),
            borderSide: BorderSide(color: yellow, width: 1.5),
          ),
          labelStyle: TextStyle(color: white.withValues(alpha: 0.7)),
          hintStyle: TextStyle(color: white.withValues(alpha: 0.45)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: yellow,
            foregroundColor: black,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
            textStyle: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            foregroundColor: white,
            side: BorderSide(color: white.withValues(alpha: 0.18)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(24),
            ),
            padding: const EdgeInsets.symmetric(vertical: 18),
          ),
        ),
      ),
    );
  }
}
