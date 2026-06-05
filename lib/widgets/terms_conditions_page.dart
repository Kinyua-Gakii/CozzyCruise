import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class TermsConditionsPage extends StatelessWidget {
  const TermsConditionsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Conditions'),
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
              sectionCard(
                'Acceptance of Terms',
                'By using the Cozzy Cruise app, you agree to comply with these terms and conditions. If you do not agree with any part of these terms, please do not use our services.',
              ),
              sectionCard(
                'User Responsibilities',
                'You are responsible for maintaining the confidentiality of your account information and password. You agree to accept responsibility for all activities that occur under your account. You must notify us immediately of any unauthorized use of your account.',
              ),
              sectionCard(
                'Service Usage',
                'You agree to use the Cozzy Cruise app only for lawful purposes and in a way that does not infringe upon the rights of others or restrict their use and enjoyment of the app. Prohibited behavior includes:\n• Harassing or causing distress or inconvenience to any person\n• Transmitting obscene or offensive content\n• Disrupting the normal flow of dialogue within the app',
              ),
              sectionCard(
                'Limitation of Liability',
                'The Cozzy Cruise app is provided on an "as is" basis without warranties of any kind. We do not warrant that the app will be uninterrupted or error-free. In no event shall Cozzy Cruise be liable for any indirect, incidental, special, or consequential damages.',
              ),
              sectionCard(
                'Changes to Terms',
                'We reserve the right to modify these terms at any time. Changes will be effective immediately upon posting to the app. Your continued use of the app following the posting of revised terms means that you accept and agree to the changes.',
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
                  onPressed: () {},
                  child: const Text(
                    'I Agree',
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

  Widget sectionCard(String title, String content) {
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
            title,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: appBlack,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            content,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey[600],
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }
}
