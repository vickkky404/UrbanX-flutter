import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/ride_provider.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider);
    final activeRides = ref.watch(activeRidesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UrbanX Dashboard'),
        elevation: 0,
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              final confirmed = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Sign Out'),
                  content: const Text('Are you sure you want to sign out?'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel'),
                    ),
                    TextButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Sign Out'),
                    ),
                  ],
                ),
              );

              if (confirmed ?? false) {
                try {
                  await ref.read(signOutProvider.future);
                  if (context.mounted) {
                    context.go('/login');
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: ${e.toString()}')),
                    );
                  }
                }
              }
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Welcome Section
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      Color(0xFF6750A4),
                      Color(0xFF4A3B7D),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Welcome!',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    currentUser.when(
                      data: (user) => Text(
                        user?.displayName ?? 'User',
                        style: const TextStyle(
                          fontSize: 16,
                          color: Colors.white70,
                        ),
                      ),
                      loading: () => const SizedBox(
                        height: 20,
                        width: 100,
                        child: CircularProgressIndicator(
                          valueColor:
                          AlwaysStoppedAnimation(Colors.white),
                          strokeWidth: 2,
                        ),
                      ),
                      error: (err, stack) => const Text(
                        'Error loading user',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),

              // Quick Actions
              const Text(
                'Quick Actions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              GridView.count(
                crossAxisCount: 2,
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                children: [
                  _QuickActionCard(
                    icon: Icons.directions_car,
                    title: 'Book a Ride',
                    onTap: () {
                      ref.read(resetBookingProvider)();
                      context.go('/ride-type-selection');
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.history,
                    title: 'Ride History',
                    onTap: () {
                      context.go('/ride-history');
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.person,
                    title: 'Profile',
                    onTap: () {
                      context.go('/profile');
                    },
                  ),
                  _QuickActionCard(
                    icon: Icons.settings,
                    title: 'Settings',
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Settings coming soon!'),
                        ),
                      );
                    },
                  ),
                ],
              ),
              const SizedBox(height: 32),

              // Active Rides Section
              if (activeRides.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Active Rides',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 16),
                    // Active rides will be displayed here
                  ],
                ),

              // Features Section
              const Text(
                'Features',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 16),
              _FeatureCard(
                icon: Icons.location_on,
                title: 'Location Selection',
                description: 'Enter pickup and dropoff locations',
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.card_travel,
                title: 'Multiple Ride Types',
                description: 'Choose from Economy, Comfort, Premium, and XL',
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.star,
                title: 'Ratings & Reviews',
                description: 'Rate drivers and see their reviews',
              ),
              const SizedBox(height: 12),
              _FeatureCard(
                icon: Icons.map,
                title: 'Live Tracking',
                description: 'Track your ride in real-time (Coming soon)',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _QuickActionCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _QuickActionCard({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.grey.shade100,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.grey.shade200,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 40,
              color: const Color(0xFF6750A4),
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FeatureCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.grey.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
              color: const Color(0xFF6750A4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Icon(
                icon,
                color: const Color(0xFF6750A4),
                size: 24,
              ),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}