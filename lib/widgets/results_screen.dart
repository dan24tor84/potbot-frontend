import 'package:flutter/material.dart';

class ResultsScreen extends StatelessWidget {
  final Map<String, dynamic> results;

  const ResultsScreen({
    super.key,
    required this.results,
  });

  @override
  Widget build(BuildContext context) {
    // Extract the quality score if available
    final qualityScore = results['quality_score'] ?? results['score'] ?? 0;
    final qualityScoreDouble = qualityScore is int 
        ? qualityScore.toDouble() 
        : (qualityScore is double ? qualityScore : 0.0);
    
    // Determine color based on score
    final scoreColor = _getScoreColor(qualityScoreDouble);
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Analysis Results'),
        backgroundColor: Colors.green.shade600,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Score card
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Text(
                        'Quality Score',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 16),
                      CircleAvatar(
                        radius: 60,
                        backgroundColor: scoreColor,
                        child: Text(
                          '${qualityScoreDouble.toStringAsFixed(1)}',
                          style: const TextStyle(
                            fontSize: 36,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        _getScoreDescription(qualityScoreDouble),
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade700,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              const SizedBox(height: 24),
              const Text(
                'Detailed Analysis',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              
              // Results details
              ...results.entries.where((entry) => 
                entry.key != 'quality_score' && 
                entry.key != 'score'
              ).map((entry) {
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: ListTile(
                    title: Text(
                      _formatKey(entry.key),
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    subtitle: Text(
                      _formatValue(entry.value),
                      style: const TextStyle(height: 1.3),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  ),
                );
              }).toList(),
              
              const SizedBox(height: 16),
              
              // Share button
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Sharing coming soon!')),
                    );
                  },
                  icon: const Icon(Icons.share),
                  label: const Text('Share Results'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green.shade600,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
  
  // Helper methods
  Color _getScoreColor(double score) {
    if (score >= 90) return Colors.green.shade700;
    if (score >= 80) return Colors.green.shade500;
    if (score >= 70) return Colors.lime.shade600;
    if (score >= 60) return Colors.amber.shade600;
    if (score >= 50) return Colors.orange.shade600;
    return Colors.red.shade500;
  }
  
  String _getScoreDescription(double score) {
    if (score >= 90) return 'Exceptional Quality';
    if (score >= 80) return 'Excellent Quality';
    if (score >= 70) return 'Good Quality';
    if (score >= 60) return 'Average Quality';
    if (score >= 50) return 'Below Average';
    return 'Poor Quality';
  }
  
  String _formatKey(String key) {
    return key
        .replaceAll('_', ' ')
        .split(' ')
        .map((word) => word.isNotEmpty 
            ? '${word[0].toUpperCase()}${word.substring(1)}' 
            : '')
        .join(' ');
  }
  
  String _formatValue(dynamic value) {
    if (value is Map) {
      return value.entries
          .map((e) => '${_formatKey(e.key.toString())}: ${e.value}')
          .join('\n');
    }
    if (value is List) {
      return value.join(', ');
    }
    return value.toString();
  }
}