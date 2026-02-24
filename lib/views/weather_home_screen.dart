import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../utils/weather_utils.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../widgets/daily_forecast_card.dart';
import '../widgets/hourly_forecast_card.dart';
import '../widgets/loading_skeleton.dart';
import '../widgets/weather_info_card.dart';
import 'manage_cities_screen.dart';
import 'search_screen.dart';

class WeatherHomeScreen extends StatefulWidget {
  const WeatherHomeScreen({super.key});

  @override
  State<WeatherHomeScreen> createState() => _WeatherHomeScreenState();
}

class _WeatherHomeScreenState extends State<WeatherHomeScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _backgroundController;

  @override
  void initState() {
    super.initState();
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<WeatherViewModel>().fetchWeatherByLocation();
    });
  }

  @override
  void dispose() {
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, _) {
        final weather = viewModel.weather;
        final colors = WeatherUtils.getWeatherGradient(
          condition: weather?.condition ?? 'Clouds',
          isNight: viewModel.isNight,
          isDarkMode: viewModel.isDarkMode,
        );

        return Scaffold(
          body: AnimatedContainer(
            duration: const Duration(milliseconds: 600),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: colors,
              ),
            ),
            child: Stack(
              children: [
                _AnimatedSky(controller: _backgroundController, isNight: viewModel.isNight),
                if ((weather?.condition.toLowerCase().contains('rain') ?? false) &&
                    viewModel.rainAlertsEnabled)
                  const _RainOverlay(),
                SafeArea(
                  child: RefreshIndicator(
                    onRefresh: viewModel.refresh,
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(),
                      padding: const EdgeInsets.all(16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildHeader(context, viewModel),
                          const SizedBox(height: 16),
                          if (viewModel.isLoading)
                            const Center(child: LoadingSkeleton())
                          else if (viewModel.error != null)
                            _buildError(viewModel)
                          else if (weather != null)
                            _buildWeatherContent(context, viewModel),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader(BuildContext context, WeatherViewModel viewModel) {
    return Row(
      children: [
        _circleIconButton(
          icon: Icons.my_location,
          onTap: viewModel.fetchWeatherByLocation,
        ),
        const SizedBox(width: 8),
        _circleIconButton(
          icon: Icons.search,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            );
          },
        ),
        const SizedBox(width: 8),
        _circleIconButton(
          icon: Icons.location_city_outlined,
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ManageCitiesScreen()),
            );
          },
        ),
        const Spacer(),
        Stack(
          children: [
            _circleIconButton(
              icon: Icons.notifications_none,
              onTap: () => _openNotificationsSheet(context, viewModel),
            ),
            if (viewModel.notifications.isNotEmpty)
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: Colors.orangeAccent,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }

  Widget _buildWeatherContent(BuildContext context, WeatherViewModel viewModel) {
    final weather = viewModel.weather!;
    final hoursToSunset = ((weather.sunset -
                (DateTime.now().millisecondsSinceEpoch ~/ 1000)) /
            3600)
        .clamp(0, 24)
        .toStringAsFixed(1);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TweenAnimationBuilder<double>(
          duration: const Duration(milliseconds: 700),
          tween: Tween(begin: 0, end: 1),
          builder: (context, value, child) {
            return Transform.translate(
              offset: Offset(0, (1 - value) * 24),
              child: Opacity(opacity: value, child: child),
            );
          },
          child: Column(
            children: [
              Text(
                weather.cityName,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                '${viewModel.isNight ? 'Night' : 'Day'} conditions • ${weather.description}',
                style: TextStyle(color: Colors.white.withValues(alpha: 0.85)),
              ),
              const SizedBox(height: 10),
              Icon(
                WeatherUtils.getWeatherIcon(weather.condition),
                color: Colors.white,
                size: 92,
              ),
              Text(
                viewModel.getTemperature(weather.temperature),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 64,
                  fontWeight: FontWeight.bold,
                  height: 1,
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                children: [
                  _chipButton(
                    icon: viewModel.isCelsius ? Icons.thermostat : Icons.device_thermostat,
                    label: viewModel.isCelsius ? '°C' : '°F',
                    onTap: viewModel.toggleUnit,
                  ),
                  _chipButton(
                    icon: viewModel.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                    label: viewModel.isDarkMode ? 'Light' : 'Dark',
                    onTap: viewModel.toggleTheme,
                  ),
                  _chipButton(
                    icon: viewModel.rainAlertsEnabled
                        ? Icons.notifications_active
                        : Icons.notifications_off,
                    label: 'Rain Alerts',
                    onTap: () => viewModel.toggleRainAlerts(!viewModel.rainAlertsEnabled),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 20),
        if (viewModel.rainAlerts.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(14),
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: Colors.orange.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: Colors.orange.withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Rain Alerts',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
                ),
                const SizedBox(height: 6),
                ...viewModel.rainAlerts.take(2).map(
                      (item) => Text(
                        item,
                        style: TextStyle(color: Colors.white.withValues(alpha: 0.9)),
                      ),
                    ),
              ],
            ),
          ),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 10,
          crossAxisSpacing: 10,
          childAspectRatio: 1.55,
          children: [
            WeatherInfoCard(
              icon: Icons.water_drop_outlined,
              label: 'Humidity',
              value: '${weather.humidity}%',
            ),
            WeatherInfoCard(
              icon: Icons.air,
              label: 'Wind',
              value: '${weather.windSpeed.toStringAsFixed(1)} m/s',
            ),
            WeatherInfoCard(
              icon: Icons.wb_sunny_outlined,
              label: 'Sunrise',
              value: WeatherUtils.formatTime(weather.sunrise),
            ),
            WeatherInfoCard(
              icon: Icons.nightlight_round,
              label: 'Sunset',
              value: WeatherUtils.formatTime(weather.sunset),
            ),
          ],
        ),
        const SizedBox(height: 18),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.16),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
          ),
          child: Text(
            'Feels like ${viewModel.getTemperature(weather.feelsLike)} • '
            'Visibility ${(weather.visibility / 1000).toStringAsFixed(1)} km • '
            '$hoursToSunset h until sunset',
            style: const TextStyle(color: Colors.white),
          ),
        ),
        const SizedBox(height: 22),
        _title('24-Hour Forecast'),
        const SizedBox(height: 10),
        SizedBox(
          height: 138,
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
        const SizedBox(height: 22),
        _title('15-Day Forecast'),
        const SizedBox(height: 10),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: viewModel.fifteenDayOutlook.length,
          itemBuilder: (context, index) {
            return DailyForecastCard(
              forecast: viewModel.fifteenDayOutlook[index],
              isCelsius: viewModel.isCelsius,
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
          const Icon(Icons.error_outline, color: Colors.white, size: 56),
          const SizedBox(height: 10),
          Text(
            viewModel.error ?? 'Something went wrong',
            style: const TextStyle(color: Colors.white),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          ElevatedButton(
            onPressed: viewModel.fetchWeatherByLocation,
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  Widget _circleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.15),
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
      ),
      child: IconButton(
        icon: Icon(icon, color: Colors.white),
        onPressed: onTap,
      ),
    );
  }

  Widget _chipButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(24),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.18),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 16, color: Colors.white),
            const SizedBox(width: 6),
            Text(label, style: const TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }

  Widget _title(String text) {
    return Text(
      text,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w700,
      ),
    );
  }

  void _openNotificationsSheet(BuildContext context, WeatherViewModel viewModel) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFF1E2B3A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    const Text(
                      'Notifications',
                      style: TextStyle(color: Colors.white, fontSize: 18),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        viewModel.clearNotifications();
                        Navigator.pop(context);
                      },
                      child: const Text('Clear all'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Expanded(
                  child: viewModel.notifications.isEmpty
                      ? const Center(
                          child: Text(
                            'No notifications yet',
                            style: TextStyle(color: Colors.white70),
                          ),
                        )
                      : ListView.builder(
                          itemCount: viewModel.notifications.length,
                          itemBuilder: (_, index) => ListTile(
                            leading: const Icon(Icons.circle_notifications,
                                color: Colors.lightBlueAccent),
                            title: Text(
                              viewModel.notifications[index],
                              style: const TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _AnimatedSky extends StatelessWidget {
  final AnimationController controller;
  final bool isNight;

  const _AnimatedSky({required this.controller, required this.isNight});

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Stack(
          children: [
            Positioned(
              left: -30 + (controller.value * 14),
              top: 40,
              child: _orb(160, isNight ? Colors.white12 : Colors.white24),
            ),
            Positioned(
              right: -40 + (controller.value * 22),
              top: 170,
              child: _orb(200, isNight ? Colors.blueGrey.withValues(alpha: 0.25) : Colors.white12),
            ),
          ],
        );
      },
    );
  }

  Widget _orb(double size, Color color) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _RainOverlay extends StatelessWidget {
  const _RainOverlay();

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      child: Opacity(
        opacity: 0.22,
        child: CustomPaint(
          size: MediaQuery.of(context).size,
          painter: _RainPainter(),
        ),
      ),
    );
  }
}

class _RainPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = Colors.white
      ..strokeWidth = 1.2;
    for (double x = 0; x < size.width; x += 14) {
      for (double y = -20; y < size.height; y += 34) {
        canvas.drawLine(Offset(x, y), Offset(x + 6, y + 12), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
