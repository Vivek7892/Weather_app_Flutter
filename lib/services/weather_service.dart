import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';
import '../models/daily_outlook.dart';

class WeatherService {
  static const String _apiKey = '8baa38e9a85641d416557d98a80c0d9a';
  static const String _baseUrl = 'https://api.openweathermap.org/data/2.5';

  // Fetch current weather by city name
  Future<Weather> getWeatherByCity(String city) async {
    final url = '$_baseUrl/weather?q=$city&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch current weather by coordinates
  Future<Weather> getWeatherByCoordinates(double lat, double lon) async {
    final url = '$_baseUrl/weather?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      return Weather.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load weather data');
    }
  }

  // Fetch 5-day forecast (3-hour intervals)
  Future<List<Forecast>> getForecast(double lat, double lon) async {
    final url = '$_baseUrl/forecast?lat=$lat&lon=$lon&appid=$_apiKey&units=metric';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> forecastList = data['list'];
      return forecastList.map((item) => Forecast.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load forecast data');
    }
  }

  // Fetch 15-day daily outlook from Open-Meteo
  Future<List<DailyOutlook>> get15DayOutlook(double lat, double lon) async {
    final url =
        'https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&daily=weather_code,temperature_2m_max,temperature_2m_min,precipitation_probability_max&timezone=auto&forecast_days=15';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode != 200) {
      throw Exception('Failed to load 15-day outlook');
    }

    final data = json.decode(response.body) as Map<String, dynamic>;
    final daily = data['daily'] as Map<String, dynamic>;
    final times = (daily['time'] as List).cast<String>();
    final minTemps = (daily['temperature_2m_min'] as List).cast<num>();
    final maxTemps = (daily['temperature_2m_max'] as List).cast<num>();
    final rainProbabilities =
        (daily['precipitation_probability_max'] as List).cast<num>();
    final weatherCodes = (daily['weather_code'] as List).cast<num>();

    final outlook = <DailyOutlook>[];
    for (var i = 0; i < times.length; i++) {
      outlook.add(
        DailyOutlook(
          date: DateTime.parse(times[i]),
          minTemp: minTemps[i].toDouble(),
          maxTemp: maxTemps[i].toDouble(),
          rainProbability: rainProbabilities[i].toInt(),
          condition: _conditionFromWmoCode(weatherCodes[i].toInt()),
        ),
      );
    }
    return outlook;
  }

  // Get city suggestions (using geocoding API)
  Future<List<String>> getCitySuggestions(String query) async {
    if (query.isEmpty) return [];
    final url = 'http://api.openweathermap.org/geo/1.0/direct?q=$query&limit=5&appid=$_apiKey';
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) => '${item['name']}, ${item['country']}').toList();
    }
    return [];
  }

  String _conditionFromWmoCode(int code) {
    if (code == 0) return 'Clear';
    if ([1, 2, 3].contains(code)) return 'Clouds';
    if ([45, 48].contains(code)) return 'Mist';
    if ([51, 53, 55, 56, 57].contains(code)) return 'Drizzle';
    if ([61, 63, 65, 66, 67, 80, 81, 82].contains(code)) return 'Rain';
    if ([71, 73, 75, 77, 85, 86].contains(code)) return 'Snow';
    if ([95, 96, 99].contains(code)) return 'Thunderstorm';
    return 'Clouds';
  }
}
