import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

class UserLocation {
  final double latitude;
  final double longitude;
  final DateTime timestamp;

  UserLocation({
    required this.latitude,
    required this.longitude,
    required this.timestamp,
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

