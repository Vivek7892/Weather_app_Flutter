import 'package:flutter/material.dart';
import '../models/forecast.dart';
import '../utils/weather_utils.dart';

class HourlyForecastCard extends StatelessWidget {
  final Forecast forecast;
  final bool isCelsius;

  const HourlyForecastCard({
    super.key,
    required this.forecast,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final temp = isCelsius
        ? '${forecast.temperature.round()}°'
        : '${((forecast.temperature * 9 / 5) + 32).round()}°';

    return Container(
      width: 92,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            WeatherUtils.formatHour(forecast.dateTime),
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          Icon(
            WeatherUtils.getWeatherIcon(forecast.condition),
            color: Colors.white,
            size: 28,
          ),
          Text(
            temp,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            '${forecast.pop}% rain',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.75), fontSize: 11),
          ),
        ],
      ),
    );
  }
}
