import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:cozzy_cruise/utils/responsive.dart';

const Color appYellow = Color(0xFFF6C945);
const Color appBeige = Color(0xFFF4E7D3);
const Color appBlack = Color(0xFF111111);

class DriverProfilePage extends StatefulWidget {
  const DriverProfilePage({super.key});

  @override
  State<DriverProfilePage> createState() => _DriverProfilePageState();
}

class _DriverProfilePageState extends State<DriverProfilePage> {
  Map<String, dynamic>? profile;
  Map<String, dynamic>? ratings;
  Map<String, dynamic>? trips;
  Map<String, dynamic>? vehicle;
  Map<String, dynamic>? documents;
  Map<String, dynamic>? earnings;

  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadDashboard();
  }

  Future<void> loadDashboard() async {
    setState(() {
      isLoading = true;
    });

    try {
      final results = await Future.wait([
        fetchProfile(),
        fetchRatings(),
        fetchTrips(),
        fetchVehicle(),
        fetchDocuments(),
        fetchEarnings(),
      ]);

      setState(() {
        profile = results[0];
        ratings = results[1];
        trips = results[2];
        vehicle = results[3];
        documents = results[4];
        earnings = results[5];
        isLoading = false;
      });
    } catch (e) {
      debugPrint("Error loading dashboard: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFFF9F7F3),
      child: SafeArea(
        child: Column(
          children: [
            AppBar(
              title: const Text('Profile'),
              backgroundColor: Colors.white,
              foregroundColor: appBlack,
              elevation: 0,
            ),
            Expanded(
              child: isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : Builder(
                      builder: (context) {
                        final horizontalPadding =
                            ResponsiveUtils.getHorizontalPadding(context);

                        return SingleChildScrollView(
                          padding: EdgeInsets.all(horizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              buildProfileHeader(),
                              const SizedBox(height: 16),
                              buildStats(),
                              const SizedBox(height: 20),
                              buildAccountSection(),
                              const SizedBox(height: 20),
                              buildSupportSection(),
                              const SizedBox(height: 20),
                            ],
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildProfileHeader() {
    final status = profile?["status"] ?? "pending";

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.1), blurRadius: 8),
        ],
      ),
      child: Row(
        children: [
          Stack(
            children: [
              CircleAvatar(
                radius: 35,
                backgroundImage: NetworkImage(profile?["photo"] ?? ""),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 4,
                    vertical: 2,
                  ),
                  decoration: BoxDecoration(
                    color: appYellow,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Text(
                    'Top Rated',
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: appBlack,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  profile?["name"] ?? "Driver",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: appBlack,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    const Icon(Icons.star, size: 16, color: Colors.amber),
                    const SizedBox(width: 4),
                    Text(
                      "${ratings?["avg"] ?? "0.0"}",
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: appBlack,
                      ),
                    ),
                    const SizedBox(width: 12),
                    const Icon(
                      Icons.check_circle,
                      size: 16,
                      color: Colors.green,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status.toUpperCase(),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.green,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStats() {
    return Row(
      children: [
        Expanded(
          child: statBox(
            "Trips",
            trips?["total"]?.toString() ?? "0",
            Icons.route,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: statBox(
            "Joined",
            profile?["joined"] ?? "N/A",
            Icons.calendar_month,
          ),
        ),
      ],
    );
  }

  Widget statBox(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Icon(icon, color: appYellow, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: appBlack,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 4),
          Text(title, style: const TextStyle(color: appBlack, fontSize: 12)),
        ],
      ),
    );
  }

  Widget menuTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.95),
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        leading: Icon(icon, color: appYellow, size: 24),
        title: Text(
          title,
          style: const TextStyle(color: appBlack, fontWeight: FontWeight.w600),
        ),
        trailing: const Icon(Icons.chevron_right, color: appBlack, size: 24),
        onTap: onTap,
      ),
    );
  }

  Widget buildAccountSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Account",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: appBlack,
          ),
        ),
        const SizedBox(height: 12),
        menuTile(
          icon: Icons.person,
          title: "Personal Information",
          onTap: () {
            context.push('/profile/personal-info', extra: profile);
          },
        ),
        menuTile(
          icon: Icons.directions_car,
          title: "Vehicle Information",
          onTap: () {
            context.push('/profile/vehicle-info', extra: vehicle);
          },
        ),
        menuTile(
          icon: Icons.description,
          title: "Documents",
          onTap: () {
            context.push('/profile/documents', extra: documents);
          },
        ),
        menuTile(
          icon: Icons.wallet,
          title: "Earnings & Wallet",
          onTap: () {
            context.push('/profile/earnings-wallet', extra: earnings);
          },
        ),
        menuTile(
          icon: Icons.card_giftcard,
          title: "Referral & Rewards",
          onTap: () {
            context.push(
              '/profile/referral-rewards',
              extra: {
                "code": "KES500",
                "referrals": 3,
                "bonus": 1500,
                "next_reward": "At 5 referrals",
              },
            );
          },
        ),
      ],
    );
  }

  Widget buildSupportSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Support & Legal",
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: appBlack,
          ),
        ),
        const SizedBox(height: 12),
        menuTile(
          icon: Icons.help,
          title: "Help Center",
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Help Center coming soon')),
            );
          },
        ),
        menuTile(
          icon: Icons.description,
          title: "Terms & Conditions",
          onTap: () {
            context.push('/profile/terms');
          },
        ),
        menuTile(
          icon: Icons.privacy_tip,
          title: "Privacy Policy",
          onTap: () {
            context.push('/profile/privacy');
          },
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red.withValues(alpha: 0.1),
              foregroundColor: Colors.red,
              side: const BorderSide(color: Colors.red),
            ),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Logout coming soon')),
              );
            },
            child: const Text(
              "Logout",
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> fetchProfile() async => {};
  Future<Map<String, dynamic>> fetchRatings() async => {};
  Future<Map<String, dynamic>> fetchTrips() async => {};
  Future<Map<String, dynamic>> fetchVehicle() async => {};
  Future<Map<String, dynamic>> fetchDocuments() async => {};
  Future<Map<String, dynamic>> fetchEarnings() async => {};
}
