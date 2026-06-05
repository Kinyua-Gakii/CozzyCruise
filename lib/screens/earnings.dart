import 'package:flutter/material.dart';

class EarningsPage extends StatefulWidget {
  final String? totalEarnings;
  final String? percentChange;
  final String? tripFare;
  final String? tripFarePercent;
  final String? tips;
  final String? tipsPercent;
  final String? bonuses;
  final String? bonusesPercent;
  final String? adjustments;
  final String? adjustmentsPercent;
  final String? availableBalance;
  final String? nextPayoutDate;
  final String? paymentMethod;
  final List<Map<String, dynamic>>? transactions;

  const EarningsPage({
    super.key,
    this.totalEarnings,
    this.percentChange,
    this.tripFare,
    this.tripFarePercent,
    this.tips,
    this.tipsPercent,
    this.bonuses,
    this.bonusesPercent,
    this.adjustments,
    this.adjustmentsPercent,
    this.availableBalance,
    this.nextPayoutDate,
    this.paymentMethod,
    this.transactions,
  });

  @override
  State<EarningsPage> createState() => _EarningsPageState();
}

class _EarningsPageState extends State<EarningsPage> {
  String selectedPeriod = 'This Week';

  Future<Map<String, dynamic>> _fetchEarningsData(String period) async {
    await Future.delayed(const Duration(milliseconds: 500));
    return {
      'totalEarnings': widget.totalEarnings ?? 'KES 12,450',
      'periodLabel': 'This Week',
      'percentChange': widget.percentChange ?? '18.6%',
      'tripFare': widget.tripFare ?? 'KES 9,500',
      'tripFarePercent': widget.tripFarePercent ?? '74.4%',
      'tips': widget.tips ?? 'KES 1,850',
      'tipsPercent': widget.tipsPercent ?? '14.9%',
      'bonuses': widget.bonuses ?? 'KES 1,150',
      'bonusesPercent': widget.bonusesPercent ?? '9.2%',
      'adjustments': widget.adjustments ?? '-KES 1,800',
      'adjustmentsPercent': widget.adjustmentsPercent ?? '-14.5%',
      'availableBalance': widget.availableBalance ?? 'KES 8,450',
      'nextPayoutDate': widget.nextPayoutDate ?? '25 May 2025',
      'paymentMethod': widget.paymentMethod ?? 'M-Pesa (Acc 1234)',
    };
  }

