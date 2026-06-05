import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class DocumentsPage extends StatelessWidget {
  final Map<String, dynamic>? documents;

  const DocumentsPage({super.key, this.documents});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Documents'),
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
              documentCard(
                'Driving License',
                documents?["license"] ?? "Not submitted",
              ),
              documentCard('National ID', documents?["id"] ?? "Not submitted"),
              documentCard(
                'Vehicle Registration',
                documents?["registration"] ?? "Not submitted",
              ),
              documentCard(
                'Insurance Certificate',
                documents?["insurance"] ?? "Not submitted",
              ),
              documentCard(
                'Tax Clearance',
                documents?["tax_clearance"] ?? "Not submitted",
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
                    'Upload Documents',
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

  Widget documentCard(String label, String status) {
    final isVerified = status.toLowerCase() == "verified";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.98),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isVerified
                  ? Colors.green.withOpacity(0.1)
                  : Colors.orange.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              isVerified ? Icons.check_circle : Icons.pending,
              color: isVerified ? Colors.green : Colors.orange,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: appBlack,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  status,
                  style: TextStyle(
                    fontSize: 12,
                    color: isVerified ? Colors.green : Colors.orange,
                    fontWeight: FontWeight.w600,
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
