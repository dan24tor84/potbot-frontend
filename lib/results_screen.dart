import 'dart:convert';
import 'package:flutter/material.dart';

/// ResultsScreen
/// - Accepts either a raw string (`rawText`) or a JSON-like map (`data`).
/// - If you pass raw JSON text, it will try to pretty‑print it.
class ResultsScreen extends StatelessWidget {
  final String? rawText;
  final Map<String, dynamic>? data;

  const ResultsScreen({
    super.key,
    this.rawText,
    this.data,
  });

  /// Convenience helper: give it a response body and it will try to decode JSON,
  /// falling back to raw text if decoding fails.
  factory ResultsScreen.fromResponseBody(String body) {
    try {
      final decoded = json.decode(body) as Map<String, dynamic>;
      return ResultsScreen(data: decoded);
    } catch (_) {
      return ResultsScreen(rawText: body);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget content;
    if (data != null) {
      content = _JsonView(data!);
    } else if (rawText != null) {
      // Try pretty print if the raw text is actually JSON
      content = _maybePrettyJson(rawText!);
    } else {
      content = const Text('No results available.');
    }

    return Scaffold(
      appBar: AppBar(title: const Text('Analysis Result')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 0,
          color: theme.colorScheme.surfaceContainerHighest,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: content,
          ),
        ),
      ),
    );
  }

  Widget _maybePrettyJson(String text) {
    try {
      final jsonObj = json.decode(text);
      final pretty = const JsonEncoder.withIndent('  ').convert(jsonObj);
      return SelectableText(pretty);
    } catch (_) {
      return SelectableText(text);
    }
  }
}

/// Simple expandable JSON viewer for Map<String, dynamic>
class _JsonView extends StatelessWidget {
  final Map<String, dynamic> map;
  const _JsonView(this.map);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: map.entries.map((e) => _JsonEntry(e.key, e.value)).toList(),
    );
  }
}

class _JsonEntry extends StatelessWidget {
  final String keyName;
  final dynamic value;
  const _JsonEntry(this.keyName, this.value);

  @override
  Widget build(BuildContext context) {
    final isLeaf = value is! Map && value is! List;

    if (isLeaf) {
      return ListTile(
        title: Text(keyName),
        subtitle: SelectableText('$value'),
      );
    }

    // Complex value -> ExpansionTile
    return ExpansionTile(
      title: Text(keyName),
      children: [_buildComplex(value)],
    );
  }

  Widget _buildComplex(dynamic v) {
    if (v is Map) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: v.entries
              .map<Widget>((e) => _JsonEntry(e.key, e.value))
              .toList(),
        ),
      );
    }
    if (v is List) {
      return Padding(
        padding: const EdgeInsets.only(left: 8, right: 8, bottom: 8),
        child: Column(
          children: v
              .asMap()
              .entries
              .map<Widget>((e) => _JsonEntry('[${e.key}]', e.value))
              .toList(),
        ),
      );
    }
    return SelectableText('$v');
  }
}
