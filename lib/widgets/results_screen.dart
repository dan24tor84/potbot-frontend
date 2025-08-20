import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> results;

  const ResultsScreen({
    super.key, // use super parameter directly
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan Results'),
        backgroundColor: Colors.green,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: results.entries.map((entry) {
            return Card(
              margin: const EdgeInsets.symmetric(vertical: 8),
              child: ListTile(
                title: Text(
                  entry.key,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text(entry.value.toString()),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}