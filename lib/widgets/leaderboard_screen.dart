import 'package:flutter/material.dart';

class LeaderboardScreen extends StatelessWidget {
  const LeaderboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: replace with real data from backend when ready
    final mock = [
      {'name': 'Strain A', 'score': 92},
      {'name': 'Strain B', 'score': 88},
      {'name': 'Strain C', 'score': 83},
    ];
    return Scaffold(
      appBar: AppBar(title: const Text('Leaderboard')),
      body: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemBuilder: (_, i) {
          final row = mock[i];
          return ListTile(
            title: Text(row['name'].toString()),
            trailing: Text(
              row['score'].toString(),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
        itemCount: mock.length,
      ),
    );
  }
}
