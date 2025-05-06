import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

// ==========================
// Bus Route and Schedule Models
// ==========================
class ScheduleStop {
  final String stop;
  final String time;

  ScheduleStop({required this.stop, required this.time});

  factory ScheduleStop.fromMap(Map<String, dynamic> map) {
    return ScheduleStop(
      stop: map['stop'] ?? '',
      time: map['time'] ?? '',
    );
  }
}

class BusRoute {
  final String number;
  final Color color;
  final String name;
  final String description;
  final List<ScheduleStop> schedule;

  BusRoute({
    required this.number,
    required this.color,
    required this.name,
    required this.description,
    required this.schedule,
  });

  factory BusRoute.fromMap(Map<String, dynamic> map) {
    return BusRoute(
      number: map['number'] ?? '',
      color: _getColorFromString(map['color'] ?? 'grey'),
      name: map['name'] ?? '',
      description: map['description'] ?? '',
      schedule: List<ScheduleStop>.from(
        map['schedule'].map((x) => ScheduleStop.fromMap(x)),
      ),
    );
  }

  static Color _getColorFromString(String colorString) {
    switch (colorString.toLowerCase()) {
      case 'blue':
        return Colors.blue[300]!;
      case 'green':
        return Colors.green[300]!;
      case 'orange':
        return Colors.orange[300]!;
      case 'purple':
        return Colors.purple[300]!;
      default:
        return Colors.grey;
    }
  }
}

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  List<BusRoute> _busRoutes = [];
  List<BusRoute> _filteredRoutes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_filterRoutes);
    _fetchBusRoutes();  // Fetch data when the widget is initialized
  }

  Future<void> _fetchBusRoutes() async {
    final response = await http.get(Uri.parse('https://south-campus-backend.onrender.com/bus-routes'));

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        _busRoutes = data.map((e) => BusRoute.fromMap(e)).toList();
        _filteredRoutes = List.from(_busRoutes);  // Initialize with all routes
      });
    } else {
      throw Exception('Failed to load bus routes');
    }
  }

  void _filterRoutes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRoutes = _busRoutes.where((route) {
        final nameMatch = route.name.toLowerCase().contains(query);
        final numberMatch = route.number.toLowerCase().contains(query);
        final descriptionMatch = route.description.toLowerCase().contains(query);
        final scheduleMatch = route.schedule.any((schedule) {
          return schedule.stop.toLowerCase().contains(query) ||
              schedule.time.toLowerCase().contains(query);
        });
        return nameMatch || numberMatch || descriptionMatch || scheduleMatch;
      }).toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Transport'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search routes, numbers, descriptions, or stops...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Expanded(
            child: _busRoutes.isEmpty
                ? const Center(child: CircularProgressIndicator()) // Show loading indicator if data is empty
                : ListView.builder(
              itemCount: _filteredRoutes.length,
              itemBuilder: (context, index) {
                final route = _filteredRoutes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: route.color,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        route.number,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(route.name, style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(route.description),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            const Text('Schedule:', style: TextStyle(fontWeight: FontWeight.bold)),
                            const SizedBox(height: 8.0),
                            ListView.builder(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              itemCount: route.schedule.length,
                              itemBuilder: (context, scheduleIndex) {
                                final schedule = route.schedule[scheduleIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text('${schedule.stop}: ${schedule.time}'),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
