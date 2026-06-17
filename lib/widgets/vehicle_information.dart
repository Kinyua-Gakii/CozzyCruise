import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class VehicleInformationPage extends StatefulWidget {
  final Map<String, dynamic>? vehicle;

  const VehicleInformationPage({super.key, this.vehicle});

  @override
  State<VehicleInformationPage> createState() => _VehicleInformationPageState();
}

class _VehicleInformationPageState extends State<VehicleInformationPage> {
  bool isEditing = false;

  late final TextEditingController plateController;
  late final TextEditingController typeController;
  late final TextEditingController modelController;
  late final TextEditingController colorController;
  late final TextEditingController yearController;
  late final TextEditingController vinController;
  late final TextEditingController registrationController;

  @override
  void initState() {
    super.initState();
    plateController = TextEditingController(
      text: widget.vehicle?["plate"] ?? "",
    );
    typeController = TextEditingController(text: widget.vehicle?["type"] ?? "");
    modelController = TextEditingController(
      text: widget.vehicle?["model"] ?? "",
    );
    colorController = TextEditingController(
      text: widget.vehicle?["color"] ?? "",
    );
    yearController = TextEditingController(
      text: widget.vehicle?["year"]?.toString() ?? "",
    );
    vinController = TextEditingController(text: widget.vehicle?["vin"] ?? "");
    registrationController = TextEditingController(
      text: widget.vehicle?["registration"] ?? "",
    );
  }

  @override
  void dispose() {
    plateController.dispose();
    typeController.dispose();
    modelController.dispose();
    colorController.dispose();
    yearController.dispose();
    vinController.dispose();
    registrationController.dispose();
    super.dispose();
  }

  void _handleButtonTap() {
    if (isEditing) {
      // TODO: persist the updated values once the backend is ready, e.g.
      // send {plate: plateController.text, year: int.tryParse(yearController.text), ...}
      // to your API. For now the values just stay in local state.
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Vehicle information saved")),
      );
    }
    setState(() => isEditing = !isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Vehicle Information'),
        backgroundColor: Colors.white,
        foregroundColor: appBlack,
        elevation: 0,
      ),
      backgroundColor: const Color(0xFFF9F7F3),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              infoField('License Plate', plateController),
              infoField('Vehicle Type', typeController),
              infoField('Model', modelController),
              infoField('Color', colorController),
              infoField(
                'Year',
                yearController,
                keyboardType: TextInputType.number,
              ),
              infoField('VIN', vinController),
              infoField('Registration', registrationController),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: appYellow,
                    foregroundColor: appBlack,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  onPressed: _handleButtonTap,
                  child: Text(
                    isEditing ? 'Save Vehicle' : 'Edit Vehicle',
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget infoField(
    String label,
    TextEditingController controller, {
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: isEditing ? 6 : 14,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isEditing
              ? appYellow.withValues(alpha: 0.5)
              : Colors.grey.withValues(alpha: 0.15),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              color: Colors.grey[600],
              fontWeight: FontWeight.w500,
              letterSpacing: 0.3,
            ),
          ),
          const SizedBox(height: 6),
          isEditing
              ? TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: appBlack,
                  ),
                  decoration: const InputDecoration(
                    isDense: true,
                    isCollapsed: true,
                    border: InputBorder.none,
                    hintText: 'Enter value',
                  ),
                )
              : Text(
                  controller.text.isEmpty ? "Not provided" : controller.text,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: appBlack,
                  ),
                ),
        ],
      ),
    );
  }
}
