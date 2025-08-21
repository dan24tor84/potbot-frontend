import 'package:flutter/material.dart';

// routes
import 'widgets/home_screen.dart';
import 'widgets/scan_screen.dart';
import 'widgets/grower_screen.dart';
import 'widgets/results_screen.dart' as pro_screen; // placeholder for Pro

void main() {
  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PotBot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        scaffoldBackgroundColor: const Color(0xFF0F1115),
        appBarTheme: const AppBarTheme(backgroundColor: Color(0xFF12141A), elevation: 0),
        useMaterial3: true,
      ),
      // ✅ Make Home the entry screen
      home: const HomeScreen(),

      // The routes your Home screen links to
      routes: {
        '/home': (_) => const HomeScreen(),
        '/scan': (_) => const ScanScreen(),     // your existing Scan widget
        '/grower': (_) => const GrowerScreen(), // your existing Grower widget
        '/pro': (_) => const pro_screen.ResultsScreen(), // swap to your real Pro screen later
      },
    );
  }
}
