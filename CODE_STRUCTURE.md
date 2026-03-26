# Code Structure & Architecture

## Project Structure

```
UrbanX/
├── lib/
│   ├── core/
│   │   ├── router/
│   │   │   └── app_route.dart          [MODIFIED] - Added /home route
│   │   └── theme/
│   │       └── app_theme.dart
│   ├── features/
│   │   ├── auth/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   │   └── auth_provider.dart
│   │   │   ├── screens/
│   │   │   │   ├── login_screen.dart
│   │   │   │   └── signup_screen.dart
│   │   │   └── services/
│   │   │       └── auth_service.dart
│   │   ├── dashboard/
│   │   │   ├── models/
│   │   │   ├── providers/
│   │   │   │   ├── ride_provider.dart
│   │   │   │   └── location_provider.dart     [NEW] - Location tracking
│   │   │   └── screens/
│   │   │       ├── home_screen.dart           [NEW] - Main screen with map
│   │   │       ├── dashboard_screen.dart
│   │   │       ├── ride_type_selection_screen.dart
│   │   │       ├── ride_details_screen.dart
│   │   │       ├── ride_confirmation_screen.dart
│   │   │       ├── active_ride_screen.dart
│   │   │       ├── ride_complete_screen.dart
│   │   │       └── ride_history_screen.dart
│   │   ├── profile/
│   │   │   └── screens/
│   │   │       └── profile_screen.dart
│   │   ├── services/
│   │   └── splash/
│   │       └── screens/
│   │           └── splash_screen.dart         [MODIFIED] - Navigate to /home
│   └── main.dart
├── android/
│   └── app/src/main/
│       └── AndroidManifest.xml                [MODIFIED] - Added permissions & API key
├── pubspec.yaml                               [MODIFIED] - Added map & location packages
└── docs/
    ├── GOOGLE_MAPS_SETUP.md                   [NEW]
    ├── MAP_IMPLEMENTATION.md                  [NEW]
    └── QUICK_START_MAP.md                     [NEW]
```

## Key Classes & Providers

### HomeScreen (`home_screen.dart`)

```dart
class HomeScreen extends ConsumerStatefulWidget {
  // Main entry point for all users (authenticated & unauthenticated)
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  GoogleMapController mapController;
  
  // Key Methods:
  - _requestLocationPermission()    // Request GPS permission
  - _onMapCreated()                 // Initialize map controller
  - _moveToUserLocation()           // Center map on user
  - _buildMap()                     // Create Google Map widget
  - _buildRideOptionsSheet()        // Bottom sheet UI
  - _buildRideTypeGrid()            // Ride type selection grid
  - _buildRideTypeCard()            // Individual ride type card
}
```

### Location Provider (`location_provider.dart`)

```dart
class UserLocation {
  double latitude;
  double longitude;
  DateTime timestamp;
}

// Providers:
final userLocationProvider              // Single location fetch
final userLocationStreamProvider         // Continuous location updates
```

### App Routes (`app_route.dart`)

```dart
GoRouter appRouter = GoRouter(
  initialLocation: '/',  // Splash screen
  routes: [
    '/'                    → SplashScreen
    '/home'       [NEW]    → HomeScreen (main landing screen)
    '/login'               → LoginScreen
    '/signup'              → SignUpScreen
    '/dashboard'           → DashboardScreen
    '/ride-type-selection' → RideTypeSelectionScreen
    '/ride-details'        → RideDetailsScreen
    '/ride-confirmation'   → RideConfirmationScreen
    '/active-ride'         → ActiveRideScreen
    '/ride-complete'       → RideCompleteScreen
    '/ride-history'        → RideHistoryScreen
    '/profile'             → ProfileScreen
  ]
)
```

## Data Flow

### Location Data Flow:
```
Device GPS
    ↓
Geolocator Package
    ↓
location_provider.dart (FutureProvider & StreamProvider)
    ↓
HomeScreen (watches userLocationProvider)
    ↓
GoogleMapController.animateCamera()
    ↓
Map Updates
```

### Authentication Data Flow:
```
Firebase Auth
    ↓
AuthService
    ↓
auth_provider.dart (Providers)
    ├── authStateProvider (Stream)
    ├── currentUserProvider (Future)
    ├── signInProvider
    ├── signUpProvider
    └── signOutProvider
    ↓
HomeScreen (watches currentUserProvider)
    ↓
Conditional UI Rendering
    ├── Unauthenticated → Login button
    └── Authenticated → Profile + Logout buttons
```

