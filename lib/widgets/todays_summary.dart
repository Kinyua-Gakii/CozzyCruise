import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class TodaysSummaryCard extends StatelessWidget {
  const TodaysSummaryCard({
    super.key,
    this.tripCount = 0,
    this.onlineMinutes = 0,
    this.tipAmount = 0.0,
    this.isOnline = false,
  });

  final int tripCount;
  final int onlineMinutes;
  final double tipAmount;
  final bool isOnline;

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);
  static const Color _white = Color(0xFFFDFDFB);

  String _formatTime(int minutes) {
    final hours = minutes ~/ 60;
    final mins = minutes % 60;
    if (hours > 0) {
      return '${hours}h ${mins}m';
    }
    return '${mins}m';
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: _white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _yellow.withOpacity(0.18), width: 1),
        boxShadow: [
          BoxShadow(
            color: _black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                "Today's Summary",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: _black,
                ),
              ),
              GestureDetector(
                onTap: () => context.go('/earnings'),
                child: const Text(
                  'See details >',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _yellow,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _SummaryMetric(
                label: 'Trips',
                value: tripCount.toString(),
                icon: Icons.local_taxi_outlined,
              ),
              Container(
                width: 1,
                height: 60,
                color: _black.withOpacity(0.08),
              ),
              _SummaryMetric(
                label: 'Online Time',
                value: _formatTime(onlineMinutes),
                icon: Icons.schedule_outlined,
              ),
              Container(
                width: 1,
                height: 60,
                color: _black.withOpacity(0.08),
              ),
              _SummaryMetric(
                label: 'Tips',
                value: 'KES ${tipAmount.toStringAsFixed(0)}',
                icon: Icons.favorite_outline,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SummaryMetric extends StatelessWidget {
  const _SummaryMetric({
    required this.label,
    required this.value,
    required this.icon,
  });

  final String label;
  final String value;
  final IconData icon;

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          Icon(icon, size: 24, color: _yellow),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
              color: _black,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _black.withOpacity(0.58),
            ),
          ),
        ],
      ),
    );
  }
}
