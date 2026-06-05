import 'package:flutter/material.dart';
import 'package:flutter/services.dart'; //clipboard
import 'package:location/location.dart';
import 'package:http/http.dart' as http;

class ShareTrip extends StatefulWidget {
  const ShareTrip({super.key});

  @override
  State<ShareTrip> createState() => _ShareTripState();
}

class _ShareTripState extends State<ShareTrip> {
  final String _tripId = "TRIP123456";
  final String _driverName = "John Doe";
  final Map<String, String> _vehicleInfo = {
    "type": "Sedan",
    "model": "Toyota Camry",
    "plate": "KAA 123A",
    "color": "Blue",
  };
  String get _shareLink => "https://cozzycruise.com/trip/$_tripId";
  bool _isLinkCopied = false;
  bool _isSharingLocation = false;
  late Location _location;
  LocationData? _currentLocation;
  DateTime? _sharingStartTime;

  @override
  void initState() {
    super.initState();
    _isRequestingLocation();
  }

  @override
  void dispose() {
    _isSharingLocation = false;
    super.dispose();
  }

  Future<void> _isRequestingLocation() async {
    final permissionStatus = await Location().requestPermission();

    if (permissionStatus != PermissionStatus.granted) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Location permission is required to share your trip.',
            ),
            backgroundColor: Colors.redAccent,
          ),
        );
      }
    }
  }

  Future<void> _requestPermission() async {
    final permissionStatus = await _location.requestPermission();

    if (permissionStatus != PermissionStatus.granted && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Location permission is required to share your trip.'),
          backgroundColor: Colors.redAccent,
        ),
      );
    }
  }

  Future<void> _startSharingLocation() async {
    final permissionStatus = await _location.hasPermission();

    if (permissionStatus != PermissionStatus.granted) {
      await _requestPermission();
      return;
    }

    setState(() {
      _isSharingLocation = true;
      _sharingStartTime = DateTime.now();
    });

    _location.onLocationChanged.listen((LocationData locationData) async {
      if (!_isSharingLocation) return;

      setState(() => _currentLocation = locationData);

      // Send to PHP backend
      try {
        await http.post(
          Uri.parse('https://yourserver.com/api/update-location'),
          body: {
            'trip_id': _tripId,
            'driver_name': _driverName,
            'vehicle_plate': _vehicleInfo['plate'],
            'vehicle_model': _vehicleInfo['model'],
            'vehicle_color': _vehicleInfo['color'],
            'latitude': locationData.latitude.toString(),
            'longitude': locationData.longitude.toString(),
          },
        );
      } catch (e) {
        debugPrint('Location update failed: $e');
      }
    });
  }

  void _stopSharingLocation() {
    setState(() {
      _isSharingLocation = false;
      _sharingStartTime = null;
    });
  }

  Future<void> _copyLink() async {
    await Clipboard.setData(ClipboardData(text: _shareLink));

    setState(() => _isLinkCopied = true);

    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) setState(() => _isLinkCopied = false);
    });
  }

  @override
Widget build(BuildContext context) {
  const black = Color(0xFF111111);
  const yellow = Color(0xFFF6C945);
  const beige = Color(0xFFF4E7D3);
  const white = Color(0xFFFDFDFB);

  return Scaffold(
    backgroundColor: beige,
    appBar: AppBar(
      backgroundColor: beige,
      elevation: 0,
      title: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.share_location, color: black, size: 20),
          SizedBox(width: 8),
          Text(
            'Share Trip',
            style: TextStyle(
              color: black,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: black),
        onPressed: () {
          _stopSharingLocation();
          Navigator.pop(context);
        },
      ),
    ),

    body: SingleChildScrollView(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildStatusCard(black, yellow),
          const SizedBox(height: 20),
          _buildInfoCard(black, yellow, white),
          const SizedBox(height: 20),
          _buildLinkCard(black, yellow),
          const SizedBox(height: 32),
          _buildActionButton(black, yellow, white),
          const SizedBox(height: 20),

          if (_isSharingLocation && _sharingStartTime != null)
            _buildSharingDuration(black),

        ],
      ),
    ),
  );
}

