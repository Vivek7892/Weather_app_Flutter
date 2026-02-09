// Weather model for current weather data
class Weather {
  final String cityName;
  final double temperature;
  final double feelsLike;
  final String condition;
  final String description;
  final int humidity;
  final double windSpeed;
  final int windDegree;
  final int pressure;
  final int visibility;
  final int sunrise;
  final int sunset;
  final DateTime lastUpdated;

  Weather({
    required this.cityName,
    required this.temperature,
    required this.feelsLike,
    required this.condition,
    required this.description,
    required this.humidity,
    required this.windSpeed,
    required this.windDegree,
    required this.pressure,
    required this.visibility,
    required this.sunrise,
    required this.sunset,
    required this.lastUpdated,
  });

  factory Weather.fromJson(Map<String, dynamic> json) {
    return Weather(
      cityName: json['name'],
      temperature: json['main']['temp'].toDouble(),
      feelsLike: json['main']['feels_like'].toDouble(),
      condition: json['weather'][0]['main'],
      description: json['weather'][0]['description'],
      humidity: json['main']['humidity'],
      windSpeed: json['wind']['speed'].toDouble(),
      windDegree: json['wind']['deg'],
      pressure: json['main']['pressure'],
      visibility: json['visibility'],
      sunrise: json['sys']['sunrise'],
      sunset: json['sys']['sunset'],
      lastUpdated: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'main': {
        'temp': temperature,
        'feels_like': feelsLike,
        'humidity': humidity,
        'pressure': pressure,
      },
      'weather': [
        {'main': condition, 'description': description}
      ],
      'wind': {'speed': windSpeed, 'deg': windDegree},
      'visibility': visibility,
      'sys': {'sunrise': sunrise, 'sunset': sunset},
      'lastUpdated': lastUpdated.toIso8601String(),
    };
  }
}
