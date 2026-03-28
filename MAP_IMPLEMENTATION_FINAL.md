# Map Implementation Guide - UrbanX Ride Sharing App

## Overview
The map functionality has been successfully implemented with an improved user interface using Material Design principles. The implementation includes:

- **Interactive Google Maps integration** with real-time location tracking
- **Draggable bottom sheet** for ride booking with location search
- **Quick location selection** for frequently used destinations (Home, Office, Airport)
- **Estimated fare calculation** based on ride type and distance
- **User-friendly Material UI** with smooth animations
- **Optional login** - Users can view the map and select locations without logging in, but must login to book a ride

## Features Implemented

### 1. Map Display (HomeScreenV2)
- Full-screen Google Map with user's current location
- My Location button with auto-zoom to user position
- Map controls for scrolling, zooming, tilting, and rotating
- Permission handling for location access

### 2. Location Search & Selection
- **Pickup Location**: Select where the ride should pick you up
- **Dropoff Location**: Select your destination
- **Swap Locations**: Quick swap button to reverse pickup and dropoff
- **Quick Locations**: Pre-saved locations (Home, Office, Airport)
- **Location Picker Modal**: Browse and search available locations

### 3. Ride Type Selection
After selecting locations, users can:
- View available ride types (Economy, Comfort, Premium, XL)
- See estimated fare for each ride type
- View estimated time and distance
- Select preferred ride type with one tap

### 4. Authentication Flow
- **Home Screen is open to all** - No login required to view
- **Location selection is optional** - Browse locations without login
- **Ride booking requires login** - Click "Confirm Ride" triggers login if not authenticated
- **Smooth login redirect** - User returns to booking after login

### 5. Material Design UI
- Color scheme: Purple (#6750A4) as primary color
- Smooth shadows and elevation
- Rounded corners and modern card designs
- Responsive layout with DraggableScrollableSheet
- Touch-friendly buttons and interactive elements

## File Structure

```
lib/
├── features/
│   └── dashboard/
│       ├── screens/
│       │   ├── home_screen_v2.dart          # Main map screen (new)
│       │   └── home_screen.dart             # Legacy (kept for reference)
│       ├── services/
│       │   └── map_service.dart             # Map utility functions (new)
│       ├── providers/
│       │   └── location_provider.dart       # Location state management (updated)
│       └── models/
│           └── ride_model.dart              # Ride and RideType models
├── shared/
│   └── widgets/
│       ├── location_search_widget.dart      # Location input widget (new)
│       └── ride_estimation_card.dart        # Ride card widget (new)
└── core/
    └── router/
        └── app_route.dart                   # Updated routing (now uses HomeScreenV2)
```

## Key Components

### HomeScreenV2
Main screen that combines:
- Google Map display
- Draggable bottom sheet for ride selection
- Location permission handling
- User authentication checks

### LocationData & UserLocation Classes
```dart
class LocationData {
  final String name;
  final String address;
  final LatLng coordinates;
  final String placeId;
}
```

### Riverpod Providers
- `selectedPickupLocationProvider` - Currently selected pickup location
- `selectedDropoffLocationProvider` - Currently selected dropoff location
- `recentLocationsProvider` - Pre-saved locations (Home, Office, Airport)
- `userLocationProvider` - User's current location
- `currentUserProvider` - Current authenticated user

## Usage Flow

### For Anonymous Users
1. App launches → HomeScreen displayed
2. User can view the map and see their current location
3. User can click on pickup/dropoff fields to browse locations
4. When clicking "Confirm Ride", they're prompted to login

### For Authenticated Users
1. App launches → HomeScreen displayed
2. User selects pickup location (or quick location)
3. User selects dropoff location
4. System shows estimated fares for different ride types
5. User selects preferred ride type
6. User clicks "Confirm Ride" → Proceeds to booking

## Material UI Features

### Color Scheme
- **Primary**: #6750A4 (Purple)
- **Surface**: White
- **Error**: Red
- **Warnings**: Orange

### Typography
- **Headings**: Bold, 16-18px
- **Body**: Regular, 14-16px
- **Captions**: Regular, 11-12px

### Spacing
- Standard padding: 16-20px
- Card radius: 12px
- Large radius: 24px

## Future Enhancements

1. **Real-time Driver Location**: Show drivers on map as they approach
2. **Polyline Routes**: Display actual route from pickup to dropoff
3. **Places API Integration**: Real location autocomplete search
4. **Multiple Markers**: Show available drivers nearby
5. **Saved Addresses**: Allow users to save custom addresses
6. **Ride History**: Show map of past rides
7. **Promo Codes**: Apply discount codes before booking
8. **In-app Chat**: Chat with driver during ride
9. **Emergency SOS**: Quick emergency button on map

## Testing

To test the map implementation:

1. **Location Permission**: Test with and without location permission
2. **Location Selection**: Try selecting different quick locations
3. **Fare Calculation**: Verify estimated fares update correctly
4. **Authentication**: Test login/logout flow
5. **Navigation**: Test route to other screens (profile, history, etc.)

## Build & Run

```bash
# Get dependencies
flutter pub get

# Analyze for errors
flutter analyze

# Run in debug mode
flutter run

# Build APK
flutter build apk --debug
```

## Important Notes

⚠️ **Android Manifest Permissions**: Ensure `android/app/src/main/AndroidManifest.xml` has:
```xml
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION" />
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION" />
```

⚠️ **Google Maps API Key**: Required in Android and iOS configuration files

⚠️ **Unused Code**: The old `home_screen.dart` is kept for reference but is not used. It contains legacy implementation that has been replaced by `home_screen_v2.dart`.

## Performance Tips

- **Lazy Loading**: Maps only load when screen is visible
- **Location Updates**: Streaming location only while ride booking screen is active
- **Memory Management**: MapController is properly disposed
- **Animation**: Using animateCamera instead of instant camera jumps for smooth experience

