import 'package:flutter/material.dart';

class StatusToggle extends StatefulWidget {
  const StatusToggle({super.key, this.onToggle});

  final Function(bool)? onToggle;

  @override
  State<StatusToggle> createState() => _StatusToggleState();
}

class _StatusToggleState extends State<StatusToggle> {
  bool isOnline = false;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isCompact = constraints.maxWidth < 360;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: isCompact
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.circle,
                          color: isOnline ? Colors.green : Colors.grey,
                          size: 10,
                        ),
                        const SizedBox(width: 6),
                        Expanded(
                          child: Text(
                            isOnline ? 'You are Online' : 'You are Offline',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      isOnline
                          ? 'Waiting for ride requests'
                          : 'Go online to start receiving ride requests',
                      style: const TextStyle(color: Colors.grey),
                    ),
                    const SizedBox(height: 8),
                    Align(
                      alignment: Alignment.centerRight,
                      child: Switch(
                        value: isOnline,
                        activeThumbColor: Colors.yellow[700],
                        onChanged: _handleToggle,
                      ),
                    ),
                  ],
                )
              : Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: isOnline ? Colors.green : Colors.grey,
                                size: 10,
                              ),
                              const SizedBox(width: 6),
                              Flexible(
                                child: Text(
                                  isOnline
                                      ? 'You are Online'
                                      : 'You are Offline',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            isOnline
                                ? 'Waiting for ride requests'
                                : 'Go online to start receiving ride requests',
                            style: const TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Switch(
                      value: isOnline,
                      activeThumbColor: Colors.yellow[700],
                      onChanged: _handleToggle,
                    ),
                  ],
                ),
        );
      },
    );
  }

  void _handleToggle(bool val) {
    setState(() => isOnline = val);
    widget.onToggle?.call(val);
  }
}