Widget _buildStatusCard(Color black, Color yellow) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      border: Border.all(
        color: _isSharingLocation
            ? yellow.withOpacity(0.6)
            : black.withOpacity(0.08),
      ),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Row(
      children: [
        Container(
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            color: _isSharingLocation ? yellow : black.withOpacity(0.2),
            shape: BoxShape.circle,
            boxShadow: _isSharingLocation
                ? [BoxShadow(color: yellow.withOpacity(0.5), blurRadius: 8)]
                : [],
          ),
        ),
        const SizedBox(width: 12),
        Text(
          _isSharingLocation
              ? 'Live location is being shared'
              : 'Location sharing is off',
          style: TextStyle(
            color: _isSharingLocation ? black : black.withOpacity(0.4),
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
        ),
      ],
    ),
  );
}

// ── INFO CARD ──
Widget _buildInfoCard(Color black, Color yellow, Color white) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Trip Details',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 14),
        _infoRow(Icons.person, 'Driver', _driverName, black, yellow),
        const SizedBox(height: 10),
        _infoRow(Icons.car_rental_sharp, 'Vehicle Type', _vehicleInfo['type']!, black, yellow),
        _infoRow(Icons.directions_car, 'Vehicle',
            _vehicleInfo['model']!, black, yellow),
        const SizedBox(height: 10),
        _infoRow(Icons.pin, 'Plate', _vehicleInfo['plate']!, black, yellow),
        const SizedBox(height: 10),
        _infoRow(
            Icons.color_lens, 'Color', _vehicleInfo['color']!, black, yellow),
      ],
    ),
  );
}

Widget _infoRow(
  IconData icon,
  String label,
  String value,
  Color black,
  Color yellow,
) {
  return Row(
    children: [
      Icon(icon, color: yellow, size: 18),
      const SizedBox(width: 10),
      Text(
        '$label: ',
        style: TextStyle(
          color: black.withOpacity(0.4),
          fontSize: 13,
        ),
      ),
      Text(
        value,
        style: TextStyle(
          color: black,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    ],
  );
}

Widget _buildLinkCard(Color black, Color yellow) {
  return Container(
    padding: const EdgeInsets.all(16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: black.withOpacity(0.06),
          blurRadius: 8,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          ' Link',
          style: TextStyle(
            color: black,
            fontWeight: FontWeight.w700,
            fontSize: 15,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: black.withOpacity(0.05),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  _shareLink,
                  style: TextStyle(
                    color: black.withOpacity(0.5),
                    fontSize: 13,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 10),
              GestureDetector(
                onTap: _copyLink,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: _isLinkCopied ? Colors.green : yellow,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        _isLinkCopied ? Icons.check : Icons.copy,
                        size: 14,
                        color: black,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        _isLinkCopied ? 'Copied!' : 'Copy',
                        style: TextStyle(
                          color: black,
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    ),
  );
}

Widget _buildActionButton(Color black, Color yellow, Color white) {
  return SizedBox(
    width: double.infinity,
    child: GestureDetector(
      onTap: _isSharingLocation
          ? _stopSharingLocation
          : _startSharingLocation,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 18),
        decoration: BoxDecoration(
          color: _isSharingLocation ? Colors.redAccent : yellow,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: (_isSharingLocation ? Colors.redAccent : yellow)
                  .withOpacity(0.3),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Center(
          child: Text(
            _isSharingLocation ? 'Stop Sharing' : 'Start Sharing',
            style: TextStyle(
              color: _isSharingLocation ? white : black,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
        ),
      ),
    ),
  );
}

Widget _buildSharingDuration(Color black) {
  final duration = DateTime.now().difference(_sharingStartTime!);
  final minutes = duration.inMinutes;
  final seconds = duration.inSeconds % 60;

  return Center(
    child: Text(
      'Sharing for ${minutes}m ${seconds}s',
      style: TextStyle(
        color: black.withOpacity(0.4),
        fontSize: 13,
      ),
    ),
  );
}
}
