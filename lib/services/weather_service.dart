import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/weather.dart';
import '../models/forecast.dart';

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
}
