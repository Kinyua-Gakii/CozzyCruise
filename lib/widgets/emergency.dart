import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:go_router/go_router.dart';

class EmergencyScreen extends StatefulWidget {
  final String? type;
  const EmergencyScreen({
    super.key,
    this.type,
  }); //determine whether sos or help page

  @override
  State<EmergencyScreen> createState() => _EmergencyScreenState();
}

class _EmergencyScreenState extends State<EmergencyScreen> {
  String? selectedReason;
  String description = "";
  Map<String, dynamic>? emergencyContact;
  bool isLoadingContact = true;
  Map<String, dynamic>? carDetails;
  bool isLoadingCarDetails = true;

  final List<String> reasons = [
    "Car accident",
    "Harassment",
    "Medical emergency",
    "Unsafe driving",
    "Other",
  ];

  @override
  void initState() {
    super.initState();
    _loadEmergencyContact();
    _loadCarDetails();
  }

  Future<void> fetchEmergencyContact() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.example.com/emergency-contact"),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _loadEmergencyContact() async {
    await Future.delayed(const Duration(seconds: 1));
    setState(() {
      emergencyContact = {
        "name": "John Doe",
        "phone": "+1234567890",
        "relationship": "Spouse",
      };
      isLoadingContact = false;
    });
  }

  Future<void> fetchCarDetails() async {
    try {
      final response = await http.get(
        Uri.parse("https://api.example.com/car-details"),
      );
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<void> _loadCarDetails() async {
    await Future.delayed(const Duration(seconds: 1));
    final data = {
      "type": "Sedan",
      "model": "Toyota Axio",
      "plate": "KDA 123A",
      "color": "Black",
    };
    setState(() {
      carDetails = data;
      isLoadingCarDetails = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(widget.type == "SOS" ? "SOS Alert" : "Help")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildEmergencyContact(),
            const SizedBox(height: 16),

            _buildCarDetails(),
            const SizedBox(height: 16),

            _buildReasonDropdown(),
            const SizedBox(height: 16),

            _buildDescriptionField(),
            const SizedBox(height: 24),

            _buildSubmitButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyContact() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: const [
          Text(
            "Emergency Contact",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text("Name: John Doe"),
          Text("Phone: +254712345678"),
          Text("Relationship: Spouse"),
        ],
      ),
    );
  }

  Widget _buildCarDetails() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey),
        borderRadius: BorderRadius.circular(10),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Car Details", style: TextStyle(fontWeight: FontWeight.bold)),
          SizedBox(height: 8),
          Text("Type: Sedan"),
          Text("Model: Toyota Axio"),
          Text("N.O Plate: KDA 123A"),
          Text("Color: Black"),
        ],
      ),
    );
  }

  Widget _buildReasonDropdown() {
    return DropdownButtonFormField<String>(
      decoration: const InputDecoration(
        labelText: "Reason",
        border: OutlineInputBorder(),
      ),
      items: const [
        DropdownMenuItem(value: "Car accident", child: Text("Car accident")),
        DropdownMenuItem(value: "Harassment", child: Text("Harassment")),
        DropdownMenuItem(
          value: "Medical emergency",
          child: Text("Medical emergency"),
        ),
        DropdownMenuItem(
          value: "Unsafe driving",
          child: Text("Unsafe driving"),
        ),
        DropdownMenuItem(value: "Other", child: Text("Other")),
      ],
      onChanged: (value) {
        // later connect state here
      },
    );
  }

  Widget _buildDescriptionField() {
    return const TextField(
      maxLines: 3,
      decoration: InputDecoration(
        labelText: "Description (optional)",
        border: OutlineInputBorder(),
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: widget.type == "SOS" ? Colors.red : Colors.orange,
        ),
        onPressed: () {
          context.go("/home");
        },
        child: Text(
          widget.type == "SOS"
              ? "SEND SOS(ADMIN)"
              : "SEND HELP(Emergency Contact)",
        ),
      ),
    );
  }
}
