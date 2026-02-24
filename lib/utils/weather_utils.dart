import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeatherUtils {
  static List<Color> getWeatherGradient({
    required String condition,
    required bool isNight,
    required bool isDarkMode,
  }) {
    final normalized = condition.toLowerCase();
    if (isNight || isDarkMode) {
      if (normalized.contains('rain') ||
          normalized.contains('drizzle') ||
          normalized.contains('thunderstorm')) {
        return const [Color(0xFF10233A), Color(0xFF1D3E5A), Color(0xFF2D4F68)];
      }
      if (normalized.contains('clear')) {
        return const [Color(0xFF090E2C), Color(0xFF1F2A5A), Color(0xFF2C3E75)];
      }
      return const [Color(0xFF202B36), Color(0xFF31424F), Color(0xFF435567)];
    }

    if (normalized.contains('rain') ||
        normalized.contains('drizzle') ||
        normalized.contains('thunderstorm')) {
      return const [Color(0xFF4B88B9), Color(0xFF6AA1CB), Color(0xFF8FB8D8)];
    }
    if (normalized.contains('cloud')) {
      return const [Color(0xFF74A5C9), Color(0xFF90B5D3), Color(0xFFAFCADE)];
    }
    return const [Color(0xFF4EA8DE), Color(0xFF79C2EC), Color(0xFFA9DAF5)];
  }

  static IconData getWeatherIcon(String condition) {
    final normalized = condition.toLowerCase();
    if (normalized.contains('clear')) return Icons.wb_sunny;
    if (normalized.contains('cloud')) return Icons.cloud;
    if (normalized.contains('rain')) return Icons.umbrella;
    if (normalized.contains('drizzle')) return Icons.grain;
    if (normalized.contains('thunderstorm')) return Icons.flash_on;
    if (normalized.contains('snow')) return Icons.ac_unit;
    if (normalized.contains('mist') || normalized.contains('fog')) {
      return Icons.cloud_queue;
    }
    return Icons.wb_cloudy;
  }

  static String formatTime(int timestamp) {
    final date = DateTime.fromMillisecondsSinceEpoch(timestamp * 1000);
    return DateFormat('h:mm a').format(date);
  }

  static String formatDate(DateTime date) => DateFormat('EEE, MMM d').format(date);
  static String formatShortDate(DateTime date) => DateFormat('MMM d').format(date);
  static String formatHour(DateTime date) => DateFormat('h a').format(date);

  static String getWindDirection(int degree) {
    if (degree >= 337.5 || degree < 22.5) return 'N';
    if (degree < 67.5) return 'NE';
    if (degree < 112.5) return 'E';
    if (degree < 157.5) return 'SE';
    if (degree < 202.5) return 'S';
    if (degree < 247.5) return 'SW';
    if (degree < 292.5) return 'W';
    return 'NW';
  }
}
