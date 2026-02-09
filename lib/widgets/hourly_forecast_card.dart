import 'package:flutter/material.dart';
import '../models/forecast.dart';
import '../utils/weather_utils.dart';

class HourlyForecastCard extends StatelessWidget {
  final Forecast forecast;
  final bool isCelsius;

  const HourlyForecastCard({
    required this.forecast,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      margin: EdgeInsets.only(right: 12),
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            WeatherUtils.formatHour(forecast.dateTime),
            style: TextStyle(color: Colors.white, fontSize: 12),
          ),
          SizedBox(height: 8),
          Icon(
            WeatherUtils.getWeatherIcon(forecast.condition),
            color: Colors.white,
            size: 28,
          ),
          SizedBox(height: 8),
          Text(
            isCelsius
                ? '${forecast.temperature.round()}°'
                : '${((forecast.temperature * 9 / 5) + 32).round()}°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
