import 'package:flutter/material.dart';
import 'widgets/scan_screen.dart'; // <- file is under lib/widgets

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    const String apiUrl =
        'http://10.0.2.2:8080'; // replace with your Railway URL when ready

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'PotBot',
      theme: ThemeData(primarySwatch: Colors.green),
      home: const ScanScreen(apiUrl: apiUrl),
    );
  }
}
