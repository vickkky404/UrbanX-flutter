    # Promo Code Feature - Quick Reference

## What Was Implemented

A complete **Promo Code/Discount System** for UrbanX with:
- Promo code validation and application
- Percentage and flat-amount discounts
- Real-time fare calculation with discounts
- Visual feedback and available offers display
- Mock promo codes ready for backend integration

## Files Created

1. **`lib/features/dashboard/models/promo_model.dart`**
   - `PromoCode` class with full promo management
   - `PromoType` enum
   - Discount calculation logic
   - Validation result handling

2. **`lib/features/dashboard/providers/promo_provider.dart`**
   - State providers for promo input and applied codes
   - Promo validation logic
   - Available promos fetcher (mock data)
   - Apply/clear promo methods

## Files Updated

1. **`lib/features/dashboard/screens/home_screen_v2.dart`**
   - Added promo code imports
   - Added `_buildPromoCodeSection()` widget
   - Updated `_buildRideTypeOptions()` to pass promo
   - Updated `_buildRideCard()` to show discounted prices
   - Integrated promo UI in ride options sheet

## Features

### UI Components
- ✅ Promo code input field with validation button
- ✅ Quick-select chips for available offers
- ✅ Success indicator with applied promo details
- ✅ Remove/clear promo button
- ✅ Real-time price updates with discounts
- ✅ Strikethrough original price display
- ✅ Green savings badge

### Business Logic
- ✅ Percentage discount support (0-100%)
- ✅ Flat amount discount support
- ✅ Maximum discount cap
- ✅ Minimum ride value enforcement
- ✅ Expiry date validation
- ✅ Usage limit tracking
- ✅ Active status checking

## Usage in App

```dart
// In any ConsumerWidget:

// Watch applied promo
final appliedPromo = ref.watch(applyPromoCodeProvider);

// Watch promo input
final promoInput = ref.watch(promoCodeInputProvider);

// Apply a promo code
await ref.read(applyPromoCodeProvider.notifier).apply('WELCOME50', 200);

// Clear promo
ref.read(applyPromoCodeProvider.notifier).clear();

// Get available promos
final promos = await ref.read(availablePromoCodesProvider.future);
```

## Mock Promo Codes for Testing

| Code | Type | Discount | Min Ride | Max Discount | Expires |
|------|------|----------|----------|--------------|---------|
| WELCOME50 | % | 50% | ₹200 | ₹150 | 90 days |
| FLAT100 | Flat | ₹100 | ₹300 | ₹100 | 60 days |
| SUMMER30 | % | 30% | ₹150 | ₹200 | 45 days |
| REFER25 | % | 25% | ₹100 | ₹75 | 180 days |

## How to Customize

### Change Available Promos
Edit `lib/features/dashboard/providers/promo_provider.dart`:
```dart
final availablePromoCodesProvider = FutureProvider<List<PromoCode>>((ref) async {
  return [
    PromoCode(
      code: 'YOUR_CODE',
      type: PromoType.percentage,
      discount: 50, // 50%
      // ... other fields
    ),
  ];
});
```

### Connect to Backend
Replace the mock provider with API call:
```dart
final availablePromoCodesProvider = FutureProvider<List<PromoCode>>((ref) async {
  final response = await http.get('/api/promos');
  return response.map((p) => PromoCode.fromJson(p)).toList();
});
```

### Add Promo to Different Screens
Just import and use `promo_provider.dart`:
```dart
import '../providers/promo_provider.dart';

// In your widget:
final appliedPromo = ref.watch(applyPromoCodeProvider);
```

## Next Steps for Production

1. **API Integration**
   - Replace mock data with real backend calls
   - Add promo validation endpoint
   - Store user promo usage history

2. **Enhanced Features**
   - Category-based promos (first ride, weekend, etc.)
   - Seasonal offers
   - Referral tracking
   - Coupon generation
   - Admin dashboard for managing codes

3. **Analytics**
   - Track promo usage rates
   - Monitor conversion metrics
   - Identify popular codes
   - User engagement metrics

4. **Notifications**
   - Push notifications for new promos
   - Email reminders for expiring codes
   - In-app pop-up suggestions

## UI Preview

```
Bottom Sheet:
┌─────────────────────────────┐
│  Apply Promo Code           │
│ ┌────────────────────┐ ┌───┐│
│ │ Enter promo code  │ │Apl││
│ └────────────────────┘ └───┘│
│                             │
│  Available Offers           │
│  [WELCOME50] [FLAT100] ...  │
└─────────────────────────────┘

Ride Cards (with promo applied):
┌────────────────────────────┐
│🚗 UrbanX Go                 │
│   Budget-friendly ride      │
│   8 min • 3.5 km            │
│                             │
│        ₹125 (strikethrough)  │
│        ₹100 (highlighted)    │
│        Save ₹25 (green)      │
└────────────────────────────┘
```

---

**Status**: ✅ Complete and Ready
**Development Type**: Quick & High-Impact Feature
**Business Value**: Revenue Optimization + User Engagement

