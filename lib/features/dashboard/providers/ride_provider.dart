import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/ride_model.dart';

// Ride type selection provider
final selectedRideTypeProvider = StateProvider<RideType>((ref) {
  return RideType.economy;
});

// Pickup location provider
final pickupLocationProvider = StateProvider<String>((ref) {
  return '';
});

// Dropoff location provider
final dropoffLocationProvider = StateProvider<String>((ref) {
  return '';
});

// Estimated fare provider
final estimatedFareProvider = FutureProvider<double>((ref) async {
  final rideType = ref.watch(selectedRideTypeProvider);
  
  // Mock calculation - in real app, this would use distance from maps API
  await Future.delayed(const Duration(milliseconds: 500));
  
  final info = RideTypeInfo.getInfo(rideType);
  final estimatedDistance = 5.0; // Mock distance in km
  final estimatedTime = 15; // Mock time in minutes
  
  return info.baseFare + (info.perKmRate * estimatedDistance) + (info.perMinRate * estimatedTime);
});

// Active rides provider (mock data)
final activeRidesProvider = StateProvider<List<Ride>>((ref) {
  return [];
});

// Ride history provider (mock data)
final rideHistoryProvider = StateProvider<List<Ride>>((ref) {
  return [
    Ride(
      id: '1',
      userId: 'user123',
      pickupLocation: 'Downtown Plaza',
      dropoffLocation: 'Airport Terminal 1',
      rideType: RideType.economy,
      status: RideStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      completedAt: DateTime.now().subtract(const Duration(days: 2)),
      estimatedFare: 250,
      actualFare: 250,
      distance: 15.2,
      duration: 28,
      driverName: 'Ahmed Khan',
      vehicleNumber: 'ABC-1234',
      rating: 5,
    ),
    Ride(
      id: '2',
      userId: 'user123',
      pickupLocation: 'Central Station',
      dropoffLocation: 'Shopping Mall',
      rideType: RideType.comfort,
      status: RideStatus.completed,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
      completedAt: DateTime.now().subtract(const Duration(days: 5)),
      estimatedFare: 180,
      actualFare: 185,
      distance: 8.5,
      duration: 18,
      driverName: 'Fatima Ali',
      vehicleNumber: 'XYZ-5678',
      rating: 4.5,
    ),
  ];
});

// Current ride provider
final currentRideProvider = StateProvider<Ride?>((ref) {
  return null;
});

// Booking step provider
final bookingStepProvider = StateProvider<int>((ref) {
  return 0; // 0: Select type, 1: Enter location, 2: Confirm, 3: Active ride
});

// Reset booking provider
final resetBookingProvider = Provider((ref) {
  return () {
    ref.read(selectedRideTypeProvider.notifier).state = RideType.economy;
    ref.read(pickupLocationProvider.notifier).state = '';
    ref.read(dropoffLocationProvider.notifier).state = '';
    ref.read(bookingStepProvider.notifier).state = 0;
  };
});

