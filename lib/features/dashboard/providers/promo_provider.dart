import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/promo_model.dart';

// Promo code input state
final promoCodeInputProvider =
    StateProvider<String>((ref) => '');

// Applied promo code state
final appliedPromoCodeProvider =
    StateProvider<PromoCode?>((ref) => null);

// Available promo codes (mock data - replace with API call)
final availablePromoCodesProvider = FutureProvider<List<PromoCode>>((ref) async {
  // Mock available promo codes
  return [
    PromoCode(
      code: 'WELCOME50',
      type: PromoType.percentage,
      discount: 50,
      maxDiscount: 150,
      minRideValue: 200,
      expiryDate: DateTime.now().add(const Duration(days: 90)),
      maxUses: 1,
      isActive: true,
      description: 'Get 50% off on your first ride',
    ),
    PromoCode(
      code: 'FLAT100',
      type: PromoType.flat,
      discount: 100,
      maxDiscount: 100,
      minRideValue: 300,
      expiryDate: DateTime.now().add(const Duration(days: 60)),
      maxUses: 5,
      isActive: true,
      description: 'Flat ₹100 off on rides above ₹300',
    ),
    PromoCode(
      code: 'SUMMER30',
      type: PromoType.percentage,
      discount: 30,
      maxDiscount: 200,
      minRideValue: 150,
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      maxUses: 10,
      isActive: true,
      description: 'Summer special - 30% off',
    ),
    PromoCode(
      code: 'REFER25',
      type: PromoType.percentage,
      discount: 25,
      maxDiscount: 75,
      minRideValue: 100,
      expiryDate: DateTime.now().add(const Duration(days: 180)),
      maxUses: 999,
      isActive: true,
      description: 'Referral bonus - 25% off',
    ),
  ];
});

// Provider to validate and apply promo code
final promoValidationProvider =
    FutureProvider.family<PromoValidationResult, double>(
  (ref, rideValue) async {
    final promoInput = ref.watch(promoCodeInputProvider);
    final availablePromos = await ref.watch(availablePromoCodesProvider.future);

    if (promoInput.isEmpty) {
      return PromoValidationResult(
        isValid: false,
        message: 'Enter a promo code',
      );
    }

    final promo = availablePromos.firstWhere(
      (p) => p.code.toUpperCase() == promoInput.toUpperCase(),
      orElse: () => PromoCode(
        code: '',
        type: PromoType.flat,
        discount: 0,
        maxDiscount: 0,
        minRideValue: 0,
        expiryDate: DateTime.now(),
        maxUses: 0,
      ),
    );

    if (promo.code.isEmpty) {
      return PromoValidationResult(
        isValid: false,
        message: 'Invalid promo code',
      );
    }

    if (!promo.isValid) {
      if (promo.usedCount >= promo.maxUses) {
        return PromoValidationResult(
          isValid: false,
          message: 'Promo code usage limit exceeded',
        );
      }
      if (DateTime.now().isAfter(promo.expiryDate)) {
        return PromoValidationResult(
          isValid: false,
          message: 'Promo code has expired',
        );
      }
      return PromoValidationResult(
        isValid: false,
        message: 'Promo code is not available',
      );
    }

    if (rideValue < promo.minRideValue) {
      return PromoValidationResult(
        isValid: false,
        message: 'Minimum ride value of ₹${promo.minRideValue.toStringAsFixed(0)} required',
      );
    }

    final discountAmount = promo.calculateDiscount(rideValue);
    return PromoValidationResult(
      isValid: true,
      message: 'Promo code applied successfully',
      discountAmount: discountAmount,
    );
  },
);

// Provider to apply promo code
final applyPromoCodeProvider =
    StateNotifierProvider<ApplyPromoCodeNotifier, PromoCode?>((ref) {
  return ApplyPromoCodeNotifier(ref);
});

class ApplyPromoCodeNotifier extends StateNotifier<PromoCode?> {
  final Ref ref;

  ApplyPromoCodeNotifier(this.ref) : super(null);

  Future<PromoValidationResult> apply(String code, double rideValue) async {
    final validation =
        await ref.read(promoValidationProvider(rideValue).future);

    if (validation.isValid) {
      final availablePromos =
          await ref.read(availablePromoCodesProvider.future);
      final promo = availablePromos.firstWhere(
        (p) => p.code.toUpperCase() == code.toUpperCase(),
      );
      state = promo;
    } else {
      state = null;
    }

    return validation;
  }

  void clear() {
    state = null;
  }
}

