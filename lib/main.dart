import 'package:flutter/material.dart';

// Screens
import 'widgets/home_screen.dart';
import 'widgets/scan_screen.dart';
import 'widgets/grower_screen.dart';
import 'widgets/results_screen.dart';
import 'widgets/leaderboard_screen.dart';

// Compile-time API URL (injected by Nixpacks: --dart-define=API_URL=${POTBOT_API_URL})
const String kApiUrl = String.fromEnvironment(
  'API_URL',
  defaultValue: 'https://potbot-production.up.railway.app',
);

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    final colorScheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF00E676), // PotBot green accent
      brightness: Brightness.dark,
    );

    return MaterialApp(
      title: 'PotBot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: colorScheme,
        scaffoldBackgroundColor: const Color(0xFF111216),
        textTheme: const TextTheme(
          headlineLarge: TextStyle(fontWeight: FontWeight.w700),
          headlineMedium: TextStyle(fontWeight: FontWeight.w700),
          headlineSmall: TextStyle(fontWeight: FontWeight.w600),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF111216),
          elevation: 0,
          centerTitle: false,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 14),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        chipTheme: const ChipThemeData(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
      ),

      // Static routes (no required args)
      routes: {
        '/': (_) => const HomeScreen(),
        '/scan': (_) => ScanScreen(apiUrl: kApiUrl),
        '/grower': (_) => GrowerScreen(apiUrl: kApiUrl),
        '/leaderboard': (_) => const LeaderboardScreen(),
      },

      // Routes that require arguments (e.g., results)
      onGenerateRoute: (settings) {
        if (settings.name == '/results') {
          final args = settings.arguments;
          // Expecting a Map<String, dynamic> of analysis results
          if (args is Map<String, dynamic>) {
            return MaterialPageRoute<void>(
              builder: (_) => ResultsScreen(results: args),
            );
          }
          // Fallback if nothing was passed
          return MaterialPageRoute<void>(
            builder: (_) => const ResultsScreen(results: {}),
          );
        }
        return null;
      },
    );
  }
}
