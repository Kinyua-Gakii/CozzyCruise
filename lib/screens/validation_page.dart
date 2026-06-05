import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:cozzy_cruise/utils/responsive.dart';

const Color kYellow = Color(0xFFF6C945);
const Color kBeige = Color(0xFFFDF8EE);
const Color kBlack = Color(0xFF111111);
const Color kGray = Color(0xFFBDBDBD);
const Color kWhite = Color(0xFFFFFFFF);

class ValidationPage extends StatefulWidget {
  const ValidationPage({super.key});

  @override
  State<ValidationPage> createState() => _ValidationPageState();
}

class _ValidationPageState extends State<ValidationPage> {
  final ImagePicker _picker = ImagePicker();

  bool loading = false;

  // 🧠 Controllers (CAR DETAILS FORM)
  final TextEditingController carTypeController = TextEditingController();
  final TextEditingController numberPlateController = TextEditingController();
  final TextEditingController carModelController = TextEditingController();
  final TextEditingController carColorController = TextEditingController();

  // 🧾 DOCUMENTS
  File? idFront;
  File? idBack;
  File? selfie;
  File? driverLicense;
  File? insurance;
  File? logBook; // ✅ FIXED LOGBOOK
  File? psvLicense;

  // 🚗 CAR IMAGES
  File? carFront;
  File? carBack;
  File? interiorFront;
  File? interiorBack;

  // ---------------- PICKERS ----------------

  Future<void> pickImage(Function(File) onPicked) async {
    final picked = await _picker.pickImage(source: ImageSource.gallery);
    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  Future<void> takeSelfie(Function(File) onPicked) async {
    final picked = await _picker.pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
      imageQuality: 80,
    );
    if (picked != null) {
      onPicked(File(picked.path));
    }
  }

