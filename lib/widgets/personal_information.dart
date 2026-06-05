import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class PersonalInformationPage extends StatelessWidget {
  final Map<String, dynamic>? profile;

  const PersonalInformationPage({super.key, this.profile});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
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
              infoField('Full Name', profile?["name"] ?? "Not provided"),
              infoField('Phone Number', profile?["phone"] ?? "Not provided"),
              infoField('Email Address', profile?["email"] ?? "Not provided"),
              infoField('ID Number', profile?["id_number"] ?? "Not provided"),
              infoField('Address', profile?["address"] ?? "Not provided"),
              infoField('Date of Birth', profile?["dob"] ?? "Not provided"),
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
                    'Edit Information',
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

  Widget infoField(String label, String value) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.withOpacity(0.15)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: appBlack,
            ),
          ),
        ],
      ),
    );
  }
}
