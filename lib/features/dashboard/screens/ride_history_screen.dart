import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/ride_model.dart';
import '../providers/ride_provider.dart';

class RideHistoryScreen extends ConsumerWidget {
  const RideHistoryScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final history = ref.watch(rideHistoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ride History'),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: history.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.history,
                    size: 64,
                    color: Colors.grey.shade300,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No rides yet',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => context.go('/dashboard'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6750A4),
                    ),
                    child: const Text('Book Your First Ride'),
                  ),
                ],
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: history.length,
              itemBuilder: (context, index) {
                final ride = history[index];
                return _RideHistoryCard(ride: ride);
              },
            ),
    );
  }
}

class _RideHistoryCard extends StatelessWidget {
  final Ride ride;

  const _RideHistoryCard({required this.ride});

  @override
  Widget build(BuildContext context) {
    final rideInfo = RideTypeInfo.getInfo(ride.rideType);
    final date = ride.createdAt;

    return GestureDetector(
      onTap: () {
        // Show ride details
        showDialog(
          context: context,
          builder: (context) => _RideDetailsDialog(ride: ride),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header with ride type and date
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Text(rideInfo.icon, style: const TextStyle(fontSize: 28)),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          rideInfo.name,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          '${date.day}/${date.month}/${date.year}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '₹${ride.actualFare.toStringAsFixed(0)}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF6750A4),
                      ),
                    ),
                    if (ride.rating > 0)
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.star,
                            size: 12,
                            color: Color(0xFFFFC107),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '${ride.rating}',
                            style: const TextStyle(fontSize: 12),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),

            // Locations
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'From',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ride.pickupLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xFF6750A4).withValues(alpha: 0.1),
                  ),
                  child: const Icon(
                    Icons.arrow_forward,
                    size: 12,
                    color: Color(0xFF6750A4),
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'To',
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.grey.shade600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        ride.dropoffLocation,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        textAlign: TextAlign.end,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Stats row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatBadge(
                  icon: Icons.directions_run,
                  label: '${ride.distance.toStringAsFixed(1)} km',
                ),
                _StatBadge(
                  icon: Icons.timer,
                  label: '${ride.duration} min',
                ),
                _StatBadge(
                  icon: Icons.check_circle,
                  label: ride.getStatusText(),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _StatBadge extends StatelessWidget {
  final IconData icon;
  final String label;

  const _StatBadge({
    required this.icon,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFF6750A4).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: const Color(0xFF6750A4)),
          const SizedBox(width: 4),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: Color(0xFF6750A4),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _RideDetailsDialog extends StatelessWidget {
  final Ride ride;

  const _RideDetailsDialog({required this.ride});

  @override
  Widget build(BuildContext context) {
    final rideInfo = RideTypeInfo.getInfo(ride.rideType);

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Ride Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  GestureDetector(
                    onTap: () => Navigator.pop(context),
                    child: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Ride type
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
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
                              fontSize: 14,
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
              ),
              const SizedBox(height: 16),

              // Locations
              Text(
                'Route',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              _LocationTile(
                icon: Icons.location_on,
                label: 'Pickup',
                value: ride.pickupLocation,
              ),
              const SizedBox(height: 12),
              _LocationTile(
                icon: Icons.location_on_outlined,
                label: 'Dropoff',
                value: ride.dropoffLocation,
              ),
              const SizedBox(height: 16),

              // Trip info
              Text(
                'Trip Information',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade800,
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _InfoTile(
                    icon: Icons.directions_run,
                    label: 'Distance',
                    value: '${ride.distance.toStringAsFixed(1)} km',
                  ),
                  _InfoTile(
                    icon: Icons.timer,
                    label: 'Duration',
                    value: '${ride.duration} min',
                  ),
                  _InfoTile(
                    icon: Icons.attach_money,
                    label: 'Fare',
                    value: '₹${ride.actualFare.toStringAsFixed(0)}',
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Driver info
              if (ride.driverName != null) ...[
                Text(
                  'Driver',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade50,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 50,
                        height: 50,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6750A4).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(25),
                        ),
                        child: const Icon(
                          Icons.person,
                          color: Color(0xFF6750A4),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              ride.driverName!,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            if (ride.vehicleNumber != null)
                              Text(
                                ride.vehicleNumber!,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                          ],
                        ),
                      ),
                      if (ride.rating > 0)
                        Row(
                          children: [
                            const Icon(
                              Icons.star,
                              size: 16,
                              color: Color(0xFFFFC107),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              '${ride.rating}',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
              const SizedBox(height: 20),

              // Close button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6750A4),
                  ),
                  child: const Text('Close'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LocationTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _LocationTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6750A4), size: 18),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey.shade600,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 12,
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          color: const Color(0xFF6750A4),
          size: 20,
        ),
        const SizedBox(height: 4),
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
    );
  }
}

