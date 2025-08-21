import 'package:flutter/material.dart';
import 'widgets/scan_screen.dart';

void main() {
  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Use your Railway backend URL here:
    const String apiUrl = 'https://potbot-backend-production.up.railway.app';

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PotBot',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ScanScreen(apiUrl: apiUrl),
    );
  }
}
