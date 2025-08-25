import 'dart:typed_data';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import '../services/api_service.dart';

class ScanScreen extends StatefulWidget {
  final String apiUrl;
  const ScanScreen({super.key, required this.apiUrl});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> {
  bool _isAnalyzing = false;
  Uint8List? _selectedImage;
  String? _imageName;

  Future<void> _pickImageFromGallery() async {
    try {
      if (kIsWeb) {
        // Use file_picker for web
        final result = await FilePicker.platform.pickFiles(
          type: FileType.image,
          allowMultiple: false,
          withData: true,
        );

        if (result != null && result.files.first.bytes != null) {
          setState(() {
            _selectedImage = result.files.first.bytes!;
            _imageName = result.files.first.name;
          });
        }
      } else {
        // Use image_picker for mobile
        final ImagePicker picker = ImagePicker();
        final XFile? image = await picker.pickImage(
          source: ImageSource.gallery,
          maxWidth: 1920,
          maxHeight: 1080,
          imageQuality: 85,
        );

        if (image != null) {
          final bytes = await image.readAsBytes();
          setState(() {
            _selectedImage = bytes;
            _imageName = image.name;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
      }
    }
  }

  Future<void> _pickImageFromCamera() async {
    if (kIsWeb) {
      // Web doesn't support camera directly, fallback to gallery
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Camera not supported on web. Using gallery instead.')),
      );
      await _pickImageFromGallery();
      return;
    }

    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1080,
        imageQuality: 85,
      );

      if (image != null) {
        final bytes = await image.readAsBytes();
        setState(() {
          _selectedImage = bytes;
          _imageName = image.name;
        });
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error taking photo: $e')),
        );
      }
    }
  }

  Future<void> _analyzeImage() async {
    if (_selectedImage == null) return;

    setState(() => _isAnalyzing = true);

    try {
      final results = await ApiService.analyzeImage(
        _selectedImage!,
        filename: _imageName ?? 'upload.jpg',
      );
      
      if (mounted) {
        Navigator.pushNamed(
          context,
          '/results',
          arguments: results,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Analysis failed: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isAnalyzing = false);
      }
    }
  }

  void _clearImage() {
    setState(() {
      _selectedImage = null;
      _imageName = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          stops: [0.1, 0.5, 1.0],
          colors: [Color(0xFFE8F5E9), Color(0xFFD7FFD9), Color(0xFFF1FFF1)],
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        appBar: AppBar(
          title: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image.asset(
                'assets/images/potbot_logo-512x512.png',
                height: 28,
                errorBuilder: (_, __, ___) => const Icon(Icons.eco),
              ),
              const SizedBox(width: 8),
              const Text('PotBot'),
            ],
          ),
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.green.shade600,
          foregroundColor: Colors.white,
        ),
        body: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Scan Your Bud',
                      style: theme.textTheme.headlineMedium?.copyWith(
                        fontWeight: FontWeight.w700,
                        color: Colors.green.shade700,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _selectedImage == null
                          ? 'Upload a photo. We\'ll analyze the flower and return an AI quality score.'
                          : 'Image selected! Click analyze to get your quality score.',
                      textAlign: TextAlign.center,
                      style: theme.textTheme.bodyMedium?.copyWith(color: Colors.black54),
                    ),
                    const SizedBox(height: 24),

                    // Image preview
                    if (_selectedImage != null) ...[
                      Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.memory(
                            _selectedImage!,
                            height: 250,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      
                      // Clear button
                      TextButton.icon(
                        onPressed: _isAnalyzing ? null : _clearImage,
                        icon: const Icon(Icons.clear),
                        label: const Text('Clear Image'),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.red.shade600,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],

                    // Action buttons
                    if (_selectedImage == null) ...[
                      // Image selection buttons
                      Wrap(
                        spacing: 16,
                        runSpacing: 12,
                        alignment: WrapAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            icon: const Icon(Icons.photo_library_outlined),
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                              backgroundColor: Colors.green.shade600,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                            ),
                            onPressed: _pickImageFromGallery,
                            label: const Text('Choose from Gallery'),
                          ),
                          if (!kIsWeb)
                            OutlinedButton.icon(
                              icon: const Icon(Icons.photo_camera_outlined),
                              style: OutlinedButton.styleFrom(
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                                side: BorderSide(color: Colors.green.shade600, width: 1.5),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                                foregroundColor: Colors.green.shade700,
                              ),
                              onPressed: _pickImageFromCamera,
                              label: const Text('Take Photo'),
                            ),
                        ],
                      ),
                    ] else ...[
                      // Analysis button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          icon: _isAnalyzing 
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  ),
                                )
                              : const Icon(Icons.analytics_outlined),
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            backgroundColor: Colors.orange.shade600,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          onPressed: _isAnalyzing ? null : _analyzeImage,
                          label: Text(
                            _isAnalyzing ? 'Analyzing...' : 'Analyze Quality',
                            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ),
                    ],

                    const SizedBox(height: 24),
                    Divider(color: Colors.grey.shade300, height: 32),

                    // Tips
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.tips_and_updates_outlined, size: 18, color: Colors.grey.shade600),
                        const SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            'Best results: bright lighting, in-focus photo, no filters',
                            style: theme.textTheme.bodySmall?.copyWith(color: Colors.grey.shade700),
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
