import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class PrivacyPolicyPage extends StatelessWidget {
  const PrivacyPolicyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Privacy Policy'),
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
                'Information We Collect',
                'We collect information you provide directly, such as when you create an account, update your profile, or contact our support team. This includes your name, email address, phone number, location, vehicle information, and payment details.',
              ),
              sectionCard(
                'How We Use Your Information',
                'We use your information to:\n• Provide and improve our services\n• Process transactions and send related information\n• Send technical notices and support messages\n• Respond to your comments and questions\n• Send marketing communications (with your consent)\n• Monitor and analyze trends and usage',
              ),
              sectionCard(
                'Data Security',
                'We implement appropriate technical and organizational measures to protect your personal information against unauthorized access, alteration, disclosure, or destruction. However, no method of transmission over the internet is 100% secure.',
              ),
              sectionCard(
                'Third-Party Sharing',
                'We do not sell, trade, or rent your personal information to third parties. We may share your information with service providers who assist us in operating our app and conducting our business, subject to confidentiality agreements.',
              ),
              sectionCard(
                'Cookies and Tracking',
                'We use cookies and similar tracking technologies to enhance your experience. You can control cookie settings through your browser preferences.',
              ),
              sectionCard(
                'Your Rights',
                'You have the right to access, correct, or delete your personal information. You can also opt-out of receiving marketing communications at any time. To exercise these rights, please contact us at privacy@cozzycruise.com.',
              ),
              sectionCard(
                'Changes to Privacy Policy',
                'We may update this privacy policy from time to time. We will notify you of any changes by updating the "Last Updated" date and posting the new version in the app.',
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
                    'I Understand',
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
