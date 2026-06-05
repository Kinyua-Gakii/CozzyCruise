import 'package:flutter/material.dart';

enum TripStatus {
  enRouteToPickup,
  arrivedAtPickup,
  tripInProgress,
  nearDestination,
  tripCompleted,
}

class TripStatusBanner extends StatelessWidget {
  final TripStatus status;
  final VoidCallback? onTap;

  const TripStatusBanner({super.key, required this.status, this.onTap});

  String getStatusText() {
    switch (status) {
      case TripStatus.enRouteToPickup:
        return 'EN ROUTE TO PICKUP';
      case TripStatus.arrivedAtPickup:
        return 'ARRIVED AT PICKUP';
      case TripStatus.tripInProgress:
        return 'TRIP IN PROGRESS';
      case TripStatus.nearDestination:
        return 'NEAR DESTINATION';
      case TripStatus.tripCompleted:
        return 'TRIP COMPLETED';
    }
  }

  Color getIndicatorColor() {
    switch (status) {
      case TripStatus.enRouteToPickup:
        return const Color.fromARGB(255, 1, 29, 2);
      case TripStatus.arrivedAtPickup:
        return Colors.orange;
      case TripStatus.tripInProgress:
        return Colors.blue;
      case TripStatus.nearDestination:
        return Colors.deepOrange;
      case TripStatus.tripCompleted:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            borderRadius: BorderRadius.circular(18),
            onTap: onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 250),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(18),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.18),
                    blurRadius: 14,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: getIndicatorColor(),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      getStatusText(),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 13,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.arrow_forward_ios_rounded,
                      color: Colors.white,
                      size: 14,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
