import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

// --- IMPORT YOUR SCREENS ---
import 'package:cozzy_cruise/screens/auth_screen.dart';
import 'package:cozzy_cruise/screens/validation_page.dart';
import 'package:cozzy_cruise/screens/homepage.dart';
import 'package:cozzy_cruise/screens/pending_page.dart';
import 'package:cozzy_cruise/screens/earnings.dart';
import 'package:cozzy_cruise/screens/trips.dart';
import 'package:cozzy_cruise/screens/notifications.dart';
import 'package:cozzy_cruise/widgets/emergency.dart';
import 'package:cozzy_cruise/screens/profile.dart';
import 'package:cozzy_cruise/widgets/help.dart';
import 'package:cozzy_cruise/screens/navigation.dart';
import 'package:cozzy_cruise/widgets/support.dart';
import 'package:cozzy_cruise/widgets/share_trip.dart';
import 'package:cozzy_cruise/widgets/personal_information.dart';
import 'package:cozzy_cruise/widgets/vehicle_information.dart';
import 'package:cozzy_cruise/widgets/documents_page.dart';
import 'package:cozzy_cruise/widgets/earnings_wallet_page.dart';
import 'package:cozzy_cruise/widgets/referral_rewards_page.dart';
import 'package:cozzy_cruise/widgets/terms_conditions_page.dart';
import 'package:cozzy_cruise/widgets/privacy_policy_page.dart';

// Keys for navigation
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>(
  debugLabel: 'root',
);

final GoRouter router = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/', // Start at Auth
  debugLogDiagnostics: true, // Useful for debugging in Chrome console
  routes: [
    // 1. TOP-LEVEL ROUTES (No Bottom Nav)
    GoRoute(path: '/', builder: (context, state) => const AuthScreen()),
    GoRoute(
      path: '/validation',
      builder: (context, state) => const ValidationPage(),
    ),
    GoRoute(
      path: '/pending',
      builder: (context, state) => const PendingPage(status: "pending"),
    ),

    // 2. SHELL ROUTE (With Bottom Nav)
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return ScaffoldWithBottomNav(navigationShell: navigationShell);
      },
      branches: [
        // BRANCH: HOME
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => const HomePage(),
            ),
          ],
        ),

        // BRANCH: TRIPS
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/trips',
              builder: (context, state) => const TripsPage(
                timeStamp: '',
                tripID: '',
                pickupLocation: '',
                dropoffLocation: '',
                distance: '',
                statusText: '',
                fare: '',
                duration: '',
                name: '',
                tripStatus: '',
              ),
            ),
          ],
        ),

        // BRANCH: EARNINGS
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/earnings',
              builder: (context, state) => const EarningsPage(
                totalEarnings: '',
                tripFare: '',
                tips: '',
                bonuses: '',
                adjustments: '',
                availableBalance: '',
                nextPayoutDate: '',
              ),
            ),
          ],
        ),

        // BRANCH: PROFILE (Includes sub-pages)
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profile',
              builder: (context, state) => const DriverProfilePage(),
              routes: [
                // Profile detail pages
                GoRoute(
                  path: 'personal-info',
                  builder: (context, state) {
                    final profile = state.extra as Map<String, dynamic>?;
                    return PersonalInformationPage(profile: profile);
                  },
                ),
                GoRoute(
                  path: 'vehicle-info',
                  builder: (context, state) {
                    final vehicle = state.extra as Map<String, dynamic>?;
                    return VehicleInformationPage(vehicle: vehicle);
                  },
                ),
                GoRoute(
                  path: 'documents',
                  builder: (context, state) {
                    final documents = state.extra as Map<String, dynamic>?;
                    return DocumentsPage(documents: documents);
                  },
                ),
                GoRoute(
                  path: 'earnings-wallet',
                  builder: (context, state) {
                    final earnings = state.extra as Map<String, dynamic>?;
                    return EarningsWalletPage(earnings: earnings);
                  },
                ),
                GoRoute(
                  path: 'referral-rewards',
                  builder: (context, state) {
                    final referralData = state.extra as Map<String, dynamic>?;
                    return ReferralRewardsPage(
                      referralData: referralData ?? {},
                    );
                  },
                ),
                GoRoute(
                  path: 'terms',
                  builder: (context, state) => const TermsConditionsPage(),
                ),
                GoRoute(
                  path: 'privacy',
                  builder: (context, state) => const PrivacyPolicyPage(),
                ),
                // Existing routes
                GoRoute(
                  path: 'notifications',
                  builder: (context, state) => const NotificationsPage(),
                ),
                GoRoute(
                  path: 'emergency',
                  builder: (context, state) => const EmergencyScreen(),
                ),
                GoRoute(
                  path: 'help',
                  builder: (context, state) => const HelpScreen(),
                ),
                GoRoute(
                  path: 'support',
                  builder: (context, state) => const SupportScreen(),
                ),
                GoRoute(
                  path: 'share-trip',
                  builder: (context, state) => const ShareTrip(),
                ),
                GoRoute(
                  path: 'navigation',
                  builder: (context, state) => const NavigationScreen(
                    passengerId: 'P001',
                    passengername: 'James Kimani',
                    profileImageUrl: '',
                    pickupLocation: 'Westlands, Nairobi',
                    dropoffLocation: 'CBD, Nairobi',
                    pickupLat: -1.2676,
                    pickupLng: 36.8116,
                    dropoffLat: -1.2833,
                    dropoffLng: 36.8172,
                    fare: 850,
                    paymentMethod: 'M-Pesa',
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
  ],
);

// --- NAVIGATION WRAPPER ---
class ScaffoldWithBottomNav extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const ScaffoldWithBottomNav({required this.navigationShell, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // The navigationShell is the "body" that switches between branches
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: (int index) {
          navigationShell.goBranch(
            index,
            initialLocation: index == navigationShell.currentIndex,
          );
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.car_rental_outlined),
            selectedIcon: Icon(Icons.car_rental),
            label: 'Trips',
          ),
          NavigationDestination(
            icon: Icon(Icons.payments_outlined),
            selectedIcon: Icon(Icons.payments),
            label: 'Earnings',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
