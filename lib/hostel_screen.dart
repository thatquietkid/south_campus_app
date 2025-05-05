import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HostelScreen extends StatefulWidget {
  const HostelScreen({super.key});

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  List<dynamic> _hostels = []; // Changed to dynamic to hold the JSON response
  List<dynamic> _filteredHostels = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter;
  bool _isLoading = true; // To track loading state
  String? _errorMessage; // To display any error messages

  @override
  void initState() {
    super.initState();
    _fetchHostels();
    _searchController.addListener(_filterHostels);
  }

  Future<void> _fetchHostels() async {
    final url = Uri.parse('https://south-campus-backend.onrender.com/hostels');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        setState(() {
          _isLoading = false;
          _hostels = data;
          _filteredHostels = List.from(data);
        });
      } else {
        setState(() {
          _isLoading = false;
          _errorMessage = 'Failed to load hostels: Status code ${response.statusCode}';
        });
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
        _errorMessage = 'Failed to connect to the server: $error';
      });
    }
  }

  void _filterHostels() {
    if (_hostels.isEmpty) return; // Avoid filtering if data is not loaded yet
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHostels = _hostels.where((hostel) {
        final nameMatch = hostel['name']?.toString().toLowerCase().contains(query) ?? false;
        final addressMatch = hostel['address']?.toString().toLowerCase().contains(query) ?? false;
        final wardenMatch = hostel['warden']?.toString().toLowerCase().contains(query) ?? false;
        return nameMatch || addressMatch || wardenMatch;
      }).toList();
      if (_selectedFilter != null && _selectedFilter != 'All') {
        _filteredHostels = _filteredHostels.where((hostel) => hostel['type'] == _selectedFilter).toList();
      }
    });
  }

  void _applyTypeFilter(String? type) {
    setState(() {
      _selectedFilter = type;
      _filterHostels();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return Scaffold(
        appBar: AppBar(
          title: Text('Hostels'),
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('Hostels'),
        ),
        body: Center(
          child: Text(_errorMessage!),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hostels'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search by name, address, or warden...',
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
                const Text('Filter by Type:'),
                const SizedBox(width: 8.0),
                DropdownButton<String>(
                  value: _selectedFilter,
                  items: <String>['All', 'Boys', 'Girls', 'Mixed']
                      .map((String value) {
                    return DropdownMenuItem<String>(
                      value: value,
                      child: Text(value),
                    );
                  }).toList(),
                  onChanged: _applyTypeFilter,
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: _filteredHostels.length,
              itemBuilder: (context, index) {
                final hostel = _filteredHostels[index];
                return Card(
                  margin: const EdgeInsets.all(8.0),
                  color: Colors.grey[200], // Removed hostel['color'] as it's not in the API response
                  child: ExpansionTile(
                    title: Text(hostel['name'] ?? 'Hostel Name Unavailable',
                        style: const TextStyle(fontWeight: FontWeight.bold)),
                    subtitle: Text(hostel['type'] ?? 'Type Unavailable'),
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            _buildDetailRow('Address', hostel['address']),
                            _buildDetailRow('Warden', hostel['warden']),
                            _buildContactOption('Contact Warden', hostel['warden_contact']),
                            _buildDetailRow('Caretaker', hostel['caretaker']),
                            _buildContactOption('Contact Caretaker', hostel['caretaker_contact']),
                            _buildDetailRow('Capacity', hostel['capacity']?.toString()),
                            _buildDetailRow('Available Rooms', hostel['available']?.toString()),
                            _buildDetailRow('Facilities', hostel['facilities']),
                            // Add more details as needed based on your API response
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

  Widget _buildContactOption(String label, String? contact) {
    if (contact == null || contact.isEmpty) {
      return const SizedBox.shrink();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(width: 8.0),
          InkWell(
            onTap: () {
              // TODO: Implement phone call functionality using url_launcher package
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Calling $label ($contact) - Not implemented')),
              );
            },
            child: Text(
              contact,
              style: const TextStyle(color: Colors.blue, decoration: TextDecoration.underline),
            ),
          ),
        ],
      ),
    );
  }
}