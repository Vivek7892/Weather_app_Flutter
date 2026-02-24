// Weather model for current weather data
class Weather {
  final String cityName;
  final double latitude;
  final double longitude;
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
    required this.latitude,
    required this.longitude,
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
    final main = json['main'] as Map<String, dynamic>;
    final weather = (json['weather'] as List).first as Map<String, dynamic>;
    final wind = json['wind'] as Map<String, dynamic>? ?? {};
    final coord = json['coord'] as Map<String, dynamic>? ?? {};
    final sys = json['sys'] as Map<String, dynamic>? ?? {};

    return Weather(
      cityName: json['name'],
      latitude: (coord['lat'] ?? 0).toDouble(),
      longitude: (coord['lon'] ?? 0).toDouble(),
      temperature: (main['temp'] ?? 0).toDouble(),
      feelsLike: (main['feels_like'] ?? 0).toDouble(),
      condition: (weather['main'] ?? 'Unknown').toString(),
      description: (weather['description'] ?? '').toString(),
      humidity: (main['humidity'] ?? 0) as int,
      windSpeed: (wind['speed'] ?? 0).toDouble(),
      windDegree: (wind['deg'] ?? 0) as int,
      pressure: (main['pressure'] ?? 0) as int,
      visibility: (json['visibility'] ?? 0) as int,
      sunrise: (sys['sunrise'] ?? 0) as int,
      sunset: (sys['sunset'] ?? 0) as int,
      lastUpdated: json['lastUpdated'] != null
          ? DateTime.parse(json['lastUpdated'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': cityName,
      'coord': {
        'lat': latitude,
        'lon': longitude,
      },
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
