import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class StatusBanner extends StatelessWidget {
  final String
  status; // not_submitted, pending, under_review, rejected, approved
  final String? rejectionReason;

  const StatusBanner({super.key, required this.status, this.rejectionReason});

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);
  static const Color _beige = Color(0xFFF4E7D3);

  @override
  Widget build(BuildContext context) {
    if (status == 'approved') {
      return const SizedBox.shrink();
    }

    final bannerData = _getBannerData();

    return GestureDetector(
      onTap: () => context.go('/pending'),

      child: Container(
        padding: const EdgeInsets.all(14),
        margin: const EdgeInsets.only(bottom: 12),

        decoration: BoxDecoration(
          color: bannerData.color.withOpacity(0.15),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: bannerData.color),
        ),

        child: Row(
          children: [
            Icon(bannerData.icon, color: bannerData.color),

            const SizedBox(width: 10),

            Expanded(
              child: Text(
                bannerData.text,
                style: const TextStyle(
                  color: _black,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),

            const Icon(Icons.arrow_forward_ios, size: 14, color: _black),
          ],
        ),
      ),
    );
  }

  // 🔥 This controls what the banner shows
  _BannerData _getBannerData() {
    switch (status) {
      case 'not_submitted':
        return _BannerData(
          text: "Complete your verification to start driving",
          color: _yellow,
          icon: Icons.upload_file,
        );

      case 'pending':
        return _BannerData(
          text: "Verification submitted. Waiting for approval",
          color: _yellow,
          icon: Icons.hourglass_bottom,
        );

      case 'under_review':
        return _BannerData(
          text: "Your documents are under review",
          color: _yellow,
          icon: Icons.search,
        );

      case 'rejected':
        return _BannerData(
          text: rejectionReason != null
              ? "Rejected: $rejectionReason"
              : "Verification failed. Tap to fix",
          color: Colors.red,
          icon: Icons.error,
        );

      default:
        return _BannerData(
          text: "Verification status",
          color: _yellow,
          icon: Icons.info,
        );
    }
  }
}

// 🔹 Helper model (clean separation)
class _BannerData {
  final String text;
  final Color color;
  final IconData icon;

  _BannerData({required this.text, required this.color, required this.icon});
}