  Future<List<Map<String, dynamic>>> _fetchTransactions() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return widget.transactions ??
        [
          {
            'type': 'Trip Fare',
            'amount': 'KES 850',
            'date': 'Today, 2:30 AM',
            'icon': Icons.directions_car,
            'icon_color': Color(0xFFF4A460),
          },
          {
            'type': 'Tip from James K.',
            'amount': 'KES 180',
            'date': 'Today, 2:45 AM',
            'icon': Icons.card_giftcard,
            'icon_color': Color(0xFF4CAF50),
          },
          {
            'type': 'Weekly Bonus',
            'amount': 'KES 300',
            'date': '1 May 2025',
            'icon': Icons.star_rounded,
            'icon_color': Color(0xFFFFB74D),
          },
          {
            'type': 'Commission',
            'amount': '-KES 180',
            'date': '1 May 2025',
            'icon': Icons.tune,
            'icon_color': Color(0xFFE57373),
          },
        ];
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF7F3E9),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Header
              _buildHeader(),
              const SizedBox(height: 16),
              // Period Tabs
              _buildPeriodTabs(),
              const SizedBox(height: 16),
              // Main Content
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Total Earnings
                    FutureBuilder<Map<String, dynamic>>(
                      future: _fetchEarningsData(selectedPeriod),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const SizedBox(
                            height: 60,
                            child: Center(child: CircularProgressIndicator()),
                          );
                        }
                        final data = snapshot.data ?? {};
                        return _buildTotalEarnings(data);
                      },
                    ),
                    const SizedBox(height: 20),
                    // Earnings Breakdown Grid
                    FutureBuilder<Map<String, dynamic>>(
                      future: _fetchEarningsData(selectedPeriod),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final data = snapshot.data ?? {};
                        return _buildEarningsGrid(data);
                      },
                    ),
                    const SizedBox(height: 20),
                    // Available Balance & Payout
                    FutureBuilder<Map<String, dynamic>>(
                      future: _fetchEarningsData(selectedPeriod),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final data = snapshot.data ?? {};
                        return _buildPayoutSection(data);
                      },
                    ),
                    const SizedBox(height: 20),
                    // Quick Actions
                    _buildQuickActions(),
                    const SizedBox(height: 20),
                    // Earnings Chart
                    _buildEarningsChart(),
                    const SizedBox(height: 20),
                    // Recent Transactions
                    FutureBuilder<List<Map<String, dynamic>>>(
                      future: _fetchTransactions(),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        final transactions = snapshot.data ?? [];
                        return _buildRecentTransactions(transactions);
                      },
                    ),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Icon(Icons.menu, size: 24, color: Color(0xFF111111)),
          const Text(
            'Earnings',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Color(0xFF111111),
            ),
          ),
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE6DFCF)),
            ),
            child: const Stack(
              alignment: Alignment.center,
              children: [
                Icon(
                  Icons.notifications_none,
                  size: 18,
                  color: Color(0xFF111111),
                ),
                Positioned(
                  top: 6,
                  right: 6,
                  child: CircleAvatar(
                    radius: 4,
                    backgroundColor: Color(0xFFF4C42D),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPeriodTabs() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: ['Today', 'This Week', 'This Month', 'Custom'].map((
            period,
          ) {
            final isSelected = selectedPeriod == period;
            return GestureDetector(
              onTap: () => setState(() => selectedPeriod = period),
              child: Container(
                margin: const EdgeInsets.only(right: 8),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF111111) : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: isSelected
                        ? const Color(0xFF111111)
                        : const Color(0xFFE6DFCF),
                  ),
                ),
                child: Text(
                  period,
                  style: TextStyle(
                    color: isSelected ? Colors.white : const Color(0xFF111111),
                    fontWeight: FontWeight.w600,
                    fontSize: 12,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildTotalEarnings(Map data) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Total Earnings',
          style: TextStyle(
            fontSize: 12,
            color: Color(0xFF555555),
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          data['totalEarnings'] as String,
          style: const TextStyle(
            fontSize: 36,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
          ),
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Text(
              data['periodLabel'] as String,
              style: const TextStyle(fontSize: 12, color: Color(0xFF555555)),
            ),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                '↑ ${data['percentChange']} vs last week',
                style: const TextStyle(
                  fontSize: 11,
                  color: Color(0xFF4CAF50),
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildEarningsGrid(Map data) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _earningsCard(
            'Trip Fare',
            data['tripFare'] as String,
            data['tripFarePercent'] as String,
            Icons.directions_car,
            const Color(0xFFF4A460),
          ),
          const SizedBox(width: 8),
          _earningsCard(
            'Tips',
            data['tips'] as String,
            data['tipsPercent'] as String,
            Icons.card_giftcard,
            const Color(0xFF4CAF50),
          ),
          const SizedBox(width: 8),
          _earningsCard(
            'Bonuses',
            data['bonuses'] as String,
            data['bonusesPercent'] as String,
            Icons.star_rounded,
            const Color(0xFFFFB74D),
          ),
          const SizedBox(width: 8),
          _earningsCard(
            'Adjustments',
            data['adjustments'] as String,
            data['adjustmentsPercent'] as String,
            Icons.tune,
            const Color(0xFFE57373),
          ),
        ],
      ),
    );
  }

  Widget _earningsCard(
    String label,
    String amount,
    String percent,
    IconData icon,
    Color color,
  ) {
    return SizedBox(
      width: 100,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE6DFCF)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              width: 28,
              height: 28,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(6),
              ),
              child: Icon(icon, size: 14, color: color),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 9,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 3),
                Text(
                  amount,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 1),
                Text(
                  percent,
                  style: const TextStyle(fontSize: 8, color: Color(0xFF555555)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPayoutSection(Map data) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE6DFCF)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column - Available Balance
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Available Balance',
                  style: TextStyle(
                    fontSize: 12,
                    color: Color(0xFF555555),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  data['availableBalance'] as String,
                  style: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF111111),
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Ready for payout',
                  style: TextStyle(fontSize: 11, color: Color(0xFF555555)),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF111111),
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Cash Out Now',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),
          // Right Column - Next Payout & Payment Method
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Next Payout',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['nextPayoutDate'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Text(
                      'Estimated',
                      style: TextStyle(fontSize: 10, color: Color(0xFF555555)),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment Method',
                      style: TextStyle(
                        fontSize: 12,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['paymentMethod'] as String,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const Icon(
                      Icons.arrow_forward_ios,
                      size: 10,
                      color: Color(0xFF555555),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        _quickActionButton('Transactions', Icons.receipt_long_outlined),
        _quickActionButton('Payout History', Icons.history),
        _quickActionButton(
          'Payroll Method',
          Icons.account_balance_wallet_outlined,
        ),
        _quickActionButton('Earnings Summary', Icons.bar_chart_rounded),
      ],
    );
  }

  Widget _quickActionButton(String label, IconData icon) {
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE6DFCF)),
            ),
            child: Icon(icon, size: 20, color: const Color(0xFF111111)),
          ),
          const SizedBox(height: 8),
          SizedBox(
            child: Text(
              label,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w500,
                color: Color(0xFF111111),
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEarningsChart() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Earnings Trend',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 14,
              color: Colors.grey[400],
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 200,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6DFCF)),
          ),
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 16,
                child: Column(
                  children: [
                    const Icon(
                      Icons.show_chart,
                      size: 40,
                      color: Color(0xFFFFB74D),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'KES',
                      style: TextStyle(
                        fontSize: 11,
                        color: Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: 16,
                child: Text(
                  'Mon    Tue    Wed    Thu     Fri     Sat    Sun',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[400],
                    letterSpacing: 0.5,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildRecentTransactions(List<Map<String, dynamic>> transactions) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Transactions',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: Color(0xFF111111),
              ),
            ),
            Text(
              'View all',
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[400],
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...transactions.asMap().entries.map((entry) {
          final idx = entry.key;
          final tx = entry.value;
          return Column(
            children: [
              _transactionRow(tx),
              if (idx < transactions.length - 1)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Container(height: 1, color: const Color(0xFFE6DFCF)),
                ),
            ],
          );
        }),
      ],
    );
  }

  Widget _transactionRow(Map tx) {
    return Row(
      children: [
        Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: (tx['icon_color'] as Color).withValues(alpha: 0.15),
            shape: BoxShape.circle,
          ),
          child: Icon(
            tx['icon'] as IconData,
            color: tx['icon_color'] as Color,
            size: 18,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tx['type'] as String,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF111111),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                tx['date'] as String,
                style: const TextStyle(fontSize: 11, color: Color(0xFF555555)),
              ),
            ],
          ),
        ),
        Text(
          tx['amount'] as String,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: (tx['amount'] as String).startsWith('-')
                ? Colors.red
                : const Color(0xFF111111),
          ),
        ),
      ],
    );
  }
}
