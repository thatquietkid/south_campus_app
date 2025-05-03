import 'package:flutter/material.dart';

class EventsScreen extends StatefulWidget {
  const EventsScreen({super.key});

  @override
  State<EventsScreen> createState() => _EventsScreenState();
}

class _EventsScreenState extends State<EventsScreen> {
  final List<Map<String, String>> _events = [
    {
      'title': 'Orientation Day 2025',
      'date': 'August 5, 2025',
      'time': '9:00 AM - 5:00 PM',
      'venue': 'Main Auditorium',
      'description': 'Welcome event for all new students with introductory sessions and campus tour.',
      'contact': 'studentaffairs@southcampus.edu',
      'category': 'Academic',
    },
    {
      'title': 'Annual Cultural Fest - "Synergy"',
      'date': 'October 12 - 14, 2025',
      'time': 'Various timings',
      'venue': 'Open Grounds & Amphitheater',
      'description': 'Three days of music, dance, drama, and art competitions. Open to all students and faculty.',
      'contact': 'culturalcommittee@southcampus.edu',
      'category': 'Cultural',
    },
    {
      'title': 'Guest Lecture on Quantum Physics',
      'date': 'September 20, 2025',
      'time': '2:00 PM - 4:00 PM',
      'venue': 'Science Block A, Room 201',
      'description': 'A lecture by renowned physicist Dr. A.P. Sharma on the latest advancements in quantum physics.',
      'contact': 'physicsdepartment@southcampus.edu',
      'category': 'Academic',
    },
    {
      'title': 'Inter-Department Sports Meet',
      'date': 'November 5 - 7, 2025',
      'time': '9:00 AM onwards',
      'venue': 'Sports Complex',
      'description': 'Annual sports competition between different departments. Includes cricket, football, basketball, and more.',
      'contact': 'sportscommittee@southcampus.edu',
      'category': 'Sports',
    },
    {
      'title': 'Workshop on Web Development',
      'date': 'July 15 - 17, 2025',
      'time': '10:00 AM - 4:00 PM',
      'venue': 'Computer Science Lab 1 & 2',
      'description': 'A hands-on workshop on the latest web development technologies and frameworks.',
      'contact': 'csdepartment@southcampus.edu',
      'category': 'Academic',
    },
    {
      'title': 'Movie Screening Night',
      'date': 'August 25, 2025',
      'time': '7:00 PM - 9:30 PM',
      'venue': 'Open Lawn near Admin Block',
      'description': 'Outdoor screening of a popular movie. Bring your blankets and enjoy!',
      'contact': 'studentcouncil@southcampus.edu',
      'category': 'Social',
    },
    {
      'title': 'Debate Competition - "The Voice"',
      'date': 'October 25, 2025',
      'time': '10:00 AM - 3:00 PM',
      'venue': 'Law Faculty Auditorium',
      'description': 'Annual inter-college debate competition on current social and political issues.',
      'contact': 'debatingclub@southcampus.edu',
      'category': 'Academic',
    },
    {
      'title': 'Photography Exhibition - "Frames of South Campus"',
      'date': 'September 10 - 12, 2025',
      'time': '11:00 AM - 5:00 PM',
      'venue': 'Art Gallery, Faculty of Arts',
      'description': 'An exhibition showcasing the best photographs captured by students and faculty of South Campus.',
      'contact': 'photographyclub@southcampus.edu',
      'category': 'Cultural',
    },
  ];

  List<Map<String, String>> _filteredEvents = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedCategoryFilter;

  @override
  void initState() {
    super.initState();
    _filteredEvents = List.from(_events);
    _searchController.addListener(_filterEvents);
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
        _filteredEvents = _filteredEvents.where((event) => event['category'] == _selectedCategoryFilter).toList();
      }
    });
  }

  void _applyCategoryFilter(String? category) {
    setState(() {
      _selectedCategoryFilter = category;
      _filterEvents(); // Re-apply the text filter after category filter
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
            child: ListView.builder(
              itemCount: _filteredEvents.length,
              itemBuilder: (context, index) {
                final event = _filteredEvents[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  child: ExpansionTile(
                    leading: const Icon(Icons.event), // Add a leading icon
                    title: Text(event['title'] ?? 'Event Title Unavailable',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
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