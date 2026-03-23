enum RideType { economy, comfort, premium, xl }

enum RideStatus { pending, accepted, arriving, inProgress, completed, cancelled }

class RideTypeInfo {
  final RideType type;
  final String name;
  final String description;
  final String icon;
  final double baseFare;
  final double perKmRate;
  final double perMinRate;
  final int capacity;

  RideTypeInfo({
    required this.type,
    required this.name,
    required this.description,
    required this.icon,
    required this.baseFare,
    required this.perKmRate,
    required this.perMinRate,
    required this.capacity,
  });

  static RideTypeInfo getInfo(RideType type) {
    switch (type) {
      case RideType.economy:
        return RideTypeInfo(
          type: RideType.economy,
          name: 'UrbanX Go',
          description: 'Budget-friendly ride',
          icon: '🚗',
          baseFare: 50,
          perKmRate: 15,
          perMinRate: 2,
          capacity: 4,
        );
      case RideType.comfort:
        return RideTypeInfo(
          type: RideType.comfort,
          name: 'UrbanX Comfort',
          description: 'Comfortable ride with extra space',
          icon: '🚙',
          baseFare: 75,
          perKmRate: 20,
          perMinRate: 3,
          capacity: 4,
        );
      case RideType.premium:
        return RideTypeInfo(
          type: RideType.premium,
          name: 'UrbanX Premium',
          description: 'Premium ride with luxury car',
          icon: '🚕',
          baseFare: 100,
          perKmRate: 25,
          perMinRate: 4,
          capacity: 4,
        );
      case RideType.xl:
        return RideTypeInfo(
          type: RideType.xl,
          name: 'UrbanX XL',
          description: 'Large vehicle for groups',
          icon: '🚐',
          baseFare: 120,
          perKmRate: 30,
          perMinRate: 5,
          capacity: 6,
        );
    }
  }
}

class Ride {
  final String id;
  final String userId;
  final String pickupLocation;
  final String dropoffLocation;
  final RideType rideType;
  final RideStatus status;
  final DateTime createdAt;
  final DateTime? completedAt;
  final double estimatedFare;
  final double actualFare;
  final double distance;
  final int duration; // in minutes
  final String? driverName;
  final String? driverPhone;
  final String? vehicleNumber;
  final double rating;

  Ride({
    required this.id,
    required this.userId,
    required this.pickupLocation,
    required this.dropoffLocation,
    required this.rideType,
    required this.status,
    required this.createdAt,
    this.completedAt,
    required this.estimatedFare,
    this.actualFare = 0,
    this.distance = 0,
    this.duration = 0,
    this.driverName,
    this.driverPhone,
    this.vehicleNumber,
    this.rating = 0,
  });

  String getStatusText() {
    switch (status) {
      case RideStatus.pending:
        return 'Waiting for driver...';
      case RideStatus.accepted:
        return 'Driver accepted your ride';
      case RideStatus.arriving:
        return 'Driver is arriving';
      case RideStatus.inProgress:
        return 'Ride in progress';
      case RideStatus.completed:
        return 'Ride completed';
      case RideStatus.cancelled:
        return 'Ride cancelled';
    }
  }

  Ride copyWith({
    String? id,
    String? userId,
    String? pickupLocation,
    String? dropoffLocation,
    RideType? rideType,
    RideStatus? status,
    DateTime? createdAt,
    DateTime? completedAt,
    double? estimatedFare,
    double? actualFare,
    double? distance,
    int? duration,
    String? driverName,
    String? driverPhone,
    String? vehicleNumber,
    double? rating,
  }) {
    return Ride(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      dropoffLocation: dropoffLocation ?? this.dropoffLocation,
      rideType: rideType ?? this.rideType,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      completedAt: completedAt ?? this.completedAt,
      estimatedFare: estimatedFare ?? this.estimatedFare,
      actualFare: actualFare ?? this.actualFare,
      distance: distance ?? this.distance,
      duration: duration ?? this.duration,
      driverName: driverName ?? this.driverName,
      driverPhone: driverPhone ?? this.driverPhone,
      vehicleNumber: vehicleNumber ?? this.vehicleNumber,
      rating: rating ?? this.rating,
    );
  }

  bool get isActive =>
      status == RideStatus.pending ||
      status == RideStatus.accepted ||
      status == RideStatus.arriving ||
      status == RideStatus.inProgress;
}

