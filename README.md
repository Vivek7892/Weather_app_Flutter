🌤️ Flutter Weather Pro — Production-Ready Weather Application

A modern, scalable weather application built with Flutter & Clean MVVM Architecture that provides real-time weather conditions, location-based forecasts, and intelligent rain alerts.

Designed as a production-grade mobile application focusing on performance, clean architecture, and offline reliability.

🚀 Live Capabilities

This app is not just a UI demo — it behaves like a real Play-Store weather application:

Auto detect user location (GPS)

Search any city worldwide

Hourly + Weekly + 15-day forecast

Offline cached weather data

Rain alert prediction

Managed cities list

Dark/Light theme

Local persistent settings

📱 Key Features
🌍 Location & Search

Automatic weather detection using GPS

Manual city search with suggestions

Reverse geocoding to city name

Quick switching between saved cities

🌦️ Weather Data

Current temperature (°C / °F)

Feels like temperature

Weather condition & description

Dynamic weather icons

Humidity

Wind speed & direction

Atmospheric pressure

Visibility

Sunrise & sunset

📊 Forecasts

Hourly forecast (next 24 hours)

7-day forecast

15-day outlook (Open-Meteo)

Min/Max temperature

Rain probability

🔔 Smart Alerts

Rain alerts for upcoming 24 hours

In-app notification history

Predictive rainfall windows

🎨 User Experience

Material 3 UI

Dynamic gradient backgrounds

Dark / Light mode

Smooth animations

Loading skeletons

Pull-to-refresh

💾 Offline & Persistence

Cached last weather data

Works without internet (fallback mode)

Stores user preferences locally

Managed cities list

🧠 Architecture

This project follows Clean MVVM Architecture.

UI (Views)  →  ViewModel  →  Services  →  APIs / Local Storage
Why MVVM?

Separation of concerns

Testable logic

Scalable structure

Industry best practice for Flutter apps

📁 Project Structure
lib/
│
├── models/              # Data models
│   ├── weather.dart
│   └── forecast.dart
│
├── services/            # API, location, storage
│   ├── weather_service.dart
│   ├── location_service.dart
│   └── storage_service.dart
│
├── viewmodels/          # App state & business logic
│   └── weather_viewmodel.dart
│
├── views/               # Screens
│   ├── weather_home_screen.dart
│   └── search_screen.dart
│
├── widgets/             # Reusable UI components
│   ├── weather_info_card.dart
│   ├── hourly_forecast_card.dart
│   ├── daily_forecast_card.dart
│   └── loading_skeleton.dart
│
├── utils/               # Helpers & formatters
│   └── weather_utils.dart
│
└── main.dart            # Entry point
🛠️ Tech Stack
Category	Technology
Framework	Flutter (Material 3)
Language	Dart
State Management	Provider
API Client	HTTP
Location	Geolocator + Geocoding
Local Storage	SharedPreferences
Network Status	Connectivity Plus
UI Effects	Shimmer
Date Handling	Intl
🌐 APIs Used
OpenWeatherMap

Current Weather

5-day / 3-hour forecast

City geocoding

Open-Meteo

15-day extended forecast

🔧 Installation & Setup
1️⃣ Prerequisites

Flutter SDK (latest stable)

Android Studio or VS Code

Android Emulator or Physical Device

Check installation:

flutter doctor
2️⃣ Clone the Repository
git clone https://github.com/yourusername/flutter-weather-pro.git
cd flutter-weather-pro
3️⃣ Install Dependencies
flutter pub get
4️⃣ Add API Key

Open:

lib/services/weather_service.dart

Replace:

static const String _apiKey = 'YOUR_OPENWEATHER_API_KEY';

Get API key:
https://openweathermap.org/api

5️⃣ Run the Application
flutter run
📦 Important Commands
flutter run
flutter analyze
flutter test
flutter clean
flutter pub get
🔐 Security Notice

Currently, the API key is stored inside the source code.

In production you should:

Use environment variables (--dart-define)

Or call APIs through a secure backend proxy

Example:

flutter run --dart-define=API_KEY=your_key
🧩 Error Handling

The app gracefully handles:

No internet connection

Location disabled

API failure

Invalid city

Timeout responses

📈 What This Project Demonstrates (Important for Recruiters)

This project showcases:

Clean Architecture

State Management

REST API Integration

Location services

Offline caching

Mobile UI/UX design

Error handling

Production-level code structure

🔮 Future Improvements

Weather notifications (background)

AQI (Air Quality Index)

Home screen widgets

Weather maps (radar)

Multiple language support

Push notifications

📜 License

This project is available for learning and portfolio demonstration.

👨‍💻 Author

Vivek V
Computer Science & Data Science Engineer
Flutter • AI • Full-Stack • RAG Chatbots

⭐ If you found this useful, consider giving the repository a star!
