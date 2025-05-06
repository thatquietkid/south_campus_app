import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  List<Map<String, dynamic>> _events = [];
  List<Map<String, dynamic>> _filteredEvents = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    _fetchEvents();
    _searchController.addListener(_filterEvents);
  }

  Future<void> _fetchEvents() async {
    final url = Uri.parse('https://south-campus-backend.onrender.com/events');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<dynamic> jsonData = json.decode(response.body);

        setState(() {
          _events = jsonData.map((event) => {
            'title': event['title'] ?? '',
            'date': event['date'] ?? '',
            'time': event['time'] ?? '',
            'venue': event['venue'] ?? '',
            'description': event['description'] ?? '',
            'contact': event['contact'] ?? '',
            'category': event['category'] ?? '',
          }).toList();

          _filteredEvents = List.from(_events);
        });
      } else {
        debugPrint('Failed to load events: ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching events: $e');
    }
  }

  void _filterEvents() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredEvents = _events.where((event) {
        final titleMatch = event['title']?.toLowerCase().contains(query) ?? false;
        final descriptionMatch = event['description']?.toLowerCase().contains(query) ?? false;
        final venueMatch = event['venue']?.toLowerCase().contains(query) ?? false;
        return titleMatch || descriptionMatch || venueMatch;
      }).toList();

      if (_selectedCategoryFilter != null && _selectedCategoryFilter != 'All') {
        _filteredEvents = _filteredEvents
            .where((event) => event['category'] == _selectedCategoryFilter)
            .toList();
      }
    });
  }

  void _applyCategoryFilter(String? category) {
    setState(() {
      _selectedCategoryFilter = category;
      _filterEvents();
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
        title: const Text('Events'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search events by title, description, or venue...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                const Text('Filter by Category:'),
                const SizedBox(width: 8.0),
                DropdownButton<String>(
                  value: _selectedCategoryFilter,
                  items: <String>['All', 'Academic', 'Cultural', 'Sports', 'Social']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _applyCategoryFilter,
                ),
              ],
            ),
          ),
          Expanded(
            child: _filteredEvents.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: const Icon(Icons.event),
                    title: Text(
                      event['title'] ?? 'Event Title Unavailable',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text('${event['date']} | ${event['venue']}'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildDetailRow('Date', event['date']),
                            _buildDetailRow('Time', event['time']),
                            _buildDetailRow('Venue', event['venue']),
                            const SizedBox(height: 8.0),
                            const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                            Text(event['description'] ?? 'No description provided.'),
                            const SizedBox(height: 8.0),
                            _buildDetailRow('Contact', event['contact']),
                            _buildDetailRow('Category', event['category']),
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

  Widget _buildDetailRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          Expanded(child: Text(value ?? 'Not Available')),
        ],
      ),
    );
  }
}