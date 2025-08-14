import 'package:flutter/material.dart';

import 'widgets/scan_screen.dart';
import 'widgets/results_screen.dart';
import 'widgets/home_screen.dart'; // (new file below)
// keeps IDE happy if you jump to def

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
        colorSchemeSeed: const Color(0xFF17A34A), // fresh green
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(fontWeight: FontWeight.w700),
          titleMedium: TextStyle(fontWeight: FontWeight.w600),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: false,
          elevation: 0,
          backgroundColor: Colors.white,
          foregroundColor: Colors.black,
        ),
      ),
      home: const HomeScreen(),
      routes: {
        '/scan': (_) => const ScanScreen(),
        '/results': (_) => const ResultsScreen(results: {},),
        '/grower': (_) => const GrowerScreen(),
        '/pro': (_) => const ProScreen(),
        '/leaderboard': (_) => const LeaderboardScreen(),
      },
    );
  }
}

/// Simple placeholder pages so navigation works immediately.
/// You can flesh these out later.
class GrowerScreen extends StatelessWidget {
  const GrowerScreen({super.key});
  @override
  Widget build(BuildContext context) => const _SimpleScaffold(
    title: 'Grower Mode',
    subtitle: 'Tips, diagnosis, and grow logs (coming soon).',
  );
}

class ProScreen extends StatelessWidget {
  const ProScreen({super.key});
  @override
  Widget build(BuildContext context) => const _SimpleScaffold(
    title: 'Pro Mode',
    subtitle: 'Advanced analytics & export (coming soon).',
  );
}

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});
  @override
  Widget build(BuildContext context) => const _SimpleScaffold(
    title: 'Leaderboard',
    subtitle: 'Top community rankings (coming soon).',
  );
}

class _SimpleScaffold extends StatelessWidget {
  const _SimpleScaffold({required this.title, required this.subtitle});
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 12),
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Shared app bar with logo + nav items.
PreferredSizeWidget _appBar(BuildContext context) {
  return AppBar(
    titleSpacing: 16,
    title: Row(
      children: [
        // Use your asset logo (put file at assets/images/logo.png)
        Image.asset('assets/images/logo.png', height: 28, errorBuilder: (_, __, ___) {
          return const Icon(Icons.eco_rounded, color: Color(0xFF17A34A));
        }),
        const SizedBox(width: 10),
        const Text('PotBot'),
      ],
    ),
    actions: [
      _NavLink(label: 'Home', onTap: () => _go(context, const HomeScreen())),
      _NavLink(label: 'Bud Bot', onTap: () => Navigator.pushNamed(context, '/scan')),
      _NavLink(label: 'Grower Mode', onTap: () => Navigator.pushNamed(context, '/grower')),
      _NavLink(label: 'Pro Mode', onTap: () => Navigator.pushNamed(context, '/pro')),
      _NavLink(label: 'Leaderboard', onTap: () => Navigator.pushNamed(context, '/leaderboard')),
      const SizedBox(width: 12),
    ],
  );
}

void _go(BuildContext context, Widget page) {
  Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
}

class _NavLink extends StatelessWidget {
  const _NavLink({required this.label, required this.onTap});
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
    );
  }
}