import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import '../models/weather.dart';
import '../models/forecast.dart';
import '../services/weather_service.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  Weather? _weather;
  List<Forecast> _forecasts = [];
  bool _isLoading = false;
  String? _error;
  bool _isCelsius = true;
  bool _isDarkMode = false;
  double? _latitude;
  double? _longitude;

  Weather? get weather => _weather;
  List<Forecast> get forecasts => _forecasts;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isCelsius => _isCelsius;
  bool get isDarkMode => _isDarkMode;

  // Get hourly forecast (next 24 hours)
  List<Forecast> get hourlyForecast => _forecasts.take(8).toList();

  // Get daily forecast (7 days)
  List<Forecast> get dailyForecast {
    Map<String, Forecast> dailyMap = {};
    for (var forecast in _forecasts) {
      String date = '${forecast.dateTime.year}-${forecast.dateTime.month}-${forecast.dateTime.day}';
      if (!dailyMap.containsKey(date)) {
        dailyMap[date] = forecast;
      }
    }
    return dailyMap.values.take(7).toList();
  }

  WeatherViewModel() {
    _loadPreferences();
    _loadCachedData();
  }

  // Load user preferences
  Future<void> _loadPreferences() async {
    _isCelsius = await _storageService.getUnit();
    _isDarkMode = await _storageService.getTheme();
    notifyListeners();
  }

  // Load cached weather data
  Future<void> _loadCachedData() async {
    _weather = await _storageService.getCachedWeather();
    if (_weather != null) notifyListeners();
  }

  // Fetch weather by current location
  Future<void> fetchWeatherByLocation() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final position = await _locationService.getCurrentLocation();
      if (position == null) {
        _error = 'Location permission denied';
        _isLoading = false;
        notifyListeners();
        return;
      }

      _latitude = position.latitude;
      _longitude = position.longitude;

      _weather = await _weatherService.getWeatherByCoordinates(
        position.latitude,
        position.longitude,
      );
      _forecasts = await _weatherService.getForecast(
        position.latitude,
        position.longitude,
      );

      await _storageService.saveWeather(_weather!);
      await _storageService.saveLastCity(_weather!.cityName);
    } catch (e) {
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }

  // Fetch weather by city name
  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      _weather = await _weatherService.getWeatherByCity(city);
      
      if (_latitude != null && _longitude != null) {
        _forecasts = await _weatherService.getForecast(_latitude!, _longitude!);
      }

      await _storageService.saveWeather(_weather!);
      await _storageService.saveLastCity(city);
    } catch (e) {
      _error = 'City not found';
    }

    _isLoading = false;
    notifyListeners();
  }

  // Toggle temperature unit
  void toggleUnit() {
    _isCelsius = !_isCelsius;
    _storageService.saveUnit(_isCelsius);
    notifyListeners();
  }

  // Toggle theme
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storageService.saveTheme(_isDarkMode);
    notifyListeners();
  }

  // Refresh weather data
  Future<void> refresh() async {
    if (_latitude != null && _longitude != null) {
      await fetchWeatherByLocation();
    } else {
      final lastCity = await _storageService.getLastCity();
      if (lastCity != null) {
        await fetchWeatherByCity(lastCity);
      }
    }
  }

  // Convert temperature based on unit
  String getTemperature(double temp) {
    if (_isCelsius) {
      return '${temp.round()}°C';
    } else {
      return '${((temp * 9 / 5) + 32).round()}°F';
    }
  }

  // Check internet connectivity
  Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }
}
