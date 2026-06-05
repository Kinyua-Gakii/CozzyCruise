import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavigationScreen extends StatefulWidget {
  final String? passengerId;
  final String? passengername;
  final String? profileImageUrl;
  final String? pickupLocation;
  final String? dropoffLocation;
  final double? pickupLat;
  final double? pickupLng;
  final double? dropoffLat;
  final double? dropoffLng;
  final double? fare;
  final String? paymentMethod;

  const NavigationScreen({
    super.key,
    this.passengerId,
    this.passengername,
    this.profileImageUrl,
    this.pickupLocation,
    this.dropoffLocation,
    this.pickupLat,
    this.pickupLng,
    this.dropoffLat,
    this.dropoffLng,
    this.fare,
    this.paymentMethod,
  });

  @override
  State<NavigationScreen> createState() => _NavigationScreenState();
}

class _NavigationScreenState extends State<NavigationScreen> {
  _TripStage stage = _TripStage.enRouteToPickup;

  void _onActionButtonPressed() {
    switch (stage) {
      case _TripStage.enRouteToPickup:
        setState(() => stage = _TripStage.arrivedAtPickup);
      case _TripStage.arrivedAtPickup:
        setState(() => stage = _TripStage.tripInProgress);
      case _TripStage.tripInProgress:
        setState(() => stage = _TripStage.nearDestination);
      case _TripStage.nearDestination:
        setState(() => stage = _TripStage.tripCompleted);
      case _TripStage.tripCompleted:
        break;
    }
  }

  String get _statusTitle {
    switch (stage) {
      case _TripStage.enRouteToPickup:
        return 'EN ROUTE TO PICKUP';
      case _TripStage.arrivedAtPickup:
        return 'ARRIVED AT PICKUP';
      case _TripStage.tripInProgress:
        return 'TRIP IN PROGRESS';
      case _TripStage.nearDestination:
        return 'NEAR DESTINATION';
      case _TripStage.tripCompleted:
        return 'TRIP COMPLETED';
    }
  }

  String get _instructionTitle {
    switch (stage) {
      case _TripStage.enRouteToPickup:
        return 'Drive to pickup';
      case _TripStage.arrivedAtPickup:
        return 'You have arrived';
      case _TripStage.tripInProgress:
        return 'Drive to drop-off';
      case _TripStage.nearDestination:
        return 'Approaching drop-off';
      case _TripStage.tripCompleted:
        return 'Trip completed';
    }
  }

  String get _instructionSubtitle {
    switch (stage) {
      case _TripStage.enRouteToPickup:
      case _TripStage.arrivedAtPickup:
        return widget.pickupLocation ?? '';
      case _TripStage.tripInProgress:
      case _TripStage.nearDestination:
      case _TripStage.tripCompleted:
        return widget.dropoffLocation ?? '';
    }
  }

  String get _actionText {
    switch (stage) {
      case _TripStage.enRouteToPickup:
        return 'I HAVE ARRIVED';
      case _TripStage.arrivedAtPickup:
        return 'START TRIP';
      case _TripStage.tripInProgress:
      case _TripStage.nearDestination:
        return 'END TRIP';
      case _TripStage.tripCompleted:
        return 'VIEW SUMMARY';
    }
  }

  String get _distanceText {
    switch (stage) {
      case _TripStage.enRouteToPickup:
        return '2.4 km';
      case _TripStage.arrivedAtPickup:
        return '0.1 km';
      case _TripStage.tripInProgress:
        return '15.6 km';
      case _TripStage.nearDestination:
        return '1.2 km';
      case _TripStage.tripCompleted:
        return '0.0 km';
    }
  }

