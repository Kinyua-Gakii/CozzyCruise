import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cozzy_cruise/utils/responsive.dart';

class PendingPage extends StatelessWidget {
  final String
  status; // not_submitted, pending, under_review, rejected, approved
  final String? rejectionReason;

  const PendingPage({super.key, required this.status, this.rejectionReason});

  static const Color _black = Color(0xFF111111);
  static const Color _yellow = Color(0xFFF6C945);
  static const Color _beige = Color(0xFFF4E7D3);
  static const Color _white = Color(0xFFFDFDFB);

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: _beige,
      appBar: AppBar(
        backgroundColor: _white,
        leading: GestureDetector(
          onTap: () => context.go('/home'),
          child: const Icon(Icons.arrow_back_ios_new, color: _black),
        ),
        elevation: 0,
        title: const Text(
          "Verification Status",
          style: TextStyle(color: _black),
        ),
        iconTheme: const IconThemeData(color: _black),
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: EdgeInsets.all(horizontalPadding),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: _buildContent(context),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(BuildContext context) {
    switch (status) {
      case 'not_submitted':
        return _statusCard(
          icon: Icons.upload_file,
          title: "Verification Required",
          message: "Submit your documents ",
          color: _yellow,
          buttonText: "Submit Documents",
          onPressed: () => context.go('/validation'),
        );

      case 'pending':
        return _statusCard(
          icon: Icons.hourglass_bottom,
          title: "Submission Received",
          message: "Your documents have been submitted successfully.",
          color: _yellow,
        );

      case 'under_review':
        return _statusCard(
          icon: Icons.search,
          title: "Under Review",
          message: "Your documents are under review. Please wait.",
          color: _yellow,
        );

      case 'rejected':
        return _statusCard(
          icon: Icons.cancel,
          title: "Verification Rejected",
          message: rejectionReason ?? "Your documents were not approved.",
          color: Colors.red,
          buttonText: "Resubmit",
          onPressed: () => context.go('/validation'),
        );

      case 'approved':
        return _statusCard(
          icon: Icons.check_circle,
          title: "Approved",
          message: "Verified",
          color: Colors.green,
        );

      default:
        return const Text("Unknown status");
    }
  }

  Widget _statusCard({
    required IconData icon,
    required String title,
    required String message,
    required Color color,
    String? buttonText,
    VoidCallback? onPressed,
  }) {
    return Builder(
      builder: (context) {
        final isMobile = ResponsiveUtils.isMobile(context);
        final padding = isMobile ? 16.0 : 24.0;
        final iconSize = isMobile ? 50.0 : 60.0;
        final titleFontSize = isMobile ? 18.0 : 20.0;

        return Container(
          padding: EdgeInsets.all(padding),
          decoration: BoxDecoration(
            color: _white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, size: iconSize, color: color),
              const SizedBox(height: 20),
              Text(
                title,
                style: TextStyle(
                  fontSize: titleFontSize,
                  fontWeight: FontWeight.bold,
                  color: _black,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              Text(
                message,
                style: const TextStyle(color: Colors.grey),
                textAlign: TextAlign.center,
              ),
              if (buttonText != null) ...[
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _yellow,
                      foregroundColor: _black,
                      padding: EdgeInsets.symmetric(
                        vertical: isMobile ? 12 : 14,
                        horizontal: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: onPressed,
                    child: Text(
                      buttonText,
                      style: TextStyle(
                        fontSize: isMobile ? 14 : 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
        );
      },
    );
  }
}
