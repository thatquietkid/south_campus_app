import 'package:flutter/material.dart';

class ComplaintsScreen extends StatefulWidget {
  const ComplaintsScreen({super.key});

  @override
  State<ComplaintsScreen> createState() => _ComplaintsScreenState();
}

class _ComplaintsScreenState extends State<ComplaintsScreen> with TickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _subjectController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  String? _selectedCategory;

  final List<String> _complaintCategories = ['Infrastructure', 'Mess/Cafeteria', 'Cleanliness', 'Academics', 'Other'];
  final List<Map<String, String>> _allComplaints = [
    {
      'name': 'John Doe',
      'email': 'john.doe@example.com',
      'subject': 'Leaky Faucet in Hostel Bathroom',
      'description': 'The faucet in bathroom number 3 on the second floor of Aryabhatta Hostel is constantly dripping. This is wasting water and is quite noisy.',
      'status': 'Pending'
    },
    {
      'name': 'Jane Smith',
      'email': 'jane.smith@example.com',
      'subject': 'Poor Food Quality in Mess',
      'description': 'The food served in the mess, especially during dinner, has been consistently of poor quality. The vegetables are often undercooked, and the taste is not satisfactory.',
      'status': 'Resolved'
    },
    {
      'name': 'Peter Jones',
      'email': 'peter.jones@example.com',
      'subject': 'Classroom AC Not Working',
      'description': 'The air conditioning unit in classroom 101 of the Science Block A has been malfunctioning for the past week. It gets very hot and uncomfortable during lectures.',
      'status': 'In Progress'
    },
    {
      'name': 'Alice Brown',
      'email': 'alice.brown@example.com',
      'subject': 'Unavailability of Books in Library',
      'description': 'Several key textbooks required for the upcoming exams are currently unavailable in the library. This is hindering our studies.',
      'status': 'Pending'
    },
    {
      'name': 'Bob Green',
      'email': 'bob.green@example.com',
      'subject': 'Cleanliness Issue in Common Area',
      'description': 'The common area on the ground floor of the academic building is often unclean with litter and spills not being promptly addressed.',
      'status': 'Resolved'
    },
    {
      'name': 'Charlie White',
      'email': 'charlie.white@example.com',
      'subject': 'Network Connectivity Issues',
      'description': 'The Wi-Fi connectivity in the hostel common room has been unreliable for the past few days, making it difficult to study and access online resources.',
      'status': 'Pending'
    },
    {
      'name': 'Diana Black',
      'email': 'diana.black@example.com',
      'subject': 'Noise Disturbance in Residential Area',
      'description': 'There has been excessive noise coming from the open grounds late at night, disturbing the sleep of residents in the nearby hostels.',
      'status': 'In Progress'
    },
    {
      'name': 'Ethan Grey',
      'email': 'ethan.grey@example.com',
      'subject': 'Suggestion for More Dustbins',
      'description': 'I would like to suggest placing more dustbins around the campus, especially near the cafeteria and common gathering spots, to help maintain cleanliness.',
      'status': 'Acknowledged'
    },
  ];

  List<Map<String, String>> _filteredComplaints = [];
  String? _selectedStatusFilter;
  List<String> _statusFilters = ['All', 'Pending', 'Resolved', 'In Progress', 'Acknowledged', 'Submitted'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _filteredComplaints = List.from(_allComplaints);
    _applyFilters();
  }

  void _submitComplaint() {
    if (_formKey.currentState!.validate()) {
      final name = _nameController.text;
      final email = _emailController.text;
      final subject = _subjectController.text;
      final description = _descriptionController.text;
      final category = _selectedCategory ?? 'Other';

      setState(() {
        _allComplaints.add({
          'name': name,
          'email': email,
          'subject': subject,
          'description': description,
          'status': 'Submitted'
        });
        _filteredComplaints = List.from(_allComplaints);
        _applyFilters();
        _nameController.clear();
        _emailController.clear();
        _subjectController.clear();
        _descriptionController.clear();
        _selectedCategory = null;
        _tabController.animateTo(1); // Switch to the 'Your Complaints' tab
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Complaint submitted successfully!')),
      );
    }
  }

  void _applyFilters() {
    setState(() {
      _filteredComplaints = List.from(_allComplaints);
      if (_selectedStatusFilter != null && _selectedStatusFilter != 'All') {
        _filteredComplaints = _filteredComplaints.where((complaint) => complaint['status']?.toLowerCase() == _selectedStatusFilter?.toLowerCase()).toList();
      }
      // Add sorting logic here if needed
      _filteredComplaints.sort((a, b) => a['status']?.compareTo(b['status'] ?? '') ?? 0); // Sort by status alphabetically as a basic example
    });
  }

  void _changeStatusFilter(String? newStatus) {
    setState(() {
      _selectedStatusFilter = newStatus;
      _applyFilters();
    });
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange.shade400;
      case 'resolved':
        return Colors.green.shade400;
      case 'in progress':
        return Colors.blue.shade400;
      case 'acknowledged':
        return Colors.purple.shade400;
      case 'submitted':
        return Colors.grey.shade600;
      default:
        return Colors.black;
    }
  }

  @override
  void dispose() {
    _tabController.dispose();
    _nameController.dispose();
    _emailController.dispose();
    _subjectController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  Widget _buildComplaintForm() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Form(
        key: _formKey,
        child: Column(
          children: <Widget>[
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Your Name',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your name';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(
                labelText: 'Your Email',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty || !value.contains('@')) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _subjectController,
              decoration: const InputDecoration(
                labelText: 'Subject',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the subject of your complaint';
                }
                return null;
              },
            ),
            const SizedBox(height: 16.0),
            DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Category',
                border: OutlineInputBorder(),
              ),
              value: _selectedCategory,
              items: _complaintCategories.map((String category) {
                return DropdownMenuItem<String>(
                  value: category,
                  child: Text(category),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCategory = newValue;
                });
              },
            ),
            const SizedBox(height: 16.0),
            TextFormField(
              controller: _descriptionController,
              maxLines: 5,
              decoration: const InputDecoration(
                labelText: 'Description',
                border: OutlineInputBorder(),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter the details of your complaint';
                }
                return null;
              },
            ),
            const SizedBox(height: 24.0),
            ElevatedButton(
              onPressed: _submitComplaint,
              child: const Text('Submit Complaint'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildComplaintList() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const Text('Filter by Status:'),
              const SizedBox(width: 8.0),
              DropdownButton<String>(
                value: _selectedStatusFilter,
                items: _statusFilters.map((String status) {
                  return DropdownMenuItem<String>(
                    value: status,
                    child: Text(status),
                  );
                }).toList(),
                onChanged: _changeStatusFilter,
              ),
            ],
          ),
        ),
        Expanded(
          child: _filteredComplaints.isEmpty
              ? const Center(child: Text('No complaints found with the selected filters.'))
              : ListView.builder(
                  itemCount: _filteredComplaints.length,
                  itemBuilder: (context, index) {
                    final complaint = _filteredComplaints[index];
                    final statusColor = _getStatusColor(complaint['status'] ?? '');
                    return Card(
                      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                      shape: RoundedRectangleBorder(
                        side: BorderSide(color: statusColor, width: 1.5),
                        borderRadius: BorderRadius.circular(4.0),
                      ),
                      child: ExpansionTile(
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              complaint['subject'] ?? 'Subject Unavailable',
                              style: const TextStyle(fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              'Status: ${complaint['status'] ?? 'Status Unavailable'}',
                              style: TextStyle(color: statusColor, fontWeight: FontWeight.w500),
                            ),
                          ],
                        ),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                _buildDetailRow('Name', complaint['name']),
                                _buildDetailRow('Email', complaint['email']),
                                const SizedBox(height: 8.0),
                                const Text('Description:', style: TextStyle(fontWeight: FontWeight.bold)),
                                Text(complaint['description'] ?? 'No description provided.'),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Submit Complaint'),
            Tab(text: 'Your Complaints'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildComplaintForm(),
          _buildComplaintList(),
        ],
      ),
    );
  }
}