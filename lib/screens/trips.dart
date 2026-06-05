import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cozzy_cruise/utils/responsive.dart';

class TripsPage extends StatefulWidget {
  final String timeStamp;
  final String tripID;
  final String pickupLocation;
  final String dropoffLocation;
  final String distance;
  final String statusText;
  final String fare;
  final String duration;
  final String name;
  final String tripStatus;

  const TripsPage({
    super.key,
    required this.timeStamp,
    required this.tripID,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.distance,
    required this.statusText,
    required this.fare,
    required this.duration,
    required this.name,
    required this.tripStatus,
  });

  @override
  State<TripsPage> createState() => _TripsPageState();
}

class _TripsPageState extends State<TripsPage> {
  String _selectedTab = 'All';
  final List<Map<String, String>> _trips = [];
  final bool _hasOngoingTrip = true;
  String _dateFilter = 'Today';
  DateTime _customStartDate = DateTime.now();
  DateTime _customEndDate = DateTime.now();

  List<Map<String, String>> get _filteredTrips {
    if (_selectedTab == 'All') return _trips;
    return _trips
        .where((t) => t['status'] == _selectedTab.toLowerCase())
        .toList();
  }

  String get _dateFilterLabel {
    if (_dateFilter == 'Today') {
      return 'Today, ${_formatDate(DateTime.now())}';
    } else if (_dateFilter == 'Custom') {
      return '${_formatDate(_customStartDate)} - ${_formatDate(_customEndDate)}';
    }
    return _dateFilter;
  }

  String _formatDate(DateTime date) {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    return '${date.day} ${months[date.month - 1]}';
  }

  Future<void> _showCustomDatePicker(BuildContext context) async {
    final now = DateTime.now();

    final DateTime? start = await showDatePicker(
      context: context,
      initialDate: _customStartDate,
      firstDate: DateTime(now.year - 1),
      lastDate: now,
      helpText: 'Select Start Date',
      builder: (context, child) => _datePickerTheme(context, child),
    );

    if (start == null) return;
    if (!context.mounted) return;

    final DateTime? end = await showDatePicker(
      context: context,
      initialDate: _customEndDate,
      firstDate: start,
      lastDate: now,
      helpText: 'Select End Date',
      builder: (context, child) => _datePickerTheme(context, child),
    );

    if (end == null) return;

    setState(() {
      _customStartDate = start;
      _customEndDate = end;
      _dateFilter = 'Custom';
    });
  }

  Widget _datePickerTheme(BuildContext context, Widget? child) {
    return Theme(
      data: Theme.of(context).copyWith(
        colorScheme: const ColorScheme.light(
          primary: Color(0xFF0A0C10),
          onPrimary: Color(0xFFF4C42D),
          onSurface: Color(0xFF0A0C10),
        ),
      ),
      child: child!,
    );
  }

