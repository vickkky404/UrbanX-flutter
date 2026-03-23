import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../providers/ride_provider.dart';

class RideCompleteScreen extends ConsumerWidget {
  const RideCompleteScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ride = ref.watch(currentRideProvider);

    if (ride == null) {
      return Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.error_outline,
                size: 48,
                color: Colors.red,
              ),
              const SizedBox(height: 16),
              const Text('No completed ride'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () => context.go('/dashboard'),
                child: const Text('Go to Dashboard'),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Success header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(24),
              decoration: const BoxDecoration(
                color: Color(0xFF6750A4),
              ),
              child: Column(
                children: [
                  const SizedBox(height: 40),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(40),
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.check_circle,
                        size: 60,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Ride Completed!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Thank you for riding with UrbanX',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white.withValues(alpha: 0.8),
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),

            // Ride details
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Trip Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Locations
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _LocationDetail(
                          icon: Icons.location_on,
                          label: 'From',
                          value: ride.pickupLocation,
                        ),
                        const SizedBox(height: 16),
                        _LocationDetail(
                          icon: Icons.location_on_outlined,
                          label: 'To',
                          value: ride.dropoffLocation,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Fare breakdown
                  const Text(
                    'Fare Summary',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      children: [
                        _FareRow(
                          label: 'Subtotal',
                          value: '₹${ride.actualFare.toStringAsFixed(0)}',
                        ),
                        const SizedBox(height: 8),
                        _FareRow(
                          label: 'Taxes',
                          value: '₹0',
                        ),
                        const Divider(height: 16),
                        _FareRow(
                          label: 'Total Amount',
                          value: '₹${ride.actualFare.toStringAsFixed(0)}',
                          isBold: true,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Trip stats
                  const Text(
                    'Trip Stats',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _StatCard(
                          icon: Icons.directions_run,
                          label: 'Distance',
                          value: '${ride.distance.toStringAsFixed(1)} km',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _StatCard(
                          icon: Icons.timer,
                          label: 'Duration',
                          value: '${ride.duration} min',
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // Rating section
                  const Text(
                    'Rate Your Experience',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(
                        5,
                        (index) => GestureDetector(
                          onTap: () {
                            // Rate ride
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text('Thank you for rating!'),
                              ),
                            );
                          },
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Icon(
                              Icons.star,
                              size: 32,
                              color: index < 5
                                  ? const Color(0xFFFFC107)
                                  : Colors.grey.shade300,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Action buttons
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        ref.read(currentRideProvider.notifier).state = null;
                        ref.read(resetBookingProvider)();
                        context.go('/dashboard');
                      },
                      style: ElevatedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        backgroundColor: const Color(0xFF6750A4),
                      ),
                      child: const Text(
                        'Back to Dashboard',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed: () {
                        context.go('/ride-history');
                      },
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        side: const BorderSide(color: Color(0xFF6750A4)),
                      ),
                      child: const Text(
                        'View Ride History',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LocationDetail extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LocationDetail({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6750A4)),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FareRow extends StatelessWidget {
  final String label;
  final String value;
  final bool isBold;

  const _FareRow({
    required this.label,
    required this.value,
    this.isBold = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : null,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: isBold ? 14 : 12,
            fontWeight: isBold ? FontWeight.bold : null,
            color: isBold ? const Color(0xFF6750A4) : null,
          ),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _StatCard({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.grey.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6750A4),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

