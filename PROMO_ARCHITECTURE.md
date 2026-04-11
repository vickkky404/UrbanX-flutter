# Promo Code Architecture & Data Flow

## System Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                     HOME SCREEN (UI LAYER)                     │
│  ┌──────────────────────────────────────────────────────────┐  │
│  │  Promo Code Input Section                                │  │
│  │  ┌────────────────────┐  ┌─────────────┐               │  │
│  │  │  Text Input Field  │  │ Apply Btn   │               │  │
│  │  └────────────────────┘  └─────────────┘               │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  Available Offers (Quick Select Chips)                   │  │
│  │  [CODE1] [CODE2] [CODE3]                                │  │
│  ├──────────────────────────────────────────────────────────┤  │
│  │  Applied Promo Status                                    │  │
│  │  ✓ CODE_NAME applied - Get 50% off                      │  │
│  └──────────────────────────────────────────────────────────┘  │
└────────────────────┬────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│              STATE MANAGEMENT (RIVERPOD LAYER)                  │
│                                                                 │
│  promoCodeInputProvider ──────┐                                 │
│  (Manages user input)         │                                 │
│                               ▼                                 │
│  applyPromoCodeProvider ◄──── ApplyPromoCodeNotifier            │
│  (Tracks applied promo)       │ (Validation & Application)      │
│                               │                                 │
│  ┌─────────────────────────────┘                                │
│  │                                                              │
│  ▼                                                              │
│  availablePromoCodesProvider                                    │
│  (Fetches available promos)                                     │
│                                                                 │
│  promoValidationProvider                                        │
│  (Validates code for ride value)                               │
└─────────────────────────────────────────────────────────────────┘
                     │
                     ▼
┌─────────────────────────────────────────────────────────────────┐
│               BUSINESS LOGIC (MODEL LAYER)                      │
│                                                                 │
│  PromoCode Class:                                               │
│  ├─ code: String                                                │
│  ├─ type: PromoType (percentage | flat)                         │
│  ├─ discount: double                                            │
│  ├─ maxDiscount: double                                         │
│  ├─ minRideValue: double                                        │
│  ├─ expiryDate: DateTime                                        │
│  ├─ maxUses: int                                                │
│  ├─ usedCount: int                                              │
│  ├─ isActive: bool                                              │
│  ├─ isValid: bool (getter - validates everything)              │
│  └─ calculateDiscount(rideValue) → double                       │
│                                                                 │
│  PromoValidationResult:                                         │
│  ├─ isValid: bool                                               │
│  ├─ message: String                                             │
│  └─ discountAmount: double                                      │
└─────────────────────────────────────────────────────────────────┘
```

## Data Flow Diagram

```
User Action: Enters promo code
       │
       ▼
┌─────────────────────────────┐
│ TextField onChange          │
│ Updates promoCodeInput      │
└──────────┬──────────────────┘
           │
           ▼
    ┌────────────────┐
    │ Enable "Apply" │
    └────────────────┘
           │
           ▼
   User taps "Apply"
           │
           ▼
┌──────────────────────────────────┐
│ ApplyPromoCodeNotifier.apply()    │
│ - Get promo input                │
│ - Read available promos          │
│ - Find matching code             │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Validate Promo:                  │
│ ├─ Code exists?                 │
│ ├─ Is active?                   │
│ ├─ Not expired?                 │
│ ├─ Usage limit ok?              │
│ └─ Meets min ride value?        │
└──────────┬───────────────────────┘
           │
       ┌───┴───┐
       │       │
   Valid   Invalid
       │       │
       ▼       ▼
    ✓ Code   ✗ Show
   Applied   Error
       │       │
       └───┬───┘
           │
           ▼
┌──────────────────────────────────┐
│ Calculate Discount:              │
│ if percentage: (fare * % / 100)  │
│ if flat: flat amount             │
│ cap at maxDiscount               │
└──────────┬───────────────────────┘
           │
           ▼
