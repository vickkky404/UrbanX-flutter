import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;
  final String? address;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
    this.address,
  });
}

class LocationData {
  final String name;
  final String address;
  final LatLng coordinates;
  final String placeId;

  LocationData({
    required this.name,
    required this.address,
    required this.coordinates,
    required this.placeId,
  });
}

final userLocationProvider = FutureProvider<UserLocation?>((ref) async {
  try {
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return null;
    }

    final position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    return UserLocation(
      latitude: position.latitude,
      longitude: position.longitude,
      timestamp: DateTime.now(),
    );
  } catch (e) {
    return null;
  }
});

// Stream provider for continuous location updates
final userLocationStreamProvider = StreamProvider<UserLocation>((ref) async* {
  try {
    final permission = await Geolocator.checkPermission();
    
    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      return;
    }

    await for (final position in Geolocator.getPositionStream()) {
      yield UserLocation(
        latitude: position.latitude,
        longitude: position.longitude,
        timestamp: DateTime.now(),
      );
    }
  } catch (e) {
    // Handle error
  }
});

// Selected pickup location
final selectedPickupLocationProvider = StateProvider<LocationData?>((ref) {
  return null;
});

// Selected dropoff location
final selectedDropoffLocationProvider = StateProvider<LocationData?>((ref) {
  return null;
});

// Recent locations
final recentLocationsProvider = StateProvider<List<LocationData>>((ref) {
  return [
    LocationData(
      name: 'Home',
      address: '123 Main Street, Downtown',
      coordinates: const LatLng(28.7041, 77.1025),
      placeId: 'home_001',
    ),
    LocationData(
      name: 'Office',
      address: '456 Business Avenue, Tech Park',
      coordinates: const LatLng(28.6139, 77.2090),
      placeId: 'office_001',
    ),
    LocationData(
      name: 'Airport',
      address: 'Indira Gandhi International Airport',
      coordinates: const LatLng(28.5595, 77.1000),
      placeId: 'airport_001',
    ),
  ];
});
