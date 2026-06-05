import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class ReferralRewardsPage extends StatelessWidget {
  final Map<String, dynamic>? referralData;

  const ReferralRewardsPage({super.key, this.referralData});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Referral & Rewards'),
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
              // Referral code card
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
                      'Your Referral Code',
                      style: TextStyle(
                        fontSize: 14,
                        color: appBlack,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      referralData?["code"] ?? "KES500",
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: appBlack,
                        letterSpacing: 2,
                      ),
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        icon: const Icon(Icons.share),
                        label: const Text('Share Code'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: appBlack,
                          foregroundColor: appYellow,
                        ),
                        onPressed: () {},
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // Rewards summary
              const Text(
                'Your Rewards',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 12),
              rewardCard(
                'Referrals Made',
                referralData?["referrals"]?.toString() ?? "0",
                Icons.people,
              ),
              rewardCard(
                'Bonus Earned',
                'KES ${referralData?["bonus"] ?? "0"}',
                Icons.card_giftcard,
              ),
              rewardCard(
                'Next Reward Unlocks',
                referralData?["next_reward"] ?? "At 5 referrals",
                Icons.trending_up,
              ),

              const SizedBox(height: 20),
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.blue),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'How it works',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                        color: Colors.blue,
                      ),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      '1. Share your referral code\n2. Friend signs up with your code\n3. Earn KES 500 bonus per referral\n4. Unlimited earning potential',
                      style: TextStyle(fontSize: 12, color: Colors.blue),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget rewardCard(String label, String value, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Row(
        children: [
          Icon(icon, color: appYellow, size: 24),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    color: appBlack,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
