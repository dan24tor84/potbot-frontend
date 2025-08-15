import 'package:flutter/material.dart';

import 'widgets/home_screen.dart';
import 'widgets/scan_screen.dart';
import 'widgets/results_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
        brightness: Brightness.light,
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2BB673)),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),

      // Named routes you navigate to without args
      routes: {
        '/': (_) => const HomeScreen(),
        '/scan': (_) => const ScanScreen(),
      },

      // Routes that may need arguments (e.g., results payload)
      onGenerateRoute: (RouteSettings settings) {
        if (settings.name == '/results') {
          final args = settings.arguments as Map<String, dynamic>?;
          final results = args?['results'];
          return MaterialPageRoute(
            builder: (_) => ResultsScreen(results: results),
            settings: settings,
          );
        }
        return null; // fall back to default handling
      },
    );
  }
}
