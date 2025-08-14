import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'image_preview.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key, required this.result, this.originalBytes});

  final Map<String, dynamic> result;
  final Uint8List? originalBytes;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final score = result['score'];
    final issues = (result['issues'] as List?)?.cast<String>() ?? const [];

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 900),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                if (originalBytes != null) ...[
                  ImagePreview(webBytes: originalBytes, height: 220),
                  const SizedBox(height: 16),
                ],
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text('Summary', style: theme.textTheme.titleLarge),
                        const SizedBox(height: 8),
                        Text(
                          (result['summary'] ?? 'No summary').toString(),
                          style: theme.textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 16),
                        if (score != null)
                          Row(
                            children: [
                              Text('Quality score: ',
                                  style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w700)),
                              Text('$score / 100', style: theme.textTheme.titleMedium),
                            ],
                          ),
                        if (issues.isNotEmpty) ...[
                          const SizedBox(height: 16),
                          Text('Detected issues', style: theme.textTheme.titleMedium),
                          const SizedBox(height: 8),
                          for (final s in issues) Text('• $s'),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}