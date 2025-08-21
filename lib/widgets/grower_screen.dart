import 'package:flutter/material.dart';
import '../services/api_service.dart';

class GrowerScreen extends StatefulWidget {
  const GrowerScreen({super.key});

  @override
  State<GrowerScreen> createState() => _GrowerScreenState();
}

class _GrowerScreenState extends State<GrowerScreen> {
  String stage = 'veg';
  String issue = '';
  String output = '';
  bool loading = false;

  Future<void> fetchTips() async {
    setState(() => loading = true);
    try {
      final res = await ApiService.getGrowTips(stage: stage, issue: issue);
      setState(() => output = res['tips']?.toString() ?? '$res');
    } catch (e) {
      setState(() => output = 'Error: $e');
    } finally {
      setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(children: [
        Image.asset('assets/images/logo.png', height: 28),
        const SizedBox(width: 8),
        const Text('Grow Coach'),
      ])),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Stage'),
            DropdownButton<String>(
              value: stage,
              items: const [
                DropdownMenuItem(value: 'veg', child: Text('Vegetative')),
                DropdownMenuItem(value: 'flower', child: Text('Flower')),
                DropdownMenuItem(value: 'seedling', child: Text('Seedling')),
              ],
              onChanged: (v) => setState(() => stage = v ?? 'veg'),
            ),
            const SizedBox(height: 8),
            TextField(
              decoration: const InputDecoration(
                labelText: 'Issue (optional, e.g. nitrogen, mites)',
                border: OutlineInputBorder(),
              ),
              onChanged: (v) => issue = v,
            ),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: loading ? null : fetchTips,
              child: Text(loading ? 'Loading...' : 'Get Tips'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: SingleChildScrollView(
                child: Text(output.isEmpty ? 'No tips yet.' : output),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
