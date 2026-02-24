# Flutter Weather App

A Flutter weather application with location-based weather, city search, hourly forecast, weekly and 15-day outlook, managed cities, and local persistence.

## Features

- Current weather by GPS location or city search
- City suggestions while searching
- Hourly forecast (next 8 slots)
- 7-day view (from 15-day daily outlook)
- 15-day outlook using Open-Meteo daily data
- Managed cities list (add, remove, quick switch)
- Rain alerts for critical rain windows in the next 24 hours
- In-app notification history for generated rain alerts
- Celsius/Fahrenheit toggle
- Light/Dark theme toggle
- Pull-to-refresh and cached last weather data
- Basic offline fallback from local storage

## Tech Stack

- Flutter (Material 3)
- Provider (state management)
- HTTP (API calls)
- Geolocator + Geocoding
- Shared Preferences (local persistence)
- Connectivity Plus
- Intl
- Shimmer

## Project Structure

```text
lib/
  main.dart
  models/
  services/
  utils/
  viewmodels/
  views/
  widgets/
```

## APIs Used

- OpenWeatherMap
  - Current weather
  - 5-day / 3-hour forecast
  - Geocoding city suggestions
- Open-Meteo
  - 15-day daily outlook

## Setup

1. Install Flutter SDK and platform tools (Android Studio / Xcode as needed).
2. Install dependencies:

```bash
flutter pub get
```

3. Configure API key in `lib/services/weather_service.dart`:

```dart
static const String _apiKey = 'YOUR_OPENWEATHER_API_KEY';
```

4. Run the app:

```bash
flutter run
```

## Platform Notes

- Android/iOS location permission is required for GPS weather.
- iOS builds require macOS and Xcode.

## Common Commands

```bash
flutter analyze
flutter test
flutter clean
```

## Security Note

The API key is currently stored in source code. For production, move secrets to a secure runtime/config approach (for example, build-time defines or secure backend proxy).

## License

For learning and internal project use.
