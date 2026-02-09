import 'package:flutter/material.dart';
import '../models/forecast.dart';
import '../utils/weather_utils.dart';

class DailyForecastCard extends StatelessWidget {
  final Forecast forecast;
  final bool isCelsius;

  const DailyForecastCard({
    required this.forecast,
    required this.isCelsius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.2),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              WeatherUtils.formatDate(forecast.dateTime),
              style: TextStyle(color: Colors.white, fontSize: 14),
            ),
          ),
          Icon(
            WeatherUtils.getWeatherIcon(forecast.condition),
            color: Colors.white,
            size: 24,
          ),
          SizedBox(width: 16),
          Text(
            '${forecast.pop}%',
            style: TextStyle(color: Colors.white70, fontSize: 12),
          ),
          SizedBox(width: 16),
          Text(
            isCelsius
                ? '${forecast.tempMax.round()}° / ${forecast.tempMin.round()}°'
                : '${((forecast.tempMax * 9 / 5) + 32).round()}° / ${((forecast.tempMin * 9 / 5) + 32).round()}°',
            style: TextStyle(
              color: Colors.white,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
