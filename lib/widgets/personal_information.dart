import 'package:flutter/material.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBlack = Color(0xFF111111);

class PersonalInformationPage extends StatefulWidget {
  final Map<String, dynamic>? profile;

  const PersonalInformationPage({super.key, this.profile});

  @override
  State<PersonalInformationPage> createState() =>
      _PersonalInformationPageState();
}

class _PersonalInformationPageState extends State<PersonalInformationPage> {
  bool isEditing = false;

  late final TextEditingController nameController;
  late final TextEditingController phoneController;
  late final TextEditingController emailController;
  late final TextEditingController idNumberController;
  late final TextEditingController addressController;
  late final TextEditingController dobController;

  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.profile?["name"] ?? "");
    phoneController = TextEditingController(
      text: widget.profile?["phone"] ?? "",
    );
    emailController = TextEditingController(
      text: widget.profile?["email"] ?? "",
    );
    idNumberController = TextEditingController(
      text: widget.profile?["id_number"] ?? "",
    );
    addressController = TextEditingController(
      text: widget.profile?["address"] ?? "",
    );
    dobController = TextEditingController(text: widget.profile?["dob"] ?? "");
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    idNumberController.dispose();
    addressController.dispose();
    dobController.dispose();
    super.dispose();
  }

  void _handleButtonTap() {
    if (isEditing) {
      // TODO: persist the updated values once the backend is ready, e.g.
      // send {name: nameController.text, phone: phoneController.text, ...}
      // to your API. For now the values just stay in local state.
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Information saved")));
    }
    setState(() => isEditing = !isEditing);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Personal Information'),
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
              infoField('Full Name', nameController),
              infoField('Phone Number', phoneController),
              infoField('Email Address', emailController),
              infoField('ID Number', idNumberController),
              infoField('Address', addressController),
              infoField('Date of Birth', dobController),
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
                    isEditing ? 'Save Information' : 'Edit Information',
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

  Widget infoField(String label, TextEditingController controller) {
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
