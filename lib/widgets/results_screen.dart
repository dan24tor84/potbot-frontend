import 'package:flutter/material.dart';
import '../services/api_service.dart';

class ResultsScreen extends StatelessWidget {
  const ResultsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // we expect arguments passed as: {'result': ScanResult}
    final args = ModalRoute.of(context)?.settings.arguments;
    final map = (args is Map) ? args : const {};
    final ScanResult? result = map['result'] as ScanResult?;

    return Scaffold(
      appBar: AppBar(title: const Text('Scan Results')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: result == null
              ? const Text('No result found.')
              : Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Label: ${result.label}', style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text('Score: ${result.score.toStringAsFixed(3)}'),
                        if (result.message.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Text(result.message),
                        ],
                      ],
                    ),
                  ),
                ),
        ),
      ),
    );
  }
}