  Widget buildCarDetailsForm() {
    return Builder(
      builder: (context) {
        final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

        return Container(
          margin: EdgeInsets.fromLTRB(
            horizontalPadding,
            12,
            horizontalPadding,
            8,
          ),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFCF4),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(
              color: const Color(0xFFE8DEC7),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: kBlack.withValues(alpha: 0.08),
                blurRadius: 14,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Container(
                  padding: const EdgeInsets.fromLTRB(16, 18, 16, 16),
                  decoration: const BoxDecoration(color: Color(0xFFF6EFCF)),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Car Details',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: kBlack,
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        'Keep these details accurate so verification is smooth.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 1.3,
                          color: Color(0xFF2B2414),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _InfoField(
                        controller: carTypeController,
                        label: 'Car Type',
                        hint: 'Sedan, SUV, van...',
                        icon: Icons.directions_car_outlined,
                      ),
                      const SizedBox(height: 12),
                      _InfoField(
                        controller: numberPlateController,
                        label: 'Number Plate',
                        hint: 'ABC 1234',
                        icon: Icons.confirmation_number_outlined,
                      ),
                      const SizedBox(height: 12),
                      _InfoField(
                        controller: carModelController,
                        label: 'Car Model',
                        hint: 'Toyota Axio, Honda Fit...',
                        icon: Icons.view_in_ar_outlined,
                      ),
                      const SizedBox(height: 12),
                      _InfoField(
                        controller: carColorController,
                        label: 'Car Color',
                        hint: 'White, silver, black...',
                        icon: Icons.color_lens_outlined,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget imageCard({
    required String title,
    required String subtitle,
    required IconData icon,
    required File? image,
    required VoidCallback onPick,
    bool isSelfie = false,
    bool optional = false,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: kWhite,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: kYellow.withValues(alpha: 0.32), width: 1.1),
        boxShadow: [
          BoxShadow(
            color: kBlack.withValues(alpha: 0.08),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Material(
        color: kWhite,
        child: InkWell(
          onTap: onPick,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      kYellow.withValues(alpha: 0.24),
                      kYellow.withValues(alpha: 0.08),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 18,
                      backgroundColor: Color(0xFFF6EFCF),
                      child: Icon(icon, size: 18, color: kBlack),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            title,
                            style: const TextStyle(
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              color: kBlack,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            subtitle,
                            style: TextStyle(
                              fontSize: 11,
                              color: kBlack.withValues(alpha: 0.68),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (optional)
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: kYellow.withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: const Text(
                          'Optional',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: kBlack,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              AspectRatio(
                aspectRatio: 1.08,
                child: Container(
                  color: const Color(0xFFFFFCF4),
                  child: image == null
                      ? Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: kYellow.withValues(alpha: 0.18),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.cloud_upload_outlined,
                                size: 28,
                                color: kBlack,
                              ),
                            ),
                            const SizedBox(height: 10),
                            const Text(
                              'Tap to upload',
                              style: TextStyle(
                                fontWeight: FontWeight.w700,
                                color: kBlack,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              isSelfie
                                  ? 'Use camera or gallery'
                                  : 'Gallery image',
                              style: TextStyle(
                                fontSize: 11,
                                color: kBlack.withValues(alpha: 0.62),
                              ),
                            ),
                          ],
                        )
                      : Stack(
                          fit: StackFit.expand,
                          children: [
                            Image.file(image, fit: BoxFit.cover),
                            Positioned(
                              right: 10,
                              top: 10,
                              child: Container(
                                padding: const EdgeInsets.all(6),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFFFFCF4),
                                  shape: BoxShape.circle,
                                  border: Border.all(
                                    color: const Color(0xFFE8DEC7),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.check,
                                  size: 16,
                                  color: kBlack,
                                ),
                              ),
                            ),
                          ],
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildUploadGrid(List<Widget> cards) {
    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      childAspectRatio: 0.68,
      children: cards,
    );
  }

  bool validateAll() {
    return carTypeController.text.isNotEmpty &&
        numberPlateController.text.isNotEmpty &&
        carModelController.text.isNotEmpty &&
        carColorController.text.isNotEmpty &&
        idFront != null &&
        idBack != null &&
        selfie != null &&
        driverLicense != null &&
        insurance != null &&
        logBook != null &&
        carFront != null &&
        carBack != null &&
        interiorFront != null &&
        interiorBack != null;
  }

  // ---------------- SUBMIT ----------------

  Future<void> submit() async {
    if (!validateAll()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Please complete all required fields")),
      );
      return;
    }

    setState(() => loading = true);

    await Future.delayed(const Duration(seconds: 2));

    setState(() => loading = false);

    if (!mounted) return;

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text("Submitted successfully")));

    Navigator.pop(context);
  }

  // ---------------- UI ----------------

  @override
  Widget build(BuildContext context) {
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: kBeige,
      appBar: AppBar(
        backgroundColor: kBeige,
        title: const Text("Verification"),
        foregroundColor: kBlack,
        elevation: 0,
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        children: [
          buildCarDetailsForm(),

          const Padding(
            padding: EdgeInsets.fromLTRB(12, 14, 12, 8),
            child: Text(
              "Documents",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: kBlack,
                letterSpacing: 0.2,
              ),
            ),
          ),

          _buildUploadGrid([
            imageCard(
              title: "ID Front",
              subtitle: "Upload front ID",
              icon: Icons.credit_card,
              image: idFront,
              onPick: () => pickImage((f) => setState(() => idFront = f)),
            ),
            imageCard(
              title: "ID Back",
              subtitle: "Upload back ID",
              icon: Icons.credit_card,
              image: idBack,
              onPick: () => pickImage((f) => setState(() => idBack = f)),
            ),
            imageCard(
              title: "Selfie",
              subtitle: "Take selfie",
              icon: Icons.person,
              image: selfie,
              onPick: () => takeSelfie((f) => setState(() => selfie = f)),
            ),
            imageCard(
              title: "Driver License",
              subtitle: "Upload license",
              icon: Icons.badge,
              image: driverLicense,
              onPick: () =>
                  pickImage((f) => setState(() => driverLicense = f)),
            ),
            imageCard(
              title: "Insurance",
              subtitle: "Upload insurance",
              icon: Icons.shield,
              image: insurance,
              onPick: () => pickImage((f) => setState(() => insurance = f)),
            ),
            imageCard(
              title: "Logbook",
              subtitle: "Vehicle logbook",
              icon: Icons.menu_book,
              image: logBook,
              onPick: () => pickImage((f) => setState(() => logBook = f)),
            ),
          ]),

          const Padding(
            padding: EdgeInsets.fromLTRB(12, 14, 12, 8),
            child: Text(
              "Car Images",
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: kBlack,
                letterSpacing: 0.2,
              ),
            ),
          ),

          _buildUploadGrid([
            imageCard(
              title: "Car Front",
              subtitle: "Front view",
              icon: Icons.directions_car,
              image: carFront,
              onPick: () => pickImage((f) => setState(() => carFront = f)),
            ),
            imageCard(
              title: "Car Back",
              subtitle: "Rear view",
              icon: Icons.directions_car,
              image: carBack,
              onPick: () => pickImage((f) => setState(() => carBack = f)),
            ),
            imageCard(
              title: "Interior Front",
              subtitle: "Front seats",
              icon: Icons.event_seat,
              image: interiorFront,
              onPick: () =>
                  pickImage((f) => setState(() => interiorFront = f)),
            ),
            imageCard(
              title: "Interior Back",
              subtitle: "Back seats",
              icon: Icons.event_seat,
              image: interiorBack,
              onPick: () =>
                  pickImage((f) => setState(() => interiorBack = f)),
            ),
          ]),

          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              onPressed: loading ? null : submit,
              style: ElevatedButton.styleFrom(
                backgroundColor: kYellow,
                foregroundColor: kBlack,
                minimumSize: const Size(double.infinity, 50),
              ),
              child: loading
                  ? const CircularProgressIndicator()
                  : const Text("Submit"),
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoField extends StatelessWidget {
  const _InfoField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: controller,
      style: const TextStyle(color: kBlack, fontWeight: FontWeight.w500),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon, color: const Color(0xFF6E5B2D)),
        filled: true,
        fillColor: kWhite,
        labelStyle: TextStyle(color: kBlack.withValues(alpha: 0.8)),
        hintStyle: TextStyle(color: kBlack.withValues(alpha: 0.45)),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE3D7BB)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE3D7BB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFD9B44A), width: 1.6),
        ),
      ),
    );
  }
}
