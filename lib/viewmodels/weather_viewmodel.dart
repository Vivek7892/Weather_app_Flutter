import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../models/daily_outlook.dart';
import '../models/forecast.dart';
import '../models/weather.dart';
import '../services/location_service.dart';
import '../services/storage_service.dart';
import '../services/weather_service.dart';

class WeatherViewModel extends ChangeNotifier {
  final WeatherService _weatherService = WeatherService();
  final LocationService _locationService = LocationService();
  final StorageService _storageService = StorageService();

  Weather? _weather;
  List<Forecast> _forecasts = [];
  List<DailyOutlook> _fifteenDayOutlook = [];
  List<String> _managedCities = [];
  List<String> _rainAlerts = [];
  final List<String> _notifications = [];
  final Set<String> _deliveredAlerts = {};
  bool _rainAlertsEnabled = true;
  bool _isLoading = false;
  bool _isCelsius = true;
  bool _isDarkMode = false;
  bool _isNight = false;
  String? _error;
  double? _latitude;
  double? _longitude;

  Weather? get weather => _weather;
  List<Forecast> get forecasts => _forecasts;
  List<DailyOutlook> get fifteenDayOutlook => _fifteenDayOutlook;
  List<String> get managedCities => _managedCities;
  List<String> get rainAlerts => _rainAlerts;
  List<String> get notifications => List.unmodifiable(_notifications);
  bool get rainAlertsEnabled => _rainAlertsEnabled;
  bool get isLoading => _isLoading;
  bool get isCelsius => _isCelsius;
  bool get isDarkMode => _isDarkMode;
  bool get isNight => _isNight;
  String? get error => _error;

  List<Forecast> get hourlyForecast => _forecasts.take(8).toList();
  List<DailyOutlook> get weeklyOutlook => _fifteenDayOutlook.take(7).toList();

  WeatherViewModel() {
    _initialize();
  }

  Future<void> _initialize() async {
    _isCelsius = await _storageService.getUnit();
    _isDarkMode = await _storageService.getTheme();
    _rainAlertsEnabled = await _storageService.getRainAlertsEnabled();
    _managedCities = await _storageService.getManagedCities();
    _weather = await _storageService.getCachedWeather();
    if (_weather != null) {
      _latitude = _weather!.latitude;
      _longitude = _weather!.longitude;
      _updateDayNightState(_weather!);
    }
    notifyListeners();
  }

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
      await _fetchByCoordinates(position.latitude, position.longitude);
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchWeatherByCity(String city) async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final normalizedCity = city.split(',').first.trim();
      _weather = await _weatherService.getWeatherByCity(normalizedCity);
      _latitude = _weather!.latitude;
      _longitude = _weather!.longitude;
      _updateDayNightState(_weather!);

      _forecasts = await _weatherService.getForecast(_latitude!, _longitude!);
      _fifteenDayOutlook =
          await _weatherService.get15DayOutlook(_latitude!, _longitude!);
      _updateRainAlerts();

      await _storageService.saveWeather(_weather!);
      await _storageService.saveLastCity(normalizedCity);
      await addManagedCity(normalizedCity, notify: false);
    } catch (_) {
      _error = 'City not found. Try a different name.';
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> _fetchByCoordinates(double lat, double lon) async {
    _latitude = lat;
    _longitude = lon;

    _weather = await _weatherService.getWeatherByCoordinates(lat, lon);
    _updateDayNightState(_weather!);
    _forecasts = await _weatherService.getForecast(lat, lon);
    _fifteenDayOutlook = await _weatherService.get15DayOutlook(lat, lon);
    _updateRainAlerts();

    await _storageService.saveWeather(_weather!);
    await _storageService.saveLastCity(_weather!.cityName);
    await addManagedCity(_weather!.cityName, notify: false);

    _isLoading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    if (_latitude != null && _longitude != null) {
      _isLoading = true;
      notifyListeners();
      try {
        await _fetchByCoordinates(_latitude!, _longitude!);
      } catch (e) {
        _error = e.toString();
        _isLoading = false;
        notifyListeners();
      }
      return;
    }

    final lastCity = await _storageService.getLastCity();
    if (lastCity != null) {
      await fetchWeatherByCity(lastCity);
    } else {
      await fetchWeatherByLocation();
    }
  }

  Future<void> addManagedCity(String city, {bool notify = true}) async {
    final normalized = city.split(',').first.trim();
    if (normalized.isEmpty || _managedCities.contains(normalized)) {
      return;
    }
    _managedCities = [..._managedCities, normalized];
    await _storageService.saveManagedCities(_managedCities);
    if (notify) {
      notifyListeners();
    }
  }

  Future<void> removeManagedCity(String city) async {
    _managedCities = _managedCities.where((c) => c != city).toList();
    await _storageService.saveManagedCities(_managedCities);
    notifyListeners();
  }

  Future<void> toggleRainAlerts(bool enabled) async {
    _rainAlertsEnabled = enabled;
    await _storageService.saveRainAlertsEnabled(enabled);
    notifyListeners();
  }

  void clearNotifications() {
    _notifications.clear();
    notifyListeners();
  }

  void toggleUnit() {
    _isCelsius = !_isCelsius;
    _storageService.saveUnit(_isCelsius);
    notifyListeners();
  }

  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    _storageService.saveTheme(_isDarkMode);
    notifyListeners();
  }

  String getTemperature(double temp) {
    if (_isCelsius) {
      return '${temp.round()}°C';
    }
    return '${((temp * 9 / 5) + 32).round()}°F';
  }

  Future<bool> checkConnectivity() async {
    final connectivityResult = await Connectivity().checkConnectivity();
    return connectivityResult != ConnectivityResult.none;
  }

  void _updateDayNightState(Weather weather) {
    final nowSeconds = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    _isNight = nowSeconds < weather.sunrise || nowSeconds > weather.sunset;
  }

  void _updateRainAlerts() {
    final now = DateTime.now();
    final critical = _forecasts.where((item) {
      final isRainType = item.condition.toLowerCase().contains('rain') ||
          item.condition.toLowerCase().contains('drizzle') ||
          item.condition.toLowerCase().contains('thunderstorm');
      final within24Hours =
          item.dateTime.isAfter(now) && item.dateTime.difference(now).inHours <= 24;
      return within24Hours && (item.pop >= 60 || isRainType);
    }).toList();

    _rainAlerts = critical
        .map(
          (item) =>
              'Rain alert: ${DateFormat('EEE h:mm a').format(item.dateTime)} (${item.pop}% chance)',
        )
        .toList();

    if (!_rainAlertsEnabled) {
      return;
    }

    for (final alert in _rainAlerts) {
      if (_deliveredAlerts.contains(alert)) {
        continue;
      }
      _deliveredAlerts.add(alert);
      _notifications.insert(
        0,
        '${DateFormat('MMM d, h:mm a').format(DateTime.now())}  $alert',
      );
    }
  }
}
