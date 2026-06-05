import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class EarningsWalletPage extends StatelessWidget {
  final Map<String, dynamic>? earnings;

  const EarningsWalletPage({super.key, this.earnings});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Earnings & Wallet'),
        backgroundColor: Colors.white,
        foregroundColor: appBlack,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Main balance card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: appYellow,
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Wallet Balance',
                      style: TextStyle(
                        fontSize: 14,
                        color: appBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      'KES ${earnings?["balance"] ?? "0.00"}',
                      style: const TextStyle(
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        color: appBlack,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Earnings summary
              const Text(
                'Earnings Summary',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              earningsCard('Today', earnings?["today"] ?? "0.00"),
              earningsCard('This Week', earnings?["week"] ?? "0.00"),
              earningsCard('This Month', earnings?["month"] ?? "0.00"),
              earningsCard('Total Earnings', earnings?["total"] ?? "0.00"),

              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    foregroundColor: appBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: () {},
                  child: const Text(
                    'Withdraw Funds',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget earningsCard(String label, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: appBlack,
            ),
          ),
          Text(
            'KES $amount',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: appYellow,
            ),
          ),
        ],
      ),
    );
  }
}
