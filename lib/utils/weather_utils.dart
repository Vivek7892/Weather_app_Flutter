import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  // Get gradient colors based on weather condition
  static List<Color> getWeatherGradient(String condition, bool isDark) {
    if (isDark) {
      switch (condition.toLowerCase()) {
        case 'clear':
          return [Color(0xFF1a237e), Color(0xFF0d47a1)];
        case 'clouds':
          return [Color(0xFF37474f), Color(0xFF263238)];
        case 'rain':
        case 'drizzle':
          return [Color(0xFF1565c0), Color(0xFF0d47a1)];
        case 'thunderstorm':
          return [Color(0xFF263238), Color(0xFF000000)];
        case 'snow':
          return [Color(0xFF546e7a), Color(0xFF37474f)];
        default:
          return [Color(0xFF1976d2), Color(0xFF1565c0)];
      }
    } else {
      switch (condition.toLowerCase()) {
        case 'clear':
          return [Color(0xFF4fc3f7), Color(0xFF29b6f6)];
        case 'clouds':
          return [Color(0xFF78909c), Color(0xFF546e7a)];
        case 'rain':
        case 'drizzle':
          return [Color(0xFF42a5f5), Color(0xFF1e88e5)];
        case 'thunderstorm':
          return [Color(0xFF546e7a), Color(0xFF37474f)];
        case 'snow':
          return [Color(0xFFb0bec5), Color(0xFF90a4ae)];
        default:
          return [Color(0xFF64b5f6), Color(0xFF42a5f5)];
      }
    }
  }

  // Get weather icon
  static IconData getWeatherIcon(String condition) {
    switch (condition.toLowerCase()) {
      case 'clear':
        return Icons.wb_sunny;
      case 'clouds':
        return Icons.cloud;
      case 'rain':
        return Icons.umbrella;
      case 'drizzle':
        return Icons.grain;
      case 'thunderstorm':
        return Icons.flash_on;
      case 'snow':
        return Icons.ac_unit;
      case 'mist':
      case 'fog':
        return Icons.cloud_queue;
      default:
        return Icons.wb_cloudy;
    }
  }

  // Format time from timestamp
  static String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('h:mm a').format(date);
  }

  // Format date
  static String formatDate(DateTime date) {
    return DateFormat('EEE, MMM d').format(date);
  }

  // Format hour
  static String formatHour(DateTime date) {
    return DateFormat('h a').format(date);
  }

  // Get wind direction
  static String getWindDirection(int degree) {
    if (degree >= 337.5 || degree < 22.5) return 'N';
    if (degree >= 22.5 && degree < 67.5) return 'NE';
    if (degree >= 67.5 && degree < 112.5) return 'E';
    if (degree >= 112.5 && degree < 157.5) return 'SE';
    if (degree >= 157.5 && degree < 202.5) return 'S';
    if (degree >= 202.5 && degree < 247.5) return 'SW';
    if (degree >= 247.5 && degree < 292.5) return 'W';
    return 'NW';
  }
}
