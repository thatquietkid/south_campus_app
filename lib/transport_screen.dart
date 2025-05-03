import 'package:flutter/material.dart';

class TransportScreen extends StatefulWidget {
  const TransportScreen({super.key});

  @override
  State<TransportScreen> createState() => _TransportScreenState();
}

class _TransportScreenState extends State<TransportScreen> {
  final List<Map<String, dynamic>> _busRoutes = [
    {
      'number': 'SC-01',
      'color': Colors.blue[300],
      'name': 'Blue Line: South to North Campus Express',
      'description': 'Fast connection between South and North Campus.',
      'schedule': [
        {'stop': 'South Campus Gate 1', 'time': '8:00 AM'},
        {'stop': 'Dhaula Kuan Metro', 'time': '8:25 AM'},
        {'stop': 'AIIMS', 'time': '8:40 AM'},
        {'stop': 'North Campus (VC Office)', 'time': '9:10 AM'},
        {'stop': 'South Campus Gate 1', 'time': '5:00 PM'},
        {'stop': 'Dhaula Kuan Metro', 'time': '5:25 PM'},
        {'stop': 'AIIMS', 'time': '5:40 PM'},
        {'stop': 'North Campus (VC Office)', 'time': '6:10 PM'},
      ],
    },
    {
      'number': 'SC-02',
      'color': Colors.green[300],
      'name': 'Green Line: South Campus Circular',
      'description': 'Circular route covering key points within South Campus.',
      'schedule': [
        {'stop': 'South Campus Hostel Zone', 'time': '8:15 AM'},
        {'stop': 'Faculty of Arts South', 'time': '8:30 AM'},
        {'stop': 'Sports Complex', 'time': '8:45 AM'},
        {'stop': 'South Campus Hostel Zone', 'time': '9:00 AM'},
        {'stop': 'South Campus Hostel Zone', 'time': '5:15 PM'},
        {'stop': 'Faculty of Arts South', 'time': '5:30 PM'},
        {'stop': 'Sports Complex', 'time': '5:45 PM'},
        {'stop': 'South Campus Hostel Zone', 'time': '6:00 PM'},
      ],
    },
    {
      'number': 'SC-03',
      'color': Colors.orange[300],
      'name': 'Orange Line: Connecting to Nearby Metro Stations',
      'description': 'Shuttle service to nearby metro stations.',
      'schedule': [
        {'stop': 'South Campus Gate 2', 'time': '8:45 AM'},
        {'stop': 'Ber Sarai Metro Station', 'time': '9:00 AM'},
        {'stop': 'IIT Delhi Metro Station', 'time': '9:15 AM'},
        {'stop': 'South Campus Gate 2', 'time': '9:30 AM'},
        {'stop': 'South Campus Gate 2', 'time': '5:30 PM'},
        {'stop': 'Ber Sarai Metro Station', 'time': '5:45 PM'},
        {'stop': 'IIT Delhi Metro Station', 'time': '6:00 PM'},
        {'stop': 'South Campus Gate 2', 'time': '6:15 PM'},
      ],
    },
    {
      'number': 'SC-04',
      'color': Colors.purple[300],
      'name': 'Purple Line: Inter-Hostel Shuttle',
      'description': 'Connects various hostels within South Campus.',
      'schedule': [
        {'stop': 'Hostel A', 'time': '7:30 AM'},
        {'stop': 'Hostel B', 'time': '7:45 AM'},
        {'stop': 'Hostel C', 'time': '8:00 AM'},
        {'stop': 'Hostel A', 'time': '8:15 AM'},
        {'stop': 'Hostel A', 'time': '6:00 PM'},
        {'stop': 'Hostel B', 'time': '6:15 PM'},
        {'stop': 'Hostel C', 'time': '6:30 PM'},
        {'stop': 'Hostel A', 'time': '6:45 PM'},
      ],
    },
  ];

  List<Map<String, dynamic>> _filteredRoutes = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _filteredRoutes = List.from(_busRoutes); // Initialize with all routes
    _searchController.addListener(_filterRoutes);
  }

  void _filterRoutes() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredRoutes = _busRoutes.where((route) {
        final nameMatch = route['name'].toString().toLowerCase().contains(query);
        final numberMatch = route['number'].toString().toLowerCase().contains(query);
        final descriptionMatch = route['description'].toString().toLowerCase().contains(query);
        final scheduleMatch = (route['schedule'] as List).any((schedule) {
          return schedule['stop'].toString().toLowerCase().contains(query) ||
              schedule['time'].toString().toLowerCase().contains(query);
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
            child: ListView.builder(
              itemCount: _filteredRoutes.length,
              itemBuilder: (context, index) {
                final route = _filteredRoutes[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: route['color'] ?? Colors.grey,
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Text(
                        route['number'] ?? 'N/A',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    title: Text(route['name'], style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(route['description']),
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
                              itemCount: (route['schedule'] as List).length,
                              itemBuilder: (context, scheduleIndex) {
                                final schedule = (route['schedule'] as List)[scheduleIndex];
                                return Padding(
                                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                                  child: Text('${schedule['stop']}: ${schedule['time']}'),
                                );
                              },
                            ),
                            // Add more details if available
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