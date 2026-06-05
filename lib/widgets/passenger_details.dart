import 'package:flutter/material.dart';

class PassengerHeaderWidget extends StatelessWidget {
  final String name;
  final String pickupLocation;
  final String dropoffLocation;
  final String pickupDistance;
  final String dropoffDistance;
  final String? profileImageUrl;

  const PassengerHeaderWidget({
    super.key,
    required this.name,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.pickupDistance,
    required this.dropoffDistance,
    this.profileImageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 24,
                backgroundColor: Colors.grey[200],
                backgroundImage: profileImageUrl != null
                    ? NetworkImage(profileImageUrl!)
                    : null,
                child: profileImageUrl == null
                    ? const Icon(Icons.person, color: Colors.grey)
                    : null,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  name,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
              // Action Buttons
              _buildRoundAction(Icons.call),
              const SizedBox(width: 10),
              _buildRoundAction(Icons.chat_bubble_outline),
            ],
          ),

          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(height: 1, color: Color(0xFFEEEEEE)),
          ),

          Stack(
            children: [
              Positioned(
                left: 7,
                top: 25,
                bottom: 25,
                child: CustomPaint(
                  size: const Size(1, double.infinity),
                  painter: DashedLinePainter(),
                ),
              ),
              Column(
                children: [
                  _buildRouteRow(
                    iconColor: Colors.green,
                    label: "Pickup",
                    address: pickupLocation,
                    distance: pickupDistance,
                  ),
                  const SizedBox(height: 16),
                  _buildRouteRow(
                    iconColor: Colors.red,
                    label: "Drop-off",
                    address: dropoffLocation,
                    distance: dropoffDistance,
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRouteRow({
    required Color iconColor,
    required String label,
    required String address,
    required String distance,
  }) {
    return Row(
      children: [
        Icon(Icons.circle, size: 14, color: iconColor),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(fontSize: 11, color: Colors.grey),
              ),
              Text(
                address,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
        Text(
          distance,
          style: const TextStyle(fontSize: 13, color: Colors.black54),
        ),
      ],
    );
  }

  Widget _buildRoundAction(IconData icon) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Colors.grey[100],
      ),
      child: Icon(icon, size: 20, color: Colors.black),
    );
  }
}

// Custom Painter for the timeline line
class DashedLinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    double dashHeight = 3, dashSpace = 3, startY = 0;
    final paint = Paint()
      ..color = Colors.grey[300]!
      ..strokeWidth = 1;
    while (startY < size.height) {
      canvas.drawLine(Offset(0, startY), Offset(0, startY + dashHeight), paint);
      startY += dashHeight + dashSpace;
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
