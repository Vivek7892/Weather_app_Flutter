# 🌦️ Production-Ready Flutter Weather App

A complete, modern weather application built with Flutter featuring real-time weather data, forecasts, and a beautiful UI.

## ✨ Features

### Core Features
- ✅ Auto-detect current location (GPS)
- ✅ Manual city search with suggestions
- ✅ Last updated time display
- ✅ Pull-to-refresh functionality

### Weather Data (OpenWeatherMap API)
- ✅ Current temperature with °C/°F toggle
- ✅ Feels like temperature
- ✅ Weather condition & description
- ✅ Dynamic weather icons
- ✅ Humidity percentage
- ✅ Wind speed & direction
- ✅ Atmospheric pressure
- ✅ Visibility
- ✅ Sunrise & sunset times

### Forecasts
- ✅ Hourly forecast (next 24 hours)
- ✅ 7-day daily forecast
- ✅ Min & max temperatures
- ✅ Chance of rain (%)

### UI/UX
- ✅ Modern Material Design
- ✅ Dynamic gradient backgrounds based on weather
- ✅ Dark mode & Light mode support
- ✅ Smooth animations
- ✅ Loading skeletons
- ✅ Responsive layout for all screen sizes

### Advanced Features
- ✅ Offline cached weather data
- ✅ Error handling (no internet, API errors)
- ✅ Unit preferences stored locally
- ✅ Clean MVVM architecture
- ✅ Provider state management

## 📁 Project Structure

```
lib/
├── models/              # Data models
│   ├── weather.dart
│   └── forecast.dart
├── services/            # API & business logic
│   ├── weather_service.dart
│   ├── location_service.dart
│   └── storage_service.dart
├── viewmodels/          # State management
│   └── weather_viewmodel.dart
├── views/               # UI screens
│   ├── weather_home_screen.dart
│   └── search_screen.dart
├── widgets/             # Reusable widgets
│   ├── weather_info_card.dart
│   ├── hourly_forecast_card.dart
│   ├── daily_forecast_card.dart
│   └── loading_skeleton.dart
├── utils/               # Helper functions
│   └── weather_utils.dart
└── main.dart            # App entry point
```

## 🚀 Setup Instructions

### Prerequisites
- Flutter SDK (latest stable version)
- Android Studio / VS Code
- OpenWeatherMap API key

### Step 1: Get API Key
1. Visit [OpenWeatherMap](https://openweathermap.org/api)
2. Sign up for a free account
3. Generate an API key
4. Copy your API key

### Step 2: Configure API Key
Open `lib/services/weather_service.dart` and replace the API key:
```dart
static const String _apiKey = 'YOUR_API_KEY_HERE';
```

### Step 3: Install Dependencies
```bash
cd App_
flutter pub get
```

### Step 4: Run the App
```bash
# For Android
flutter run

# For iOS (macOS only)
flutter run -d ios

# For specific device
flutter devices
flutter run -d <device_id>
```

## 📦 Dependencies

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.1.0                    # API calls
  provider: ^6.1.1                # State management
  geolocator: ^10.1.0             # GPS location
  geocoding: ^2.1.1               # Reverse geocoding
  shared_preferences: ^2.2.2      # Local storage
  intl: ^0.18.1                   # Date formatting
  connectivity_plus: ^5.0.2       # Network status
  shimmer: ^3.0.0                 # Loading animations
```

## 🎨 Architecture

This app follows **MVVM (Model-View-ViewModel)** architecture:

- **Models**: Data classes (Weather, Forecast)
- **Views**: UI screens (WeatherHomeScreen, SearchScreen)
- **ViewModels**: Business logic & state (WeatherViewModel)
- **Services**: API calls, location, storage

## 🔧 Key Components

### WeatherViewModel
- Manages app state using Provider
- Handles API calls and data fetching
- Manages user preferences (units, theme)
- Implements caching and error handling

### WeatherService
- Fetches current weather data
- Retrieves hourly & daily forecasts
- Provides city search suggestions

### LocationService
- Requests location permissions
- Gets current GPS coordinates

### StorageService
- Caches weather data offline
- Stores user preferences
- Saves last searched city

## 📱 Features Walkthrough

### 1. Home Screen
- Displays current weather with dynamic background
- Shows detailed weather metrics (humidity, wind, pressure, etc.)
- Hourly forecast carousel
- 7-day forecast list
- Pull-to-refresh support

### 2. Location Detection
- Tap location icon to auto-detect current location
- Requires GPS permission

### 3. City Search
- Tap search icon to open search screen
- Type city name for suggestions
- Select city to view weather

### 4. Settings
- Toggle between °C and °F
- Switch between light and dark mode
- Preferences saved automatically

## 🎯 Best Practices Implemented

✅ Null-safety enabled
✅ Clean code with comments
✅ Reusable widget components
✅ Separation of concerns
✅ Error handling & loading states
✅ Responsive design
✅ Material Design guidelines
✅ Efficient state management

## 🐛 Troubleshooting

### Location not working
- Ensure location permissions are granted
- Enable GPS on device
- Check AndroidManifest.xml has location permissions

### API errors
- Verify API key is correct
- Check internet connection
- Ensure API key is activated (may take a few minutes)

### Build errors
- Run `flutter clean`
- Run `flutter pub get`
- Restart IDE

## 📸 Screenshots

The app features:
- Dynamic gradient backgrounds (Clear, Cloudy, Rainy, etc.)
- Modern card-based UI
- Smooth animations
- Dark/Light mode support

## 🔮 Future Enhancements

- [ ] Weather alerts & notifications
- [ ] Home screen widget
- [ ] Air Quality Index (AQI)
- [ ] Multiple location support
- [ ] Weather maps
- [ ] Historical weather data

## 📄 License

This project is open-source and available for learning purposes.

## 👨‍💻 Developer Notes

Built with ❤️ using Flutter
- Clean architecture
- Production-ready code
- Follows Flutter best practices
- Optimized performance

---

**Note**: Remember to replace the API key with your own before running the app!
