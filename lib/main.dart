import 'package:flutter/material.dart';
import 'widgets/scan_screen.dart';

void main() => runApp(const PotBotApp());

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    const apiUrl = 'https://potbot-backend-production.up.railway.app'; // your backend
    return MaterialApp(
      title: 'PotBot',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green.shade600),
        useMaterial3: true,
        textTheme: const TextTheme(
          headlineMedium: TextStyle(letterSpacing: -0.2),
        ),
      ),
      home: const ScanScreen(apiUrl: apiUrl),
    );
  }
}
