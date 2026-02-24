import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../services/weather_service.dart';
import '../viewmodels/weather_viewmodel.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final WeatherService _weatherService = WeatherService();
  List<String> _suggestions = [];
  bool _isSearching = false;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _searchCity(String query) async {
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
    } catch (_) {
      setState(() => _isSearching = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _searchController,
          autofocus: true,
          decoration: const InputDecoration(
            hintText: 'Search city...',
            border: InputBorder.none,
          ),
          onChanged: _searchCity,
        ),
      ),
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 300),
        child: _isSearching
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                key: ValueKey(_suggestions.length),
                itemCount: _suggestions.length,
                itemBuilder: (context, index) {
                  final city = _suggestions[index];
                  return ListTile(
                    leading: const Icon(Icons.place_outlined),
                    title: Text(city),
                  onTap: () async {
                      await context.read<WeatherViewModel>().fetchWeatherByCity(city);
                      if (!context.mounted) return;
                      Navigator.pop(context);
                    },
                  );
                },
              ),
      ),
    );
  }
}