  @override
  Widget build(BuildContext context) {
    const black = Color(0xFF0A0C10);
    const yellow = Color(0xFFF4C42D);
    const page = Color(0xFFF7F3E9);
    const card = Color(0xFFFFFFFF);
    const line = Color(0xFFE6DFCF);

    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Container(
      color: page,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(
                horizontalPadding,
                12,
                horizontalPadding,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Trips',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      color: Color(0xFF0A0C10),
                    ),
                  ),
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: card,
                      shape: BoxShape.circle,
                      border: Border.all(color: line),
                    ),
                    child: const Icon(
                      Icons.tune_rounded,
                      size: 18,
                      color: Color(0xFF0A0C10),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // calendar date display
                  Expanded(
                    child: GestureDetector(
                      onTap: () => _showCustomDatePicker(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 10,
                        ),
                        decoration: BoxDecoration(
                          color: card,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: line),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.calendar_today_outlined,
                              size: 15,
                              color: Color(0xFF6A6A6A),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              _dateFilterLabel,
                              style: const TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF0A0C10),
                              ),
                            ),
                            const Spacer(),
                            const Icon(
                              Icons.keyboard_arrow_down_rounded,
                              size: 18,
                              color: Color(0xFF6A6A6A),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  // This Week chip
                  _dateChip('This Week', yellow, black, card, line),
                  const SizedBox(width: 6),
                  // This Month chip
                  _dateChip('This Month', yellow, black, card, line),
                ],
              ),
            ),
            const SizedBox(height: 12),

            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: card,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: line),
                ),
                child: Row(
                  children: [
                    'All',
                    'Completed',
                    'Cancelled',
                    'Scheduled',
                  ].map((tab) => _buildTab(tab, yellow, black)).toList(),
                ),
              ),
            ),
            const SizedBox(height: 12),

            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: _buildContent(card, line, yellow),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _dateChip(
    String label,
    Color yellow,
    Color black,
    Color card,
    Color line,
  ) {
    final isSelected = _dateFilter == label;
    return GestureDetector(
      onTap: () => setState(() => _dateFilter = label),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? black : card,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: isSelected ? black : line),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isSelected ? yellow : const Color(0xFF6A6A6A),
          ),
        ),
      ),
    );
  }

  Widget _buildTab(String tab, Color yellow, Color black) {
    final isSelected = _selectedTab == tab;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTab = tab),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected ? black : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            tab,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: isSelected ? yellow : const Color(0xFF6A6A6A),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContent(Color card, Color line, Color yellow) {
    return ListView(
      children: [
        if (_hasOngoingTrip) ...[
          _ongoingTripCard(card, yellow),
          const SizedBox(height: 16),
        ],

        const Text(
          'Trip History',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: Color(0xFF0A0C10),
          ),
        ),
        const SizedBox(height: 10),

        if (_filteredTrips.isEmpty && _selectedTab != 'All')
          _emptyState(card)
        else
          ..._filteredTrips.map((trip) => _tripCard(trip, card, line)),
      ],
    );
  }

  Widget _ongoingTripCard(Color card, Color yellow) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: yellow, width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: yellow,
              borderRadius: BorderRadius.circular(6),
            ),
            child: const Text(
              'ONGOING TRIP',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w800,
                color: Color(0xFF0A0C10),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.timeStamp,
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF0A0C10),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      widget.name,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF333333),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.distance,
                      style: const TextStyle(
                        fontSize: 12.5,
                        color: Color(0xFF6A6A6A),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '${widget.pickupLocation} → ${widget.dropoffLocation}',
                    textAlign: TextAlign.end,
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF0A0C10),
                    ),
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed: () => context.push('/navigation'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A0C10),
                      foregroundColor: yellow,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 8,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: const Text(
                      'Open Navigation',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _tripCard(Map<String, String> trip, Color card, Color line) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: line),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trip['timestamp']?.split('•').first.trim() ?? '',
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF0A0C10),
                  ),
                ),
                Text(
                  trip['timestamp']?.split('•').last.trim() ?? '',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          // pickup + dropoff + distance/duration
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Icon(
                      Icons.circle_outlined,
                      size: 10,
                      color: Color(0xFF63C846),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        trip['pickupLocation'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A0C10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(
                      Icons.circle,
                      size: 10,
                      color: Color(0xFFE15E4F),
                    ),
                    const SizedBox(width: 5),
                    Expanded(
                      child: Text(
                        trip['dropoffLocation'] ?? '',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF0A0C10),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${trip['distance']} • ${trip['duration']}',
                  style: const TextStyle(
                    fontSize: 11.5,
                    color: Color(0xFF6A6A6A),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                'KES ${trip['fare']}',
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF0A0C10),
                ),
              ),
              const SizedBox(height: 6),
              _statusBadge(trip['status'] ?? ''),
            ],
          ),
        ],
      ),
    );
  }

  Widget _statusBadge(String status) {
    Color color;
    String label;

    switch (status) {
      case 'completed':
        color = const Color(0xFF4CAF50);
        label = 'COMPLETED';
        break;
      case 'cancelled':
        color = const Color(0xFFFF9800);
        label = 'CANCELLED';
        break;
      case 'no_show':
        color = const Color(0xFFE15E4F);
        label = 'NO SHOW';
        break;
      case 'scheduled':
        color = const Color(0xFF2196F3);
        label = 'SCHEDULED';
        break;
      default:
        color = const Color(0xFF6A6A6A);
        label = status.toUpperCase();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 10.5,
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
    );
  }

  Widget _emptyState(Color card) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 40),
      decoration: BoxDecoration(
        color: card,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          Icon(
            Icons.receipt_long_outlined,
            size: 48,
            color: Colors.grey.shade400,
          ),
          const SizedBox(height: 12),
          const Text(
            'No trips found',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF333333),
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'You don\'t have any trips for this period.',
            style: TextStyle(fontSize: 13, color: Color(0xFF6A6A6A)),
          ),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: () => setState(() => _selectedTab = 'All'),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0A0C10),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Text(
                'Clear Filters',
                style: TextStyle(
                  color: Color(0xFFF4C42D),
                  fontWeight: FontWeight.w700,
                  fontSize: 13,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
