import 'package:flutter/material.dart';
import 'package:cozzy_cruise/widgets/tripstatusbanner.dart';
export 'package:cozzy_cruise/widgets/tripstatusbanner.dart';

class TripStatusCard extends StatelessWidget {
  final TripStatus status;
  final String pickupAddress;
  final String dropoffAddress;
  final VoidCallback? onActionPressed;
  final String distanceText;
  final String etaText;

  const TripStatusCard({
    super.key,
    required this.status,
    required this.pickupAddress,
    required this.dropoffAddress,
    this.onActionPressed,
    required this.distanceText,
    required this.etaText,
  });

  String getTitle() {
    switch (status) {
      case TripStatus.enRouteToPickup:
        return "Drive to pickup";

      case TripStatus.arrivedAtPickup:
        return "Arrived at pickup";

      case TripStatus.tripInProgress:
        return "Drive to destination";

      case TripStatus.nearDestination:
        return "Near destination";

      case TripStatus.tripCompleted:
        return "Trip completed";
    }
  }

  String getSubtitle() {
    switch (status) {
      case TripStatus.enRouteToPickup:
        return pickupAddress;

      case TripStatus.arrivedAtPickup:
        return pickupAddress;

      case TripStatus.tripInProgress:
        return dropoffAddress;

      case TripStatus.nearDestination:
        return dropoffAddress;

      case TripStatus.tripCompleted:
        return dropoffAddress;
    }
  }

  String getButtonText() {
    switch (status) {
      case TripStatus.enRouteToPickup:
        return "I HAVE ARRIVED";

      case TripStatus.arrivedAtPickup:
        return "START TRIP";

      case TripStatus.tripInProgress:
        return "END TRIP";

      case TripStatus.nearDestination:
        return "COMPLETE TRIP";

      case TripStatus.tripCompleted:
        return "TRIP COMPLETED";
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          decoration: const BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10),
                child: Container(
                  width: 42,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.white24,
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(18, 18, 18, 18),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 48,
                      height: 48,
                      decoration: const BoxDecoration(
                        color: Color(0xFFF6C945),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Colors.black,
                        size: 24,
                      ),
                    ),

                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            getTitle(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 17,
                            ),
                          ),

                          const SizedBox(height: 4),

                          Text(
                            getSubtitle(),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(width: 12),

                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          distanceText,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 15,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          etaText,
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              Container(height: 1, color: Colors.white10),

              InkWell(
                onTap: onActionPressed,
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    getButtonText(),
                    style: const TextStyle(
                      color: Color(0xFFF6C945),
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
