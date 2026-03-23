import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/ride_model.dart';
import '../providers/ride_provider.dart';

class RideConfirmationScreen extends ConsumerWidget {
  const RideConfirmationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedType = ref.watch(selectedRideTypeProvider);
    final pickupLocation = ref.watch(pickupLocationProvider);
    final dropoffLocation = ref.watch(dropoffLocationProvider);
    final estimatedFare = ref.watch(estimatedFareProvider);
    final rideInfo = RideTypeInfo.getInfo(selectedType);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Confirm Ride'),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Ride summary card
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey.shade50,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Ride type
                  Row(
                    children: [
                      Text(rideInfo.icon, style: const TextStyle(fontSize: 32)),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              rideInfo.name,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            Text(
                              rideInfo.description,
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
                  const SizedBox(height: 20),
                  const Divider(),
                  const SizedBox(height: 20),

                  // Locations
                  _LocationRow(
                    icon: Icons.location_on,
                    label: 'Pickup',
                    value: pickupLocation,
                  ),
                  const SizedBox(height: 16),
                  _LocationRow(
                    icon: Icons.location_on_outlined,
                    label: 'Dropoff',
                    value: dropoffLocation,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Fare breakdown
            const Text(
              'Fare Breakdown',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            estimatedFare.when(
              data: (fare) => Column(
                children: [
                  _FareItem(
                    label: 'Base Fare',
                    value: '₹${rideInfo.baseFare.toStringAsFixed(0)}',
                  ),
                  _FareItem(
                    label: 'Distance (5 km)',
                    value: '₹${(rideInfo.perKmRate * 5).toStringAsFixed(0)}',
                  ),
                  _FareItem(
                    label: 'Time (15 min)',
                    value: '₹${(rideInfo.perMinRate * 15).toStringAsFixed(0)}',
                  ),
                  const Divider(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Total Amount',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '₹${fare.toStringAsFixed(0)}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 24),

            // Info boxes
            _InfoBox(
              icon: Icons.verified_user,
              title: 'Safety',
              description: 'All drivers are verified and insured',
            ),
            const SizedBox(height: 12),
            _InfoBox(
              icon: Icons.support_agent,
              title: '24/7 Support',
              description: 'Contact us anytime during your ride',
            ),
            const SizedBox(height: 32),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Create a mock active ride
                  final ride = Ride(
                    id: DateTime.now().millisecondsSinceEpoch.toString(),
                    userId: 'user123',
                    pickupLocation: pickupLocation,
                    dropoffLocation: dropoffLocation,
                    rideType: selectedType,
                    status: RideStatus.pending,
                    createdAt: DateTime.now(),
                    estimatedFare: 250,
                  );
                  
                  ref.read(currentRideProvider.notifier).state = ride;
                  ref.read(bookingStepProvider.notifier).state = 3;
                  context.go('/active-ride');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF6750A4),
                ),
                child: const Text(
                  'Confirm Booking',
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
                onPressed: () => context.pop(),
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Color(0xFF6750A4)),
                ),
                child: const Text(
                  'Back',
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
    );
  }
}

class _LocationRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LocationRow({
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
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _FareItem extends StatelessWidget {
  final String label;
  final String value;

  const _FareItem({
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: 14,
              color: Colors.grey.shade700,
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _InfoBox extends StatelessWidget {
  final IconData icon;
  final String title;
  final String description;

  const _InfoBox({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4).withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: const Color(0xFF6750A4).withValues(alpha: 0.2),
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: const Color(0xFF6750A4),
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 11,
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

