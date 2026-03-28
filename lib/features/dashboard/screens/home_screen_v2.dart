import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import '../../auth/providers/auth_provider.dart';
import '../providers/location_provider.dart';
import '../models/ride_model.dart';

class HomeScreenV2 extends ConsumerStatefulWidget {
  const HomeScreenV2({super.key});

  @override
  ConsumerState<HomeScreenV2> createState() => _HomeScreenV2State();
}

class _HomeScreenV2State extends ConsumerState<HomeScreenV2> {
  late GoogleMapController mapController;
  bool _isMapReady = false;
  bool _showLocationError = false;

  @override
  void initState() {
    super.initState();
    _requestLocationPermission();
  }

  Future<void> _requestLocationPermission() async {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      final result = await Geolocator.requestPermission();
      if (result == LocationPermission.denied) {
        setState(() => _showLocationError = true);
      }
    } else if (permission == LocationPermission.deniedForever) {
      setState(() => _showLocationError = true);
    }
  }

  void _onMapCreated(GoogleMapController controller) {
    mapController = controller;
    setState(() => _isMapReady = true);
    _moveToUserLocation();
  }

  Future<void> _moveToUserLocation() async {
    try {
      final position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      if (_isMapReady && mounted) {
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 15,
            ),
          ),
        );
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('UrbanX'),
        elevation: 0,
        backgroundColor: const Color(0xFF6750A4),
        foregroundColor: Colors.white,
        actions: [
          currentUser.when(
            data: (user) {
              if (user != null) {
                return Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.account_circle),
                      onPressed: () => context.push('/profile'),
                    ),
                    IconButton(
                      icon: const Icon(Icons.logout),
                      onPressed: () async {
                        final confirmed = await showDialog<bool>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('Sign Out'),
                            content:
                                const Text('Are you sure you want to sign out?'),
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
                              context.go('/');
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
                );
              }
              return IconButton(
                icon: const Icon(Icons.login),
                onPressed: () => context.push('/login'),
              );
            },
            loading: () => const Padding(
              padding: EdgeInsets.all(16.0),
              child: SizedBox(
                width: 24,
                height: 24,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
            error: (err, _) => IconButton(
              icon: const Icon(Icons.login),
              onPressed: () => context.push('/login'),
            ),
          ),
        ],
      ),
      body: Stack(
        children: [
          // Map
          _buildMap(),

          // Location Error Banner
          if (_showLocationError)
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.orange,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.warning, color: Colors.white),
                    const SizedBox(width: 12),
                    Expanded(
                      child: const Text(
                        'Location permission required to show nearby rides',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),

          // Bottom Sheet with Ride Options
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _buildRideOptionsSheet(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _moveToUserLocation,
        backgroundColor: const Color(0xFF6750A4),
        child: const Icon(Icons.my_location),
      ),
    );
  }

  Widget _buildMap() {
    return GoogleMap(
      onMapCreated: _onMapCreated,
      initialCameraPosition: const CameraPosition(
        target: LatLng(28.7041, 77.1025),
        zoom: 15,
      ),
      myLocationEnabled: true,
      myLocationButtonEnabled: false,
      mapType: MapType.normal,
      scrollGesturesEnabled: true,
      zoomGesturesEnabled: true,
      tiltGesturesEnabled: true,
      rotateGesturesEnabled: true,
    );
  }

  Widget _buildRideOptionsSheet() {
    final currentUser = ref.watch(currentUserProvider);
    final pickupLocation = ref.watch(selectedPickupLocationProvider);
    final dropoffLocation = ref.watch(selectedDropoffLocationProvider);

    return DraggableScrollableSheet(
      initialChildSize: 0.35,
      minChildSize: 0.15,
      maxChildSize: 0.85,
      builder: (context, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Drag Handle
                  Center(
                    child: Container(
                      width: 40,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),

                  // Location Search Section
                  _buildLocationSearchSection(
                    currentUser,
                    pickupLocation,
                    dropoffLocation,
                  ),

                  if (pickupLocation != null && dropoffLocation != null) ...[
                    const SizedBox(height: 24),
                    _buildEstimatedFareSection(),
                    const SizedBox(height: 20),
                    _buildRideOptions(currentUser),
                  ] else ...[
                    const SizedBox(height: 24),
                    _buildQuickLocationsSection(),
                  ],
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildLocationSearchSection(
    AsyncValue currentUser,
    LocationData? pickupLocation,
    LocationData? dropoffLocation,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Pickup Location
        _buildLocationInput(
          placeholder: pickupLocation?.name ?? 'Pickup location',
          icon: Icons.location_on,
          onTap: () {
            _showLocationPicker('pickup', currentUser);
          },
        ),
        const SizedBox(height: 12),

        // Swap Button
        if (pickupLocation != null && dropoffLocation != null)
          Align(
            alignment: Alignment.centerRight,
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  ref.read(selectedPickupLocationProvider.notifier).state =
                      dropoffLocation;
                  ref.read(selectedDropoffLocationProvider.notifier).state =
                      pickupLocation;
                },
                borderRadius: BorderRadius.circular(50),
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6750A4).withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.swap_vert,
                    color: Color(0xFF6750A4),
                  ),
                ),
              ),
            ),
          ),

        const SizedBox(height: 12),

        // Dropoff Location
        _buildLocationInput(
          placeholder: dropoffLocation?.name ?? 'Dropoff location',
          icon: Icons.location_on,
          onTap: () {
            _showLocationPicker('dropoff', currentUser);
          },
        ),
      ],
    );
  }

  Widget _buildLocationInput({
    required String placeholder,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Icon(
                  icon,
                  color: const Color(0xFF6750A4),
                ),
                const SizedBox(width: 12),
                Text(
                  placeholder,
                  style: const TextStyle(
                    fontSize: 16,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildEstimatedFareSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Choose Ride Type',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        _buildRideTypeOptions(),
      ],
    );
  }

  Widget _buildRideTypeOptions() {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildRideCard(
          RideTypeInfo.getInfo(RideType.economy),
          125,
          8,
          3.5,
        ),
        const SizedBox(height: 8),
        _buildRideCard(
          RideTypeInfo.getInfo(RideType.comfort),
          175,
          7,
          3.5,
        ),
        const SizedBox(height: 8),
        _buildRideCard(
          RideTypeInfo.getInfo(RideType.premium),
          225,
          6,
          3.5,
        ),
      ],
    );
  }

  Widget _buildRideCard(
    RideTypeInfo rideInfo,
    double estimatedFare,
    int estimatedTime,
    double distance,
  ) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(
          color: Colors.grey[300]!,
          width: 1,
        ),
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
      ),
      child: Row(
        children: [
          // Icon
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFF6750A4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Center(
              child: Text(
                rideInfo.icon,
                style: const TextStyle(fontSize: 32),
              ),
            ),
          ),
          const SizedBox(width: 12),
          // Ride info
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
                const SizedBox(height: 2),
                Text(
                  rideInfo.description,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '$estimatedTime min • ${distance.toStringAsFixed(1)} km',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[500],
                  ),
                ),
              ],
            ),
          ),
          // Price
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${estimatedFare.toStringAsFixed(0)}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF6750A4),
                ),
              ),
              Text(
                'Estimated',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[500],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickLocationsSection() {
    final recentLocations = ref.watch(recentLocationsProvider);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Quick Locations',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
            ),
            if (recentLocations.isNotEmpty)
              TextButton(
                onPressed: () {
                  // Show all locations
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Color(0xFF6750A4),
                    fontSize: 12,
                  ),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        ...recentLocations.take(3).map((location) {
          return _buildQuickLocationTile(location);
        }),
      ],
    );
  }

  Widget _buildQuickLocationTile(LocationData location) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () {
            ref.read(selectedPickupLocationProvider.notifier).state = location;
          },
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 12),
            child: Row(
              children: [
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0xFF6750A4).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    location.name == 'Home'
                        ? Icons.home
                        : location.name == 'Office'
                            ? Icons.work
                            : Icons.flight,
                    color: const Color(0xFF6750A4),
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        location.name,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        location.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRideOptions(AsyncValue currentUser) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: () {
          currentUser.when(
            data: (user) {
              if (user != null) {
                context.push('/ride-type-selection');
              } else {
                _showLoginDialog();
              }
            },
            loading: () {},
            error: (err, _) {
              _showLoginDialog();
            },
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6750A4),
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        child: const Text(
          'Confirm Ride',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  void _showLocationPicker(String type, AsyncValue currentUser) {
    currentUser.when(
      data: (user) {
        if (user == null) {
          _showLoginDialog();
          return;
        }
        showModalBottomSheet(
          context: context,
          builder: (context) => _buildLocationPickerSheet(type),
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          isScrollControlled: true,
        );
      },
      loading: () {},
      error: (err, _) {
        _showLoginDialog();
      },
    );
  }

  Widget _buildLocationPickerSheet(String type) {
    final recentLocations = ref.watch(recentLocationsProvider);

    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            'Select ${type == 'pickup' ? 'Pickup' : 'Dropoff'} Location',
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            decoration: InputDecoration(
              hintText: 'Search locations...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Expanded(
            child: ListView.builder(
              itemCount: recentLocations.length,
              itemBuilder: (context, index) {
                final location = recentLocations[index];
                return ListTile(
                  leading: Icon(
                    location.name == 'Home'
                        ? Icons.home
                        : location.name == 'Office'
                            ? Icons.work
                            : Icons.flight,
                    color: const Color(0xFF6750A4),
                  ),
                  title: Text(location.name),
                  subtitle: Text(location.address),
                  onTap: () {
                    if (type == 'pickup') {
                      ref.read(selectedPickupLocationProvider.notifier).state =
                          location;
                    } else {
                      ref.read(selectedDropoffLocationProvider.notifier).state =
                          location;
                    }
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void _showLoginDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Login Required'),
        content: const Text(
          'You need to log in to book a ride. Would you like to log in now?',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.push('/login');
            },
            child: const Text('Log In'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    mapController.dispose();
    super.dispose();
  }
}

