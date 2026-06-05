import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class QuickActionsWidget extends StatelessWidget {
  const QuickActionsWidget({super.key, this.isOnline = true});

  final bool isOnline;

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);
  static const Color _white = Color(0xFFFDFDFB);

  void _handleActionTap(BuildContext context, String action) {
    switch (action) {
      case 'trips':
        context.go('/trips');
        break;
      case 'earnings':
        context.go('/earnings');
        break;
      case 'sos':
        context.go('/emergency');
        break;
      case 'help':
        context.go('/help');
        break;
    }
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
          const Text(
            'Quick Actions',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: _black,
            ),
          ),
          const SizedBox(height: 16),
          GridView.count(
            crossAxisCount: 4,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            children: [
              _QuickActionButton(
                icon: Icons.local_taxi_outlined,
                label: 'Trips',
                isEnabled: isOnline,
                onTap: () => _handleActionTap(context, 'trips'),
              ),
              _QuickActionButton(
                icon: Icons.attach_money_outlined,
                label: 'Earnings',
                isEnabled: isOnline,
                onTap: () => _handleActionTap(context, 'earnings'),
              ),
              _QuickActionButton(
                icon: Icons.emergency_outlined,
                label: 'SOS',
                isEnabled: true,
                highlight: false,
                onTap: () => _handleActionTap(context, 'sos'),
              ),
              _QuickActionButton(
                icon: Icons.help_outline,
                label: 'Help',
                isEnabled: true,
                onTap: () => _handleActionTap(context, 'help'),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _QuickActionButton extends StatelessWidget {
  const _QuickActionButton({
    required this.icon,
    required this.label,
    required this.isEnabled,
    this.highlight = false,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isEnabled;
  final bool highlight;
  final VoidCallback onTap;

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);
  static const Color _white = Color(0xFFFDFDFB);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(16),
        child: Container(
          decoration: BoxDecoration(
            color: highlight
                ? _yellow.withOpacity(0.95)
                : _white.withOpacity(0.6),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: highlight ? _yellow : _black.withOpacity(0.08),
              width: 1.2,
            ),
            boxShadow: highlight
                ? [
                    BoxShadow(
                      color: _yellow.withOpacity(0.25),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 28,
                color: highlight
                    ? _black
                    : isEnabled
                    ? _black
                    : _black.withOpacity(0.35),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: highlight
                      ? _black
                      : isEnabled
                      ? _black
                      : _black.withOpacity(0.35),
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
