import 'package:flutter/material.dart';

// adjust imports if your filenames/locations differ
import 'widgets/home_screen.dart';
import 'widgets/grower_screen.dart';
import 'widgets/scan_screen.dart';
import 'widgets/results_screen.dart';
import 'widgets/leaderboard_screen.dart';

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
        useMaterial3: true,
        brightness: Brightness.dark,
        colorSchemeSeed: Colors.green,
        fontFamily: 'Roboto',
      ),
      initialRoute: '/', // <- start here
      routes: {
        '/': (context) => const HomeScreen(),
        '/budbot': (context) => const ScanScreen(),
        '/grower': (context) => const GrowerScreen(),
        '/results': (context) => const ResultsScreen(),
        '/leaderboard': (context) => const LeaderboardScreen(),
      },
    );
  }
}
