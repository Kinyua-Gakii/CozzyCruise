import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class EarningsOverviewCard extends StatelessWidget {
  const EarningsOverviewCard({
    super.key,
    this.earnings = 0.0,
    this.tripCount = 0,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isOnline = false,
  });

  final double earnings;
  final int tripCount;
  final double rating;
  final int reviewCount;
  final bool isOnline;

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);
  static const Color _white = Color(0xFFFDFDFB);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => context.go('/earnings'),
      child: Container(
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
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // Earnings Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Today's Earnings",
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Icon(
                        Icons.account_balance_wallet,
                        size: 24,
                        color: _yellow,
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'KES ${earnings.toStringAsFixed(0)}',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w900,
                                color: _black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'from $tripCount trips',
                              style: TextStyle(
                                fontSize: 11,
                                color: _black.withOpacity(0.58),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Divider
            Container(
              width: 1,
              height: 80,
              color: _black.withOpacity(0.08),
              margin: const EdgeInsets.symmetric(horizontal: 16),
            ),
            // Rating Section
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const Text(
                    'Rating',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: _black,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.star_rounded, size: 28, color: _yellow),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rating.toStringAsFixed(1),
                              style: const TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                                color: _black,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                            Text(
                              'from $reviewCount reviews',
                              style: TextStyle(
                                fontSize: 10,
                                color: _black.withOpacity(0.58),
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
