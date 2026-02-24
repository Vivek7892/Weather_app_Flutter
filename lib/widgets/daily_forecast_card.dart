import 'package:flutter/material.dart';
import '../models/daily_outlook.dart';
import '../utils/weather_utils.dart';

class DailyForecastCard extends StatelessWidget {
  final DailyOutlook forecast;
  final bool isCelsius;

  const DailyForecastCard({
    super.key,
    required this.forecast,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    final high = isCelsius
        ? '${forecast.maxTemp.round()}°'
        : '${((forecast.maxTemp * 9 / 5) + 32).round()}°';
    final low = isCelsius
        ? '${forecast.minTemp.round()}°'
        : '${((forecast.minTemp * 9 / 5) + 32).round()}°';

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              WeatherUtils.formatDate(forecast.date),
              style: const TextStyle(color: Colors.white),
            ),
          ),
          Icon(
            WeatherUtils.getWeatherIcon(forecast.condition),
            color: Colors.white,
          ),
          const SizedBox(width: 8),
          Text(
            '${forecast.rainProbability}%',
            style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
          ),
          const Spacer(),
          Text(
            '$high / $low',
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
