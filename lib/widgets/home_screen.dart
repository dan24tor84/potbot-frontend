// ignore_for_file: unnecessary_underscores

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ImagePicker _picker = ImagePicker();
  final List<XFile> _images = [];

  Future<void> _pick(ImageSource src) async {
    final XFile? picked = await _picker.pickImage(
      source: src,
      imageQuality: 90,
    );
    if (picked != null) setState(() => _images.insert(0, picked));
  }

  void _openScan() => Navigator.of(context).pushNamed('/scan');
  void _openLeaderboard() => Navigator.of(context).pushNamed('/leaderboard');

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: theme.colorScheme.surface,
        titleSpacing: 0,
        title: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 12),
              child: Image.asset(
                // use your actual logo file (from your older screen)
                'assets/images/potbot_logo-512x512.png',
                height: 36,
              ),
            ),
            Text(
              'PotBot',
              style: theme.textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'Leaderboard',
            onPressed: _openLeaderboard,
            icon: const Icon(Icons.emoji_events_outlined),
          ),
        ],
      ),

      // FABs for quick actions
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'scan',
            onPressed: _openScan,
            label: const Text('Scan'),
            icon: const Icon(Icons.science),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'camera',
            onPressed: () => _pick(ImageSource.camera),
            tooltip: 'Camera',
            child: const Icon(Icons.photo_camera),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'gallery',
            onPressed: () => _pick(ImageSource.gallery),
            tooltip: 'Gallery',
            child: const Icon(Icons.photo_library),
          ),
        ],
      ),

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // CONTENT
              Expanded(
                child: Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 680),
                    child:
                        _images.isEmpty
                            ? _EmptyLanding(
                              onScan: _openScan,
                              onPick: () => _pick(ImageSource.gallery),
                            )
                            : GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 3,
                                    crossAxisSpacing: 12,
                                    mainAxisSpacing: 12,
                                  ),
                              itemCount: _images.length,
                              itemBuilder:
                                  (context, i) =>
                                      _ParameterBox(path: _images[i].path),
                            ),
                  ),
                ),
              ),

              // FOOTER (kept from the older landing)
              const SizedBox(height: 8),
              Text(
                '© 2025 PotBot. All rights reserved.',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.hintColor,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Empty state hero when there are no images yet
class _EmptyLanding extends StatelessWidget {
  final VoidCallback onScan;
  final VoidCallback onPick;
  const _EmptyLanding({required this.onScan, required this.onPick});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text(
          'Scan Your Bud',
          textAlign: TextAlign.center,
          style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 10),
        const Text(
          'Instant AI feedback on quality, contaminants, and visible issues.',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 20),
        FilledButton.icon(
          onPressed: onScan,
          icon: const Icon(Icons.document_scanner_outlined),
          label: const Text('Open Bud Bot'),
          style: FilledButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 16),
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          alignment: WrapAlignment.center,
          spacing: 12,
          runSpacing: 12,
          children: [
            OutlinedButton.icon(
              onPressed: onPick,
              icon: const Icon(Icons.upload),
              label: const Text('Upload'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Grower Mode coming soon')),
                );
              },
              icon: const Icon(Icons.spa_outlined),
              label: const Text('Grower Mode'),
            ),
            OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(content: Text('Pro Mode coming soon')),
                );
              },
              icon: const Icon(Icons.star_outline),
              label: const Text('Pro Mode'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Strict “parameter box” so images never overflow:
///  - perfect square
///  - clipped radius
///  - cover image within the square
class _ParameterBox extends StatelessWidget {
  final String path;
  const _ParameterBox({required this.path});

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.tealAccent.withValues(alpha: 0.25),
              width: 2,
            ),
          ),
          child: Image.file(
            File(path),
            fit: BoxFit.cover,
            errorBuilder:
                (_, __, ___) => const Center(
                  child: Icon(Icons.broken_image, color: Colors.white38),
                ),
          ),
        ),
      ),
    );
  }
}
