import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'viewmodels/weather_viewmodel.dart';
import 'views/weather_home_screen.dart';

void main() {
  runApp(const WeatherApp());
}

class WeatherApp extends StatelessWidget {
  const WeatherApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => WeatherViewModel(),
      child: Consumer<WeatherViewModel>(
        builder: (context, viewModel, _) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            title: 'Weather',
            theme: ThemeData(
              brightness: Brightness.light,
              colorSchemeSeed: const Color(0xFF3E84B5),
              useMaterial3: true,
              fontFamily: 'Georgia',
            ),
            darkTheme: ThemeData(
              brightness: Brightness.dark,
              colorSchemeSeed: const Color(0xFF2A5679),
              useMaterial3: true,
              fontFamily: 'Georgia',
            ),
            themeMode: viewModel.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            home: const WeatherHomeScreen(),
          );
        },
      ),
    );
  }
}

