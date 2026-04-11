enum PromoType { percentage, flat }

class PromoCode {
  final String code;
  final PromoType type;
  final double discount; // percentage (0-100) or flat amount
  final double maxDiscount; // maximum discount amount
  final double minRideValue; // minimum ride value to apply
  final DateTime expiryDate;
  final int maxUses;
  final int usedCount;
  final bool isActive;
  final String? description;

  PromoCode({
    required this.code,
    required this.type,
    required this.discount,
    required this.maxDiscount,
    required this.minRideValue,
    required this.expiryDate,
    required this.maxUses,
    this.usedCount = 0,
    this.isActive = true,
    this.description,
  });

  bool get isValid =>
      isActive &&
      usedCount < maxUses &&
      DateTime.now().isBefore(expiryDate);

  double calculateDiscount(double rideValue) {
    if (rideValue < minRideValue) return 0;

    double discountAmount = 0;
    if (type == PromoType.percentage) {
      discountAmount = (rideValue * discount) / 100;
    } else {
      discountAmount = discount;
    }

    return discountAmount > maxDiscount ? maxDiscount : discountAmount;
  }
}

class PromoValidationResult {
  final bool isValid;
  final String message;
  final double discountAmount;

  PromoValidationResult({
    required this.isValid,
    required this.message,
    this.discountAmount = 0,
  });
}

