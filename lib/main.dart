// main.dart (diff-friendly paste)

import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kReleaseMode;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

// 1) Read config: prefer --dart-define, else .env fallback
String readConfig(String key, {String defaultValue = ""}) {
  // Prefer compile-time defines (works on Android/iOS/Web)
  const fromEnvApiUrl = String.fromEnvironment('API_URL', defaultValue: '');
  if (key == 'API_URL' && fromEnvApiUrl.isNotEmpty) return fromEnvApiUrl;

  // Fallback to .env when available (dev only)
  final val = dotenv.maybeGet(key);
  if (val != null && val.isNotEmpty) return val;

  return defaultValue;
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 2) Load .env only if NOT running a production build
  //    (keeps secrets out of release bundles if you forget to remove it)
  if (!kReleaseMode) {
    try {
      await dotenv.load(fileName: ".env");
    } catch (_) {
      // No local .env — that's fine in dev too.
    }
  }

  runApp(const PotBotApp());
}

class PotBotApp extends StatelessWidget {
  const PotBotApp({super.key});

  @override
  Widget build(BuildContext context) {
    // 3) Use readConfig() wherever you need environment values
    final apiUrl = readConfig('API_URL', defaultValue: 'http://10.0.2.2:8080'); // emulator default

    // Pass apiUrl into your repositories/services or via an inherited widget/provider
    // Example: ApiClient(baseUrl: apiUrl)

    return MaterialApp(
      title: 'PotBot',
      // ... your existing theme/routes
      // home: ScanScreen(apiUrl: apiUrl),
    );
  }
}
