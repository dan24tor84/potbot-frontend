import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});
  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  CameraController? _controller;
  bool _busy = false;

  @override
  void initState() {
    super.initState();
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      final cams = await availableCameras();
      final cam = cams.firstWhere(
        (c) => c.lensDirection == CameraLensDirection.back,
        orElse: () => cams.first,
      );
      final controller = CameraController(
        cam,
        ResolutionPreset.medium,
        enableAudio: false,
      );
      await controller.initialize();
      if (!mounted) return;
      setState(() => _controller = controller);
    } catch (e) {
      debugPrint('Camera init error: $e');
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Camera error: $e')));
      }
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _captureAndAnalyze() async {
    if (_controller == null || !_controller!.value.isInitialized) return;
    setState(() => _busy = true);
    try {
      final shot = await _controller!.takePicture();
      final result = await _sendImageToApi(File(shot.path));
      if (!mounted) return;
      Navigator.pushNamed(context, '/results', arguments: {'result': result});
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Analyze failed: $e')));
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  // --- API call (edit API_BASE below if needed) ---
  static const String API_BASE = String.fromEnvironment(
    'API_BASE',
    defaultValue: 'https://potbot-production.up.railway.app',
  );

  Future<String> _sendImageToApi(File file) async {
    final url = Uri.parse('$API_BASE/api/scan');
    final bytes = await file.readAsBytes();
    final resp = await http.post(
      url,
      headers: {'Content-Type': 'application/octet-stream'},
      body: bytes,
    );
    if (resp.statusCode == 200) {
      return resp.body; // adjust parsing if your backend returns JSON
    }
    throw 'Server ${resp.statusCode}: ${resp.body}';
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    return Scaffold(
      appBar: AppBar(title: const Text('Scan')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Bounded preview box (3:4 aspect, rounded corners)
            AspectRatio(
              aspectRatio: 3 / 4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  color: Colors.black,
                  child:
                      (controller != null && controller.value.isInitialized)
                          ? CameraPreview(controller)
                          : const Center(child: CircularProgressIndicator()),
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _busy ? null : _captureAndAnalyze,
              icon: const Icon(Icons.camera),
              label: Text(_busy ? 'Analyzing…' : 'Capture & Analyze'),
            ),
          ],
        ),
      ),
    );
  }
}
