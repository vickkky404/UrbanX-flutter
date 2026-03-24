import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/ride_model.dart';
import '../providers/ride_provider.dart';

class ActiveRideScreen extends ConsumerStatefulWidget {
  const ActiveRideScreen({super.key});

  @override
  ConsumerState<ActiveRideScreen> createState() => _ActiveRideScreenState();
}

class _ActiveRideScreenState extends ConsumerState<ActiveRideScreen> {
  int _statusIndex = 0;

  @override
  void initState() {
    super.initState();
    
    // Simulate status updates
    Future.delayed(const Duration(seconds: 3), () {
      if (mounted) {
        setState(() {
          _statusIndex = 1;
        });
      }
    });

    Future.delayed(const Duration(seconds: 8), () {
      if (mounted) {
        setState(() {
          _statusIndex = 2;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
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
              const Text('No active ride'),
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

    final rideInfo = RideTypeInfo.getInfo(ride.rideType);
    final statuses = [
      RideStatus.pending,
      RideStatus.accepted,
      RideStatus.arriving,
      RideStatus.inProgress,
      RideStatus.completed,
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Ride'),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status tracker
            const Text(
              'Ride Status',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            _StatusTracker(
              statuses: statuses,
              currentIndex: _statusIndex,
            ),
            const SizedBox(height: 24),

            // Driver info (mock)
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
                  const Text(
                    'Driver Info',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Container(
                        width: 60,
                        height: 60,
                        decoration: BoxDecoration(
                          color: const Color(0xFF6750A4).withValues(alpha: 0.2),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: const Center(
                          child: Icon(
                            Icons.person,
                            size: 32,
                            color: Color(0xFF6750A4),
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Ahmed Khan',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Row(
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 14,
                                  color: Color(0xFFFFC107),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '4.8 (245 rides)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: Colors.grey.shade600,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              rideInfo.name,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6750A4),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.call,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.grey.shade200,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: const Icon(
                              Icons.chat_outlined,
                              color: Color(0xFF6750A4),
                              size: 20,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Divider(),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      _InfoBadge(
                        icon: Icons.directions_car,
                        label: 'Vehicle',
                        value: 'ABC-1234',
                      ),
                      _InfoBadge(
                        icon: Icons.timer,
                        label: 'ETA',
                        value: '4 mins',
                      ),
                      _InfoBadge(
                        icon: Icons.location_on,
                        label: 'Distance',
                        value: '2.3 km',
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Ride details
            const Text(
              'Ride Details',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.location_on,
              title: 'Pickup',
              value: ride.pickupLocation,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.location_on_outlined,
              title: 'Dropoff',
              value: ride.dropoffLocation,
            ),
            const SizedBox(height: 12),
            _DetailRow(
              icon: Icons.attach_money,
              title: 'Estimated Fare',
              value: '₹${ride.estimatedFare.toStringAsFixed(0)}',
            ),
            const SizedBox(height: 24),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Simulate ride completion
                  final updatedRide = ride.copyWith(
                    status: RideStatus.completed,
                    completedAt: DateTime.now(),
                    actualFare: 250,
                    distance: 5.2,
                    duration: 15,
                    rating: 5,
                  );
                  ref.read(currentRideProvider.notifier).state = updatedRide;
                  
                  // Add to history
                  final history = ref.read(rideHistoryProvider);
                  ref.read(rideHistoryProvider.notifier).state = [
                    updatedRide,
                    ...history,
                  ];
                  
                  context.go('/ride-complete');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: Colors.green,
                ),
                child: const Text(
                  'Mark Ride as Complete',
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
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('Cancel Ride'),
                      content: const Text(
                          'Are you sure you want to cancel this ride?'),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('No'),
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                            ref.read(currentRideProvider.notifier).state =
                                null;
                            ref.read(resetBookingProvider)();
                            context.go('/dashboard');
                          },
                          child: const Text('Cancel Ride'),
                        ),
                      ],
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  side: const BorderSide(color: Colors.red),
                ),
                child: const Text(
                  'Cancel Ride',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.red,
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

class _StatusTracker extends StatelessWidget {
  final List<RideStatus> statuses;
  final int currentIndex;

  const _StatusTracker({
    required this.statuses,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: List.generate(statuses.length, (index) {
        final status = statuses[index];
        final isCompleted = index < currentIndex;
        final isCurrent = index == currentIndex;

        return Column(
          children: [
            Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: isCompleted || isCurrent
                        ? const Color(0xFF6750A4)
                        : Colors.grey.shade300,
                  ),
                  child: Center(
                    child: isCompleted
                        ? const Icon(
                            Icons.check,
                            color: Colors.white,
                            size: 20,
                          )
                        : Text(
                            '${index + 1}',
                            style: TextStyle(
                              color: isCompleted || isCurrent
                                  ? Colors.white
                                  : Colors.grey.shade600,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getStatusLabel(status),
                        style: TextStyle(
                          fontWeight: isCurrent ? FontWeight.bold : null,
                          fontSize: 14,
                        ),
                      ),
                      if (isCurrent)
                        Text(
                          'In progress...',
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
            if (index < statuses.length - 1)
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: SizedBox(
                  height: 30,
                  child: VerticalDivider(
                    color: isCompleted || isCurrent
                        ? const Color(0xFF6750A4)
                        : Colors.grey.shade300,
                    thickness: 2,
                  ),
                ),
              ),
          ],
        );
      }),
    );
  }

  String _getStatusLabel(RideStatus status) {
    switch (status) {
      case RideStatus.pending:
        return 'Finding Driver';
      case RideStatus.accepted:
        return 'Driver Accepted';
      case RideStatus.arriving:
        return 'Driver Arriving';
      case RideStatus.inProgress:
        return 'Ride in Progress';
      case RideStatus.completed:
        return 'Ride Completed';
      case RideStatus.cancelled:
        return 'Ride Cancelled';
    }
  }
}

class _InfoBadge extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoBadge({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(icon, color: const Color(0xFF6750A4), size: 20),
        const SizedBox(height: 4),
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
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _DetailRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF6750A4), size: 20),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
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

