import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cozzy_cruise/utils/responsive.dart';
import 'package:cozzy_cruise/widgets/status_banner.dart';
import 'package:cozzy_cruise/widgets/status_toggle.dart';
import 'package:cozzy_cruise/widgets/earnings_overview.dart';
import 'package:cozzy_cruise/widgets/todays_summary.dart';
import 'package:cozzy_cruise/widgets/quick_actions.dart';
import 'package:cozzy_cruise/widgets/bonus.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  DriverStatus currentStatus = DriverStatus.offline;
  bool _isOnline = false;
  final bool _showBonus = false;
  String verificationStatus = 'not_submitted';

  // Metrics
  double todaysEarnings = 6450.0;
  double rating = 4.8;
  int reviewCount = 230;
  int tripCount = 12;
  int onlineMinutes = 390; // 6h 30m
  double tipAmount = 850.0;

  static const Color _black = Color(0xFF111111);
  static const Color _white = Color(0xFFFDFDFB);
  static const Color _beige = Color(0xFFF4E7D3);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        AppBar(
          backgroundColor: _white,
          leading: const Icon(Icons.menu, color: _black),
          title: const Text(
            'Home',
            style: TextStyle(color: _black, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
          actions: [
            const SizedBox(width: 10),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.language, color: _white, size: 18),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: GestureDetector(
                onTap: () => context.push('/profile/notifications'),
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: _black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.notifications,
                    color: _white,
                    size: 18,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16.0),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: _black,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(
                  Icons.brightness_4_outlined,
                  color: _white,
                  size: 18,
                ),
              ),
            ),
          ],
        ),
        Expanded(
          child: Container(
            color: _beige,
            child: Builder(
              builder: (context) {
                final horizontalPadding = ResponsiveUtils.getHorizontalPadding(
                  context,
                );

                return SingleChildScrollView(
                  padding: EdgeInsets.all(horizontalPadding),
                  child: Column(
                    children: [
                      SizedBox(
                        height: 120,
                        child: StatusBanner(status: verificationStatus),
                      ),
                      const SizedBox(height: 12),
                      StatusToggle(
                        onToggle: (isOnline) => setState(() {
                          _isOnline = isOnline;
                          currentStatus = isOnline
                              ? DriverStatus.online
                              : DriverStatus.offline;
                        }),
                      ),
                      const SizedBox(height: 16),
                      if (currentStatus == DriverStatus.offline)
                        const OfflineView(),
                      if (currentStatus == DriverStatus.online)
                        const OnlineView(),
                      if (currentStatus == DriverStatus.inRide)
                        const InRideView(),
                      if (currentStatus == DriverStatus.busy) const BusyView(),
                      const SizedBox(height: 12),
                      EarningsOverviewCard(
                        earnings: todaysEarnings,
                        tripCount: tripCount,
                        rating: rating,
                        reviewCount: reviewCount,
                        isOnline: _isOnline,
                      ),
                      const SizedBox(height: 16),
                      TodaysSummaryCard(
                        tripCount: tripCount,
                        onlineMinutes: onlineMinutes,
                        tipAmount: tipAmount,
                        isOnline: _isOnline,
                      ),
                      const SizedBox(height: 16),
                      QuickActionsWidget(isOnline: _isOnline),
                      const SizedBox(height: 16),
                      if (_showBonus) ...[
                        const BonusWidget(),
                        const SizedBox(height: 16),
                      ],
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  void goOnline() {
    setState(() {
      _isOnline = true;
      currentStatus = DriverStatus.online;
    });
  }
}

enum DriverStatus { offline, online, inRide, busy }

class OfflineView extends StatelessWidget {
  const OfflineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFFFF),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'You are Offline',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          const Text('Go online to receive requests.'),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF6C945),
              ),
              onPressed: () {
                // Request parent to go online
                final state = context.findAncestorStateOfType<_HomePageState>();
                state?.goOnline();
              },
              child: const Padding(
                padding: EdgeInsets.symmetric(vertical: 12.0),
                child: Text(
                  'Go Online',
                  style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OnlineView extends StatelessWidget {
  const OnlineView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFFDF6E6),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFFF6C945).withValues(alpha: 0.18),
        ),
      ),
      child: Row(
        children: const [
          Icon(Icons.circle, color: Color(0xFF6BC24A), size: 14),
          SizedBox(width: 10),
          Expanded(child: Text('You are online. Waiting for ride requests.')),
        ],
      ),
    );
  }
}

class InRideView extends StatelessWidget {
  const InRideView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.directions_car, size: 24),
              SizedBox(width: 10),
              Text('In a Trip', style: TextStyle(fontWeight: FontWeight.w800)),
            ],
          ),
          const SizedBox(height: 8),
          const Text('Drop off: Westlands, Nairobi'),
          const SizedBox(height: 4),
          const Text(
            'ETA: 15 mins',
            style: TextStyle(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(onPressed: () {}, child: const Text('View Trip')),
          ),
        ],
      ),
    );
  }
}

class BusyView extends StatelessWidget {
  const BusyView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 8),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            'You are unavailable',
            style: TextStyle(fontWeight: FontWeight.w800),
          ),
          SizedBox(height: 8),
          Text(
            'Finish your current trip or go online to start receiving requests.',
          ),
        ],
      ),
    );
  }
}
