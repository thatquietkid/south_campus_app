import 'package:flutter/material.dart';

class HostelScreen extends StatefulWidget {
  const HostelScreen({super.key});

  @override
  State<HostelScreen> createState() => _HostelScreenState();
}

class _HostelScreenState extends State<HostelScreen> {
  final List<Map<String, dynamic>> _hostels = [
    {
      'name': 'Aryabhatta Hostel (Boys)',
      'type': 'Boys',
      'address': 'Near Science Block A, South Campus',
      'warden': 'Dr. Sharma',
      'warden_contact': '9876543210',
      'caretaker': 'Mr. Verma',
      'caretaker_contact': '8765432109',
      'capacity': '150',
      'available': 35,
      'facilities': 'Attached bathroom, Mess facility, Common room, Wifi',
      'color': Colors.blue[100],
    },
    {
      'name': 'Lilavati Hostel (Girls)',
      'type': 'Girls',
      'address': 'Opposite Faculty of Arts, South Campus',
      'warden': 'Dr. Gupta',
      'warden_contact': '9988776655',
      'caretaker': 'Ms. Singh',
      'caretaker_contact': '7766554433',
      'capacity': '120',
      'available': 15,
      'facilities': 'Attached bathroom, Mess facility, Reading room, Laundry service, 24/7 Security',
      'color': Colors.pink[100],
    },
    {
      'name': 'Tagore International Hostel (Mixed)',
      'type': 'Mixed',
      'address': 'Behind Sports Complex, South Campus',
      'warden': 'Prof. Banerjee',
      'warden_contact': '9012345678',
      'caretaker': 'Mr. Khan',
      'caretaker_contact': '8098765432',
      'capacity': '180',
      'available': 60,
      'facilities': 'Common bathroom, Mess facility, TV room, Indoor games, Guest room',
      'color': Colors.orange[100],
    },
    {
      'name': 'Vivekananda Hostel (Boys)',
      'type': 'Boys',
      'address': 'Next to Library, South Campus',
      'warden': 'Dr. Reddy',
      'warden_contact': '9321654870',
      'caretaker': 'Mr. Patel',
      'caretaker_contact': '7654321098',
      'capacity': '160',
      'available': 20,
      'facilities': 'Attached bathroom, Mess facility, Computer lab, Sports facilities',
      'color': Colors.blue[100],
    },
    {
      'name': 'Sarojini Hostel (Girls)',
      'type': 'Girls',
      'address': 'Near Cafeteria, South Campus',
      'warden': 'Dr. Verma',
      'warden_contact': '9182736450',
      'caretaker': 'Ms. Sharma',
      'caretaker_contact': '8574639201',
      'capacity': '130',
      'available': 25,
      'facilities': 'Attached bathroom, Mess facility, Common room, Music room, Medical assistance',
      'color': Colors.pink[100],
    },
    {
      'name': 'Gandhi House (Boys)',
      'type': 'Boys',
      'address': 'Opposite Admin Block, South Campus',
      'warden': 'Dr. Singh',
      'warden_contact': '9765432109',
      'caretaker': 'Mr. Yadav',
      'caretaker_contact': '8901234567',
      'capacity': '140',
      'available': 40,
      'facilities': 'Attached bathroom, Mess facility, Reading hall, Outdoor games',
      'color': Colors.blue[100],
    },
    {
      'name': 'Nehru Bhawan (Mixed)',
      'type': 'Mixed',
      'address': 'Near Faculty of Science, South Campus',
      'warden': 'Prof. Joshi',
      'warden_contact': '9234567890',
      'caretaker': 'Ms. Kumari',
      'caretaker_contact': '7098765431',
      'capacity': '200',
      'available': 70,
      'facilities': 'Common bathroom, Mess facility, Seminar room, Library',
      'color': Colors.orange[100],
    },
  ];

  List<Map<String, dynamic>> _filteredHostels = [];
  final TextEditingController _searchController = TextEditingController();
  String? _selectedFilter; // To hold the selected hostel type filter

  @override
  void initState() {
    super.initState();
    _filteredHostels = List.from(_hostels);
    _searchController.addListener(_filterHostels);
  }

  void _filterHostels() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredHostels = _hostels.where((hostel) {
        final nameMatch = hostel['name'].toString().toLowerCase().contains(query);
        final addressMatch = hostel['address'].toString().toLowerCase().contains(query);
        final wardenMatch = hostel['warden'].toString().toLowerCase().contains(query);
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
      _filterHostels(); // Re-apply the text filter after type filter
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
                  color: hostel['color'] ?? Colors.grey[200],
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
                            _buildDetailRow('Capacity', hostel['capacity']),
                            _buildDetailRow('Available Rooms', hostel['available']?.toString()),
                            _buildDetailRow('Facilities', hostel['facilities']),
                            // Add more details as needed
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
              // TODO: Implement phone call functionality
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