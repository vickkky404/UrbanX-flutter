import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../models/ride_model.dart';
import '../providers/ride_provider.dart';

class RideDetailsScreen extends ConsumerStatefulWidget {
  const RideDetailsScreen({super.key});

  @override
  ConsumerState<RideDetailsScreen> createState() => _RideDetailsScreenState();
}

class _RideDetailsScreenState extends ConsumerState<RideDetailsScreen> {
  late TextEditingController _pickupController;
  late TextEditingController _dropoffController;

  @override
  void initState() {
    super.initState();
    _pickupController = TextEditingController(
      text: ref.read(pickupLocationProvider),
    );
    _dropoffController = TextEditingController(
      text: ref.read(dropoffLocationProvider),
    );
  }

  @override
  void dispose() {
    _pickupController.dispose();
    _dropoffController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final ref = this.ref;
    final selectedType = ref.watch(selectedRideTypeProvider);
    final rideInfo = RideTypeInfo.getInfo(selectedType);
    final estimatedFare = ref.watch(estimatedFareProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Locations'),
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Selected ride info
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF6750A4).withValues(alpha: 0.1),
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
                          '${rideInfo.capacity} passengers',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.edit,
                      color: Color(0xFF6750A4),
                    ),
                    onPressed: () {
                      context.pop();
                    },
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Location inputs
            const Text(
              'Locations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),

            // Pickup location
            TextField(
              controller: _pickupController,
              decoration: InputDecoration(
                labelText: 'Pickup Location',
                hintText: 'Enter pickup address',
                prefixIcon: const Icon(Icons.location_on),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                ref.read(pickupLocationProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 12),

            // Swap button
            Center(
              child: Container(
                decoration: BoxDecoration(
                  color: const Color(0xFF6750A4),
                  shape: BoxShape.circle,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.swap_vert,
                    color: Colors.white,
                  ),
                  onPressed: () {
                    final temp = _pickupController.text;
                    _pickupController.text = _dropoffController.text;
                    _dropoffController.text = temp;
                    
                    ref.read(pickupLocationProvider.notifier).state =
                        _pickupController.text;
                    ref.read(dropoffLocationProvider.notifier).state =
                        _dropoffController.text;
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),

            // Dropoff location
            TextField(
              controller: _dropoffController,
              decoration: InputDecoration(
                labelText: 'Dropoff Location',
                hintText: 'Enter dropoff address',
                prefixIcon: const Icon(Icons.location_on_outlined),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: Colors.grey.shade300),
                ),
              ),
              onChanged: (value) {
                ref.read(dropoffLocationProvider.notifier).state = value;
              },
            ),
            const SizedBox(height: 24),

            // Fare estimate
            const Text(
              'Estimated Fare',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            estimatedFare.when(
              data: (fare) => Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade300),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Total Estimate',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '₹${fare.toStringAsFixed(0)}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF6750A4),
                          ),
                        ),
                      ],
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text(
                          'Base: ₹${rideInfo.baseFare.toStringAsFixed(0)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '(${rideInfo.perKmRate}/km + ${rideInfo.perMinRate}/min)',
                          style: TextStyle(
                            fontSize: 10,
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (err, stack) => Text('Error: $err'),
            ),
            const SizedBox(height: 32),

            // Action buttons
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _pickupController.text.isEmpty ||
                        _dropoffController.text.isEmpty
                    ? null
                    : () {
                  ref.read(bookingStepProvider.notifier).state = 2;
                  context.go('/ride-confirmation');
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  backgroundColor: const Color(0xFF6750A4),
                  disabledBackgroundColor: Colors.grey.shade300,
                ),
                child: const Text(
                  'Confirm & Continue',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
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

