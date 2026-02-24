import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../viewmodels/weather_viewmodel.dart';

class ManageCitiesScreen extends StatefulWidget {
  const ManageCitiesScreen({super.key});

  @override
  State<ManageCitiesScreen> createState() => _ManageCitiesScreenState();
}

class _ManageCitiesScreenState extends State<ManageCitiesScreen> {
  final TextEditingController _cityController = TextEditingController();

  @override
  void dispose() {
    _cityController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<WeatherViewModel>(
      builder: (context, viewModel, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Manage Cities'),
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                TextField(
                  controller: _cityController,
                  decoration: InputDecoration(
                    hintText: 'Add city',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () async {
                        final city = _cityController.text.trim();
                        if (city.isEmpty) return;
                        await viewModel.addManagedCity(city);
                        _cityController.clear();
                      },
                    ),
                  ),
                  onSubmitted: (value) async {
                    if (value.trim().isEmpty) return;
                    await viewModel.addManagedCity(value.trim());
                    _cityController.clear();
                  },
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: viewModel.managedCities.isEmpty
                      ? const Center(child: Text('No saved cities yet'))
                      : ListView.builder(
                          itemCount: viewModel.managedCities.length,
                          itemBuilder: (context, index) {
                            final city = viewModel.managedCities[index];
                            return Card(
                              child: ListTile(
                                leading: const Icon(Icons.location_city),
                                title: Text(city),
                                trailing: IconButton(
                                  icon: const Icon(Icons.delete_outline),
                                  onPressed: () => viewModel.removeManagedCity(city),
                                ),
                                onTap: () async {
                                  await viewModel.fetchWeatherByCity(city);
                                  if (!context.mounted) return;
                                  Navigator.pop(context);
                                },
                              ),
                            );
                          },
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
