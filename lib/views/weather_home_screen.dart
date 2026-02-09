import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../utils/weather_utils.dart';
import '../widgets/weather_info_card.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/loading_skeleton.dart';
import 'search_screen.dart';

class WeatherHomeScreen extends StatefulWidget {
  @override
  _WeatherHomeScreenState createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().fetchWeatherByLocation();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, child) {
        final weather = viewModel.weather;
        final isDark = viewModel.isDarkMode;
        final gradientColors = weather != null
            ? WeatherUtils.getWeatherGradient(weather.condition, isDark)
            : [Colors.blue.shade400, Colors.blue.shade700];

        return Scaffold(
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: gradientColors,
              ),
            ),
            child: SafeArea(
              child: RefreshIndicator(
                onRefresh: () => viewModel.refresh(),
                color: Colors.white,
                backgroundColor: Colors.blue,
                child: SingleChildScrollView(
                  physics: AlwaysScrollableScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildHeader(context, viewModel),
                        SizedBox(height: 20),
                        if (viewModel.isLoading)
                          Center(child: LoadingSkeleton())
                        else if (viewModel.error != null)
                          _buildError(viewModel)
                        else if (weather != null)
                          _buildWeatherContent(context, viewModel, weather),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WeatherViewModel viewModel) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          icon: Icon(Icons.my_location, color: Colors.white),
          onPressed: () => viewModel.fetchWeatherByLocation(),
        ),
        IconButton(
          icon: Icon(Icons.search, color: Colors.white),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SearchScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildError(WeatherViewModel viewModel) {
    return Center(
      child: Column(
        children: [
          Icon(Icons.error_outline, color: Colors.white, size: 64),
          SizedBox(height: 16),
          Text(
            viewModel.error ?? 'Something went wrong',
            style: TextStyle(color: Colors.white, fontSize: 16),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => viewModel.fetchWeatherByLocation(),
            child: Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _buildWeatherContent(
      BuildContext context, WeatherViewModel viewModel, weather) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Current Weather
        Center(
          child: Column(
            children: [
              Text(
                weather.cityName,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Updated: ${WeatherUtils.formatTime(weather.lastUpdated.millisecondsSinceEpoch ~/ 1000)}',
                style: TextStyle(color: Colors.white70, fontSize: 12),
              ),
              SizedBox(height: 20),
              Icon(
                WeatherUtils.getWeatherIcon(weather.condition),
                color: Colors.white,
                size: 100,
              ),
              SizedBox(height: 16),
              Text(
                viewModel.getTemperature(weather.temperature),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                weather.description.toUpperCase(),
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              SizedBox(height: 8),
              Text(
                'Feels like ${viewModel.getTemperature(weather.feelsLike)}',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextButton(
                    onPressed: viewModel.toggleUnit,
                    child: Text(
                      viewModel.isCelsius ? '°C' : '°F',
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                  Text('|', style: TextStyle(color: Colors.white70)),
                  TextButton(
                    onPressed: viewModel.toggleTheme,
                    child: Icon(
                      viewModel.isDarkMode
                          ? Icons.light_mode
                          : Icons.dark_mode,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        SizedBox(height: 30),

        // Weather Details Grid
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.5,
          children: [
            WeatherInfoCard(
              icon: Icons.water_drop,
              label: 'Humidity',
              value: '${weather.humidity}%',
            ),
            WeatherInfoCard(
              icon: Icons.air,
              label: 'Wind Speed',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            ),
            WeatherInfoCard(
              icon: Icons.compress,
              label: 'Pressure',
              value: '${weather.pressure} hPa',
            ),
            WeatherInfoCard(
              icon: Icons.visibility,
              label: 'Visibility',
              value: '${(weather.visibility / 1000).toStringAsFixed(1)} km',
            ),
            WeatherInfoCard(
              icon: Icons.wb_sunny_outlined,
              label: 'Sunrise',
              value: WeatherUtils.formatTime(weather.sunrise),
            ),
            WeatherInfoCard(
              icon: Icons.nightlight,
              label: 'Sunset',
              value: WeatherUtils.formatTime(weather.sunset),
            ),
          ],
        ),
        SizedBox(height: 30),

        // Hourly Forecast
        if (viewModel.hourlyForecast.isNotEmpty) ...[
          Text(
            'Hourly Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          Container(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: viewModel.hourlyForecast.length,
              itemBuilder: (context, index) {
                return HourlyForecastCard(
                  forecast: viewModel.hourlyForecast[index],
                  isCelsius: viewModel.isCelsius,
                );
              },
            ),
          ),
          SizedBox(height: 30),
        ],

        // Daily Forecast
        if (viewModel.dailyForecast.isNotEmpty) ...[
          Text(
            '7-Day Forecast',
            style: TextStyle(
              color: Colors.white,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 12),
          ListView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            itemCount: viewModel.dailyForecast.length,
            itemBuilder: (context, index) {
              return DailyForecastCard(
                forecast: viewModel.dailyForecast[index],
                isCelsius: viewModel.isCelsius,
              );
            },
          ),
        ],
      ],
    );
  }
}
