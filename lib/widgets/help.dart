import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class HelpScreen extends StatefulWidget {
  const HelpScreen({super.key});

  @override
  State<HelpScreen> createState() => _HelpScreenState();
}

class _HelpScreenState extends State<HelpScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Help Center'),
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
              faqCard(
                'How do I update my profile?',
                'Go to your profile and tap on any section to edit your information. Make sure to save your changes.',
              ),
              faqCard(
                'How can I track my earnings?',
                'Visit the Earnings & Wallet section to view your daily, weekly, and monthly earnings in real-time.',
              ),
              faqCard(
                'How do I receive payments?',
                'You can withdraw funds directly to your bank account from the Earnings & Wallet page. Withdrawals are processed within 24 hours.',
              ),
              faqCard(
                'What are the document requirements?',
                'You need a valid national ID, driving license, vehicle registration, insurance certificate, and tax clearance.',
              ),
              faqCard(
                'How do I contact support?',
                'You can reach our support team via email at support@cozzycruise.com or call us at +254-800-500-500.',
              ),
              faqCard(
                'Can I change my payment method?',
                'Yes, you can update your payment method from your settings at any time.',
              ),
              const SizedBox(height: 24),
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
                  onPressed: () {
                    // Contact support
                  },
                  child: const Text(
                    'Contact Support',
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

  Widget faqCard(String question, String answer) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            question,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: appBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            answer,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