### Ride Booking Flow:
```
User clicks "Book a Ride"
    ↓
Check currentUserProvider
    ├─ If null → Show Login Dialog
    │            "Log In" → context.push('/login')
    └─ If user → context.push('/ride-type-selection')
    ↓
Proceed to Ride Details
```

## Widget Tree (HomeScreen)

```
HomeScreen (ConsumerStatefulWidget)
├── Scaffold
    ├── AppBar
    │   ├── Title: "UrbanX"
    │   └── Actions
    │       ├── Login Button (if not authenticated)
    │       ├── Profile Button (if authenticated)
    │       └── Logout Button (if authenticated)
    ├── Body: Stack
    │   ├── GoogleMap
    │   │   ├── User Location Marker
    │   │   ├── Zoom Controls
    │   │   └── Gesture Handlers
    │   ├── Location Error Banner
    │   └── Positioned Bottom Sheet
    │       ├── Drag Handle
    │       ├── "Where to?" TextField
    │       ├── Ride Type Selection Grid
    │       │   ├── Economy Card
    │       │   ├── Premium Card
    │       │   ├── XL Card
    │       │   └── Bike Card
    │       └── "Book a Ride" Button
    └── FloatingActionButton: My Location
```

## Dependencies Added

```yaml
google_maps_flutter: ^2.10.0          # Google Maps rendering
geolocator: ^11.0.0                   # Location services
location: ^6.0.0                      # Additional location utilities
```

### Platform-specific implementations included:
- **Google Maps Android**: google_maps_flutter_android
- **Google Maps iOS**: google_maps_flutter_ios
- **Geolocator Android**: geolocator_android
- **Geolocator iOS**: geolocator_apple
- **Geolocator Web**: geolocator_web
- **Geolocator Windows**: geolocator_windows

## Permissions Structure

### Android Permissions (AndroidManifest.xml):
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
<uses-permission android:name="android.permission.INTERNET" />

<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_GOOGLE_MAPS_API_KEY" />
```

## State Management

### Riverpod Providers Used:

```dart
// Authentication
final authServiceProvider
final authStateProvider
final currentUserProvider
final signUpProvider
final signInProvider
final signOutProvider
final googleSignInProvider

// Location
final userLocationProvider
final userLocationStreamProvider

// Rides
final activeRidesProvider
final rideProvider
```

## Navigation Flow

### Cold Start:
```
main.dart
    ↓
ProviderScope (Riverpod)
    ↓
MaterialApp.router
    ↓
appRouter (initialLocation: '/')
    ↓
SplashScreen (3 seconds)
    ↓
_navigateAway() → context.go('/home')
    ↓
HomeScreen (Main Entry Point)
```

### From HomeScreen:

**Unauthenticated:**
- Login button → `/login`
- Book Ride → Login Dialog → `/login`
- Signup link → `/signup`

**Authenticated:**
- Profile button → `/profile`
- Book Ride → `/ride-type-selection`
- Logout → Back to `/home` (logged out)

## Error Handling

### Location Errors:
- Permission denied → Show warning banner
- Location unavailable → Use default location (Delhi)
- Stream errors → Caught and handled gracefully

### Map Errors:
- API key missing → Map won't render
- No internet → Can't download tiles
- Both handled with error messages in logs

### Authentication Errors:
- Login fails → Error dialog shown
- Signup fails → Error message displayed
- Already handled by existing auth_provider

## Performance Optimizations

1. **Single GoogleMapController** - Reused throughout session
2. **Stream Provider** - Continuous location updates only if needed
3. **Lazy Loading** - Widgets built on demand
4. **Gesture Detection** - Efficient map interaction
5. **Memory Management** - Proper disposal of resources

## Testing Considerations

### Unit Tests (Not included but recommended):
- Location permission logic
- Ride type selection
- Authentication checks
- Route navigation

### Widget Tests (Not included but recommended):
- HomeScreen rendering
- Map display
- AppBar buttons
- Bottom sheet UI

### Integration Tests (Not included but recommended):
- Complete booking flow
- Login → Booking → Payment
- Map interaction
- Location updates

## Extensibility Points

### Future Enhancements:
1. **Markers** - Add driver/rider markers on map
2. **Polylines** - Draw route on map
3. **Place Search** - Autocomplete "Where to?"
4. **Fare Estimation** - Show estimated fare
5. **Multiple Pickup Points** - Allow multiple locations
6. **In-App Chat** - Contact driver
7. **Payment Gateway** - Process payments
8. **Ride Tracking** - Live ride progress

## Code Quality

- ✅ No compilation errors
- ✅ No analysis warnings
- ✅ Proper error handling
- ✅ Efficient state management
- ✅ Clean code architecture
- ✅ Following Flutter best practices

