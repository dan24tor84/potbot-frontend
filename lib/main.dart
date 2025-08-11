// lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'scan_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env"); // loads from project root
  runApp(const PotBotApp());
void main() async {
  // Load .env file before app runs
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
        primarySwatch: Colors.green,
        scaffoldBackgroundColor: Colors.black,
        textTheme: const TextTheme(
          bodyLarge: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white70),
        ),
      ),
      home: const ScanScreen(),
    );
  }
}

class PotBotHomePage extends StatefulWidget {
  const PotBotHomePage({super.key});

  @override
  State<PotBotHomePage> createState() => _PotBotHomePageState();
}

class _PotBotHomePageState extends State<PotBotHomePage> {
  File? _selectedImage;
  String? _scanResult;
  bool _isLoading = false;

  Future<void> _pickImage(ImageSource source) async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: source);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        _scanResult = null;
      });

      await _scanImage(_selectedImage!);
    }
  }

  Future<void> _scanImage(File image) async {
    setState(() => _isLoading = true);

    final replicateApiToken = dotenv.env['REPLICATE_API_TOKEN'];
    final apiUrl = dotenv.env['POTBOT_API_URL'];

    if (replicateApiToken == null || apiUrl == null) {
      setState(() {
        _scanResult = "Missing API credentials.";
        _isLoading = false;
      });
      return;
    }

    try {
      final bytes = await image.readAsBytes();
      final base64Image = base64Encode(bytes);

      final response = await http.post(
        Uri.parse('$apiUrl/api/scan'),
        headers: {
          'Authorization': 'Bearer $replicateApiToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'image': base64Image,
        }),
      );

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        setState(() {
          _scanResult = json['result'] ?? 'Scan complete.';
        });
      } else {
        setState(() {
          _scanResult = 'Error: ${response.statusCode}';
        });
      }
    } catch (e) {
      setState(() {
        _scanResult = 'Scan failed: $e';
      });
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PotBot'),
        backgroundColor: Colors.green.shade800,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (_selectedImage != null)
              Image.file(_selectedImage!, height: 200),
            const SizedBox(height: 20),
            if (_isLoading)
              const CircularProgressIndicator()
            else if (_scanResult != null)
              Text(
                _scanResult!,
                style: const TextStyle(fontSize: 18),
              ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.camera),
                  icon: const Icon(Icons.camera_alt),
                  label: const Text("Camera"),
                ),
                ElevatedButton.icon(
                  onPressed: () => _pickImage(ImageSource.gallery),
                  icon: const Icon(Icons.photo_library),
                  label: const Text("Gallery"),
                ),
              ],
            ),
          ],
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark, // <-- set it only here
        ),
        useMaterial3: true,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}