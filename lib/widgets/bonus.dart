import 'package:flutter/material.dart';

class BonusWidget extends StatelessWidget {
  const BonusWidget({super.key});

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
      child: Row(
        children: [
          const Icon(Icons.warning, color: Colors.red, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                Text(
                  "Seasonal Bonus",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 4),
                Text(
                  "Tap to claim your bonus",
                  style: TextStyle(color: Colors.black),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed: () {
              // Handle bonus button press
            },
            child: const Text("Bonus"),
          ),
        ],
      ),
    );
  }
}
