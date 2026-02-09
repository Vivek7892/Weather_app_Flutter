import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weather.dart';

class StorageService {
  static const String _weatherKey = 'cached_weather';
  static const String _unitKey = 'temperature_unit';
  static const String _themeKey = 'theme_mode';
  static const String _lastCityKey = 'last_city';

  // Save weather data
  Future<void> saveWeather(Weather weather) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_weatherKey, json.encode(weather.toJson()));
  }

  // Get cached weather
  Future<Weather?> getCachedWeather() async {
    final prefs = await SharedPreferences.getInstance();
    final weatherJson = prefs.getString(_weatherKey);
    if (weatherJson != null) {
      return Weather.fromJson(json.decode(weatherJson));
    }
    return null;
  }

  // Save temperature unit (true = Celsius, false = Fahrenheit)
  Future<void> saveUnit(bool isCelsius) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_unitKey, isCelsius);
  }

  // Get temperature unit
  Future<bool> getUnit() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_unitKey) ?? true;
  }

  // Save theme mode (true = dark, false = light)
  Future<void> saveTheme(bool isDark) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_themeKey, isDark);
  }

  // Get theme mode
  Future<bool> getTheme() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_themeKey) ?? false;
  }

  // Save last searched city
  Future<void> saveLastCity(String city) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_lastCityKey, city);
  }

  // Get last searched city
  Future<String?> getLastCity() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_lastCityKey);
  }
}
