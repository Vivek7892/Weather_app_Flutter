import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';
import '../services/weather_service.dart';

class SearchScreen extends StatefulWidget {
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<String> _suggestions = [];
  bool _isSearching = false;

  void _searchCity(String query) async {
    if (query.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    setState(() => _isSearching = true);
    try {
      final suggestions = await _weatherService.getCitySuggestions(query);
      setState(() {
        _suggestions = suggestions;
        _isSearching = false;
      });
    } catch (e) {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade700,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: TextField(
          controller: _searchController,
          autofocus: true,
          style: TextStyle(color: Colors.white),
          decoration: InputDecoration(
            hintText: 'Search city...',
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: _searchCity,
        ),
      ),
      body: _isSearching
          ? Center(child: CircularProgressIndicator(color: Colors.white))
          : ListView.builder(
              itemCount: _suggestions.length,
              itemBuilder: (context, index) {
                final city = _suggestions[index];
                return ListTile(
                  leading: Icon(Icons.location_city, color: Colors.white),
                  title: Text(
                    city,
                    style: TextStyle(color: Colors.white),
                  ),
                  onTap: () {
                    final cityName = city.split(',')[0];
                    context.read<WeatherViewModel>().fetchWeatherByCity(cityName);
                    Navigator.pop(context);
                  },
                );
              },
            ),
    );
  }
}
