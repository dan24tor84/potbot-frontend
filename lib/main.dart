import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart'; // used on Scan screen
import 'dart:io' show File;                      // mobile file path
import 'package:http/http.dart' as http;         // used by ai_service
import 'dart:convert';                           // used by ai_service

import 'scan_screen.dart';

Future<void> main() async {
  // Make sure bindings are initialized before async work
  WidgetsFlutterBinding.ensureInitialized();

  // Load .env before app starts (file lives at project root)
  await dotenv.load(fileName: ".env");

  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'PotBot',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: const ScanScreen(),
    );
  }
}
