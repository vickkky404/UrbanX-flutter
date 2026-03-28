import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';

class MapService {
  /// Calculate distance between two points
  static double calculateDistance(LatLng start, LatLng end) {
    const p = 0.017453292519943295;
    final a = 0.5 -
        cos((end.latitude - start.latitude) * p) / 2 +
        cos(start.latitude * p) *
            cos(end.latitude * p) *
            (1 - cos((end.longitude - start.longitude) * p)) /
            2;
    return 12742 * asin(sqrt(a));
  }

  /// Get current user position
  static Future<LatLng?> getCurrentLocation() async {
    try {
      final permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        return null;
      }

      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      return LatLng(position.latitude, position.longitude);
    } catch (e) {
      return null;
    }
  }

  /// Create markers for ride
  static Set<Marker> createRideMarkers({
    required LatLng pickupLocation,
    required LatLng dropoffLocation,
    VoidCallback? onPickupTap,
    VoidCallback? onDropoffTap,
  }) {
    return {
      Marker(
        markerId: const MarkerId('pickup'),
        position: pickupLocation,
        infoWindow: const InfoWindow(title: 'Pickup Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueGreen),
        onTap: onPickupTap,
      ),
      Marker(
        markerId: const MarkerId('dropoff'),
        position: dropoffLocation,
        infoWindow: const InfoWindow(title: 'Dropoff Location'),
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueRed),
        onTap: onDropoffTap,
      ),
    };
  }

  /// Generate polyline between two points (simplified)
  static Polyline createPolyline({
    required LatLng start,
    required LatLng end,
  }) {
    return Polyline(
      polylineId: const PolylineId('route'),
      points: [start, end],
      color: const Color(0xFF6750A4),
      width: 5,
      geodesic: true,
    );
  }
}

