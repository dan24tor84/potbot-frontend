import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'widgets/scan_screen.dart';
import 'widgets/results_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // loads API_URL
  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PotBot',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green, brightness: Brightness.dark),
        useMaterial3: true,
        scaffoldBackgroundColor: Colors.black,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const ScanScreen(),
        // we’ll pass args when navigating:
        '/results': (context) => const ResultsScreen(),
      },
      // If you prefer onGenerateRoute, you can, but the simple routes map + arguments is enough.
    );
  }
}
