import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:carousel_slider/carousel_slider.dart'; // Ensure this dependency exists or use a simple PageView
import '../../../data/database/database.dart';
import '../../../data/repositories/app_repository.dart';

class InsightCarousel extends StatelessWidget {
  final List<FinancialInsight> insights;
  final Function(String) onDismiss;

  const InsightCarousel({
    super.key,
    required this.insights,
    required this.onDismiss,
  });

  @override
  Widget build(BuildContext context) {
    if (insights.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            children: [
              const Icon(CupertinoIcons.lightbulb_fill, color: Color(0xFFCFB53B), size: 16),
              const SizedBox(width: 8),
              Text('Smart Insights', style: GoogleFonts.poppins(color: Colors.white70, fontSize: 13, fontWeight: FontWeight.w600)),
            ],
          ),
        ),
        SizedBox(
          height: 140,
          child: PageView.builder(
            controller: PageController(viewportFraction: 0.9),
            itemCount: insights.length,
            itemBuilder: (context, index) {
              final insight = insights[index];
              return Padding(
                padding: const EdgeInsets.only(right: 12),
                child: _buildInsightCard(context, insight),
              );
            },
          ),
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  Widget _buildInsightCard(BuildContext context, FinancialInsight insight) {
    final color = _getSeverityColor(insight.severity);
    final icon = _getSeverityIcon(insight.severity);

    return Dismissible(
      key: Key(insight.id),
      direction: DismissDirection.up,
      onDismissed: (_) => onDismiss(insight.id),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1A2744),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
          gradient: LinearGradient(
            colors: [color.withOpacity(0.1), const Color(0xFF1A2744)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(color: color.withOpacity(0.2), borderRadius: BorderRadius.circular(8)),
                  child: Icon(icon, color: color, size: 18),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    _formatType(insight.type),
                    style: GoogleFonts.poppins(color: color, fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                ),
                IconButton(
                  icon: const Icon(CupertinoIcons.xmark, size: 16, color: Colors.white30),
                  onPressed: () => onDismiss(insight.id),
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Text(
              insight.message,
              style: GoogleFonts.poppins(color: Colors.white, fontSize: 13),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  Color _getSeverityColor(String severity) {
    switch (severity) {
      case 'critical': return const Color(0xFFE53935);
      case 'warning': return const Color(0xFFFF9800);
      default: return const Color(0xFF2196F3);
    }
  }

  IconData _getSeverityIcon(String severity) {
    switch (severity) {
      case 'critical': return CupertinoIcons.exclamationmark_triangle_fill;
      case 'warning': return CupertinoIcons.exclamationmark_circle_fill;
      default: return CupertinoIcons.info_circle_fill;
    }
  }

  String _formatType(String type) {
    return type.split('_').map((w) => w[0].toUpperCase() + w.substring(1)).join(' ');
  }
}