┌──────────────────────────────────┐
│ Update UI:                       │
│ - Hide input field               │
│ - Show success message           │
│ - Highlight ride cards           │
│ - Update prices with strikethrough│
│ - Show savings amount            │
└──────────────────────────────────┘
```

## Promo Code Validation Flow

```
┌─────────────┐
│ Promo Code  │
│ Submitted   │
└──────┬──────┘
       │
       ▼
   ┌───────────────┐
   │ Code Exists?  │
   └─┬─────────┬───┘
  YES│         │NO
     │         └─────→ ✗ "Invalid code"
     │
     ▼
   ┌──────────────┐
   │ Is Active?   │
   └─┬──────────┬──┘
  YES│          │NO
     │          └─────→ ✗ "Not available"
     │
     ▼
   ┌──────────────┐
   │ Expired?     │
   └─┬──────────┬──┘
  NO │          │YES
     │          └─────→ ✗ "Expired"
     │
     ▼
   ┌──────────────────┐
   │ Usage OK?        │
   │ (usedCount <     │
   │  maxUses)        │
   └─┬──────────┬─────┘
  YES│          │NO
     │          └─────→ ✗ "Limit exceeded"
     │
     ▼
   ┌──────────────────┐
   │ Min Ride Value?  │
   │ (rideValue >=    │
   │  minRideValue)   │
   └─┬──────────┬─────┘
  YES│          │NO
     │          └─────→ ✗ "Min ₹X required"
     │
     ▼
   ┌──────────────┐
   │ ✓ VALID      │
   │ Apply Promo  │
   └──────────────┘
```

## Discount Calculation Logic

```
Input: Ride Value (e.g., ₹200)
       Promo Code (e.g., SUMMER30: 30%, max ₹200)

Step 1: Determine Discount Type
        └─ Type = Percentage

Step 2: Calculate Raw Discount
        └─ 200 * 30 / 100 = ₹60

Step 3: Compare with Max Discount
        └─ 60 ≤ 200? YES
        └─ Use ₹60

Step 4: Calculate Final Price
        └─ Final = 200 - 60 = ₹140

Output: Discount = ₹60
        Final Price = ₹140
        Display: ₹200 (strikethrough) → ₹140 (highlighted)
                 Save ₹60 (green)
```

## File Dependencies

```
home_screen_v2.dart
├── imports promo_provider.dart
├── imports promo_model.dart
└── uses:
    ├── promoCodeInputProvider
    ├── applyPromoCodeProvider
    ├── availablePromoCodesProvider
    └── PromoCode class

promo_provider.dart
├── imports promo_model.dart
└── exports:
    ├── promoCodeInputProvider
    ├── applyPromoCodeProvider
    ├── availablePromoCodesProvider
    ├── promoValidationProvider
    └── ApplyPromoCodeNotifier

promo_model.dart
└── exports:
    ├── PromoType enum
    ├── PromoCode class
    └── PromoValidationResult class
```

## State Flow Diagram

```
Initial State:
┌──────────────┐
│ No Promo     │ ← applyPromoCodeProvider = null
│ Applied      │
└──────────────┘
       │
       ▼ (User enters code & taps Apply)
       
Processing State:
┌──────────────────┐
│ Validating...    │ ← Loading state during validation
│                  │
└──────────────────┘
       │
   ┌───┴───────────┐
   │               │
   ▼ (Valid)       ▼ (Invalid)
   
Promo Applied      Error State
┌──────────────┐   ┌──────────────┐
│ Code: ABC    │   │ Show Error   │
│ Discount: ₹X │   │ Message      │
│ isActive: ✓  │   │ Clear Input  │
└──────────────┘   └──────────────┘
   │                   │
   └───┬───────────────┘
       │
       ▼ (User removes promo or clears)
       
Back to Initial State
```

## Integration Points

```
┌─────────────────────────────────────────────────────────────┐
│                 Other Features Can Use                      │
├─────────────────────────────────────────────────────────────┤
│                                                             │
│ ✓ Ride History Screen                                      │
│   └─ Show applied promo in past rides                      │
│                                                             │
│ ✓ Payment Screen                                           │
│   └─ Apply final discount before payment                   │
│                                                             │
│ ✓ Notifications                                            │
│   └─ Send new promo notifications                          │
│                                                             │
│ ✓ Referral System                                          │
│   └─ Link referral codes with promos                       │
│                                                             │
│ ✓ User Profile                                             │
│   └─ Show saved/used promo codes                           │
│                                                             │
│ ✓ Analytics Dashboard                                      │
│   └─ Track promo usage metrics                             │
│                                                             │
└─────────────────────────────────────────────────────────────┘
```

---

This architecture ensures:
- ✅ Clean separation of concerns
- ✅ Reactive state management
- ✅ Easy testing and maintenance
- ✅ Scalability for new features
- ✅ Type safety throughout

