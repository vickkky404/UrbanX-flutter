# Google Maps Setup Guide

This guide will help you set up Google Maps for the UrbanX Android application.

## Prerequisites

1. A Google Cloud Project
2. Google Maps Platform API enabled
3. An Android API Key

## Steps to Enable Google Maps

### 1. Create or Select a Google Cloud Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Sign in with your Google account
3. Create a new project or select an existing one

### 2. Enable the Maps SDK for Android

1. In the Google Cloud Console, go to **APIs & Services** > **Library**
2. Search for "Maps SDK for Android"
3. Click on it and press **Enable**

### 3. Create an API Key

1. Go to **APIs & Services** > **Credentials**
2. Click **Create Credentials** > **API Key**
3. Your API key will be displayed (keep it safe!)

### 4. Restrict the API Key (Recommended)

1. In the **Credentials** page, find your API key
2. Click on it to edit
3. Under **Application restrictions**, select **Android apps**
4. Add your app's package name and SHA-1 certificate fingerprint

### 5. Get Your SHA-1 Certificate Fingerprint

Run the following command in your project directory:

```bash
./gradlew signingReport
```

or for Windows:

```bash
gradlew.bat signingReport
```

Look for the SHA-1 value in the debug key and add it to your API key restrictions.

### 6. Add the API Key to AndroidManifest.xml

1. Open `android/app/src/main/AndroidManifest.xml`
2. Find the line with `YOUR_GOOGLE_MAPS_API_KEY`
3. Replace it with your actual API key:

```xml
<meta-data
    android:name="com.google.android.geo.API_KEY"
    android:value="YOUR_ACTUAL_API_KEY_HERE" />
```

## Location Permissions

The app requests the following permissions:
- `ACCESS_FINE_LOCATION` - For precise user location
- `ACCESS_COARSE_LOCATION` - For approximate user location
- `INTERNET` - For downloading map tiles

These are already added to `AndroidManifest.xml`. Users will be prompted to grant these permissions when they open the app.

## Testing

Once you've added your API key, run:

```bash
flutter run
```

The app will now display a map on the home screen with the user's location.

## Troubleshooting

### Map not showing?
- Verify your API key is correct
- Check that Maps SDK for Android is enabled in Google Cloud Console
- Ensure location permissions are granted on the device
- Check logcat for error messages: `flutter logs`

### Location not updating?
- Ensure location permission is granted in device settings
- Check device location services are enabled
- Try toggling location permission in app settings

### Build errors?
- Run `flutter clean` and `flutter pub get`
- Ensure you're using Flutter 3.11.1 or higher
- Check that Android SDK 33+ is installed