  String get _etaText {
    switch (stage) {
      case _TripStage.enRouteToPickup:
        return '6 min';
      case _TripStage.arrivedAtPickup:
        return 'Now';
      case _TripStage.tripInProgress:
        return '22 min';
      case _TripStage.nearDestination:
        return '3 min';
      case _TripStage.tripCompleted:
        return '--';
    }
  }

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF0A0C10);
    const yellow = Color(0xFFF4C42D);
    const page = Color(0xFFF7F3E9);
    const card = Color(0xFFFFFFFF);
    const line = Color(0xFFE6DFCF);

    return Scaffold(
      backgroundColor: page,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            children: [
              _statusBar(),
              const SizedBox(height: 8),
              _riderCard(card, line),
              const SizedBox(height: 8),
              Expanded(child: _mockMap(card, line, yellow)),
              const SizedBox(height: 8),
              _tripDetailsRow(card, line),
              const SizedBox(height: 8),
              _primaryActionButton(black, yellow),
              const SizedBox(height: 8),
              _bottomActions(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _statusBar() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF10131A),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          Container(
            width: 10,
            height: 10,
            decoration: const BoxDecoration(
              color: Color(0xFF72D35A),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _statusTitle,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12.5,
                        letterSpacing: 0.2,
                      ),
                    ),
                  ],
                ),
                Container(
                  width: 32,
                  height: 32,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white24),
                  ),
                  child: const Icon(
                    Icons.shield_outlined,
                    color: Colors.white,
                    size: 17,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _riderCard(Color card, Color line) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: line),
      ),
      child: Column(
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 21,
                backgroundColor: const Color(0xFFECE4D6),
                backgroundImage:
                    (widget.profileImageUrl != null &&
                        widget.profileImageUrl!.isNotEmpty)
                    ? NetworkImage(widget.profileImageUrl!)
                    : null,
                child:
                    (widget.profileImageUrl == null ||
                        widget.profileImageUrl!.isEmpty)
                    ? const Icon(Icons.person, color: Color(0xFF8D7555))
                    : null,
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.passengername ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                        color: Color(0xFF111111),
                      ),
                    ),
                    const SizedBox(height: 2),
                    const SizedBox.shrink(),
                  ],
                ),
              ),
              _smallRoundIcon(Icons.call_outlined),
              const SizedBox(width: 8),
              _smallRoundIcon(Icons.chat_bubble_outline),
            ],
          ),
          const SizedBox(height: 10),
          Container(height: 1, color: line),
          const SizedBox(height: 10),
          _locationRow(
            dot: const Color(0xFF63C846),
            label: 'Pickup',
            location: widget.pickupLocation ?? '',
            distance: '',
          ),
          const SizedBox(height: 8),
          _locationRow(
            dot: const Color(0xFFE15E4F),
            label: 'Drop-off',
            location: widget.dropoffLocation ?? '',
            distance: '',
          ),
        ],
      ),
    );
  }

  Widget _smallRoundIcon(IconData icon) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFF8F6F1),
        border: Border.all(color: const Color(0xFFEAE3D3)),
      ),
      child: Icon(icon, color: const Color(0xFF232323), size: 17),
    );
  }

  Widget _locationRow({
    required Color dot,
    required String label,
    required String location,
    required String distance,
  }) {
    return Row(
      children: [
        Container(
          width: 8,
          height: 8,
          decoration: BoxDecoration(color: dot, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 54,
          child: Text(
            label,
            style: const TextStyle(fontSize: 12.5, color: Color(0xFF6A6A6A)),
          ),
        ),
        Expanded(
          child: Text(
            location,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 13.5,
              fontWeight: FontWeight.w600,
              color: Color(0xFF171717),
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          distance,
          style: const TextStyle(fontSize: 12.5, color: Color(0xFF343434)),
        ),
      ],
    );
  }

  Widget _mockMap(Color card, Color line, Color yellow) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: line),
      ),
      child: Stack(
        children: [
          Positioned.fill(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: CustomPaint(painter: _MockMapPainter()),
            ),
          ),
          Positioned(top: 26, right: 30, child: _mapPin()),
          Positioned(
            left: 12,
            bottom: 98,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Row(
                children: [
                  Icon(Icons.my_location, size: 14),
                  SizedBox(width: 6),
                  Text('Re-center', style: TextStyle(fontSize: 12.5)),
                ],
              ),
            ),
          ),
          Positioned(
            right: 12,
            bottom: 96,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(Icons.navigation_outlined, size: 20),
            ),
          ),
          Positioned(
            left: 12,
            right: 12,
            bottom: 14,
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFF4EDCB),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Container(
                    width: 33,
                    height: 33,
                    decoration: const BoxDecoration(
                      color: Colors.black,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.north,
                      color: Color(0xFFF4C42D),
                      size: 19,
                    ),
                  ),
                  const SizedBox(width: 9),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          _instructionTitle,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Color(0xFF151515),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          _instructionSubtitle,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF606060),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        _distanceText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF131313),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        _etaText,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF5B5B5B),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _mapPin() {
    return Column(
      children: [
        Container(
          width: 20,
          height: 20,
          decoration: const BoxDecoration(
            color: Color(0xFF151515),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.circle, size: 5, color: Colors.white),
        ),
        ClipPath(
          clipper: _PinTailClipper(),
          child: Container(
            width: 9,
            height: 10,
            color: const Color(0xFF151515),
          ),
        ),
      ],
    );
  }

  Widget _tripDetailsRow(Color card, Color line) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: line),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _detailColumn('Distance', _distanceText),
          _lightDivider(line),
          _detailColumn('ETA', _etaText),
          _lightDivider(line),
          _detailColumn(
            'Fare (Est.)',
            widget.fare != null ? 'KES ${widget.fare!.toStringAsFixed(0)}' : '',
          ),
          _lightDivider(line),
          _detailColumn('Payment', widget.paymentMethod ?? ''),
        ],
      ),
    );
  }

  Widget _detailColumn(String label, String value) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 10.5, color: Color(0xFF7B7B7B)),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w800,
            color: Color(0xFF111111),
          ),
        ),
      ],
    );
  }

  Widget _lightDivider(Color line) {
    return Container(width: 1, height: 28, color: line);
  }

  Widget _primaryActionButton(Color black, Color yellow) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: _onActionButtonPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: black,
          foregroundColor: yellow,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: Text(
          _actionText,
          style: const TextStyle(
            fontWeight: FontWeight.w900,
            letterSpacing: 0.6,
          ),
        ),
      ),
    );
  }

  Widget _bottomActions() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _bottomButton(
            icon: Icons.sos,
            label: 'SOS',
            iconColor: Colors.redAccent,
            onTap: () => context.push('/emergency'),
          ),
          _bottomButton(
            icon: Icons.share,
            label: 'Share Trip',
            iconColor: const Color(0xFF1A1A1A),
            onTap: () => context.push('/share-trip'),
          ),
          _bottomButton(
            icon: Icons.headset_mic,
            label: 'Support',
            iconColor: const Color(0xFF1A1A1A),
            onTap: () => context.push('/support'),
          ),
        ],
      ),
    );
  }

  Widget _bottomButton({
    required IconData icon,
    required String label,
    required Color iconColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.white,
              border: Border.all(color: const Color(0xFFE7E0D0)),
            ),
            child: Icon(icon, color: iconColor, size: 20),
          ),
          const SizedBox(height: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 11.5,
              color: Color(0xFF232323),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

enum _TripStage {
  enRouteToPickup,
  arrivedAtPickup,
  tripInProgress,
  nearDestination,
  tripCompleted,
}

class _MockMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final minorRoad = Paint()
      ..color = const Color(0xFFEFECE5)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2
      ..strokeCap = StrokeCap.round;

    final majorRoad = Paint()
      ..color = const Color(0xFFE2DCCD)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeCap = StrokeCap.round;

    for (double y = 24; y < size.height; y += 34) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y + 11), minorRoad);
    }

    for (double x = 16; x < size.width; x += 44) {
      canvas.drawLine(Offset(x, 0), Offset(x - 14, size.height), minorRoad);
    }

    final route = Path()
      ..moveTo(size.width * 0.67, size.height * 0.18)
      ..quadraticBezierTo(
        size.width * 0.58,
        size.height * 0.30,
        size.width * 0.54,
        size.height * 0.40,
      )
      ..quadraticBezierTo(
        size.width * 0.50,
        size.height * 0.51,
        size.width * 0.43,
        size.height * 0.61,
      )
      ..quadraticBezierTo(
        size.width * 0.39,
        size.height * 0.69,
        size.width * 0.46,
        size.height * 0.79,
      );

    canvas.drawPath(route, majorRoad..strokeWidth = 7);
    canvas.drawPath(
      route,
      Paint()
        ..color = const Color(0xFF1D1D1D)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 5
        ..strokeCap = StrokeCap.round,
    );

    final pickup = Paint()..color = const Color(0xFF4CAD3F);
    final driver = Paint()..color = const Color(0xFF2F7DE0);

    canvas.drawCircle(Offset(size.width * 0.67, size.height * 0.18), 6, pickup);
    canvas.drawCircle(Offset(size.width * 0.46, size.height * 0.79), 8, driver);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _PinTailClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.moveTo(size.width / 2, size.height);
    path.lineTo(0, 0);
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}
