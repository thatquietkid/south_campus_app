import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

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
  List<Map<String, String>> _complaints = [];
  // Store the original fetched complaints
  List<Map<String, dynamic>> _fetchedComplaints = []; // Change to dynamic
  String? _selectedStatusFilter;
  List<String> _statusFilters = ['All', 'Pending', 'Resolved', 'In Progress', 'Acknowledged', 'Submitted'];

  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _fetchComplaints();
  }

  Future<void> _fetchComplaints() async {
    try {
      final response = await http.get(Uri.parse('https://south-campus-backend.onrender.com/complaints'));

      if (response.statusCode == 200) {
        List<dynamic> fetchedComplaints = json.decode(response.body);
        setState(() {
          _fetchedComplaints = List<Map<String, dynamic>>.from(fetchedComplaints.map((complaint) { // Change to dynamic
            return {
              'name': complaint['name'],
              'email': complaint['email'],
              'subject': complaint['subject'],
              'description': complaint['description'],
              'status': complaint['status'],
            };
          }));
          // Initially, show all fetched complaints
          _complaints = _fetchedComplaints.map((e) => e.cast<String, String>()).toList();
        });
      } else {
        throw Exception('Failed to load complaints');
      }
    } catch (e) {
      print("Error fetching complaints: $e");
    }
  }

  Future<void> _submitComplaint() async {
    if (_formKey.currentState!.validate()) {
      final complaintData = {
        'name': _nameController.text,
        'email': _emailController.text,
        'subject': _subjectController.text,
        'description': _descriptionController.text,
        'status': 'Submitted', // Default status
      };

      try {
        final response = await http.post(
          Uri.parse('https://south-campus-backend.onrender.com/complaints'),
          headers: {'Content-Type': 'application/json'},
          body: json.encode(complaintData),
        );

        if (response.statusCode == 201) {
          // On success, reload complaints list
          _fetchComplaints();
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Complaint submitted successfully!')),
          );
        } else {
          throw Exception('Failed to submit complaint');
        }
      } catch (e) {
        print("Error submitting complaint: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to submit complaint')),
        );
      }

      // Clear the form after submission
      _nameController.clear();
      _emailController.clear();
      _subjectController.clear();
      _descriptionController.clear();
      setState(() {
        _selectedCategory = null;
      });
      _tabController.animateTo(1); // Switch to the 'Your Complaints' tab
    }
  }

  void _applyFilters() {
    setState(() {
      // Create a copy of the original fetched complaints
      List<Map<String, String>> filteredComplaints = _fetchedComplaints.map((e) => e.cast<String, String>()).toList();

      // Apply the status filter if a status is selected (and it's not "All")
      if (_selectedStatusFilter != null && _selectedStatusFilter != 'All') {
        filteredComplaints = filteredComplaints.where((complaint) {
          return complaint['status']?.toLowerCase() == _selectedStatusFilter?.toLowerCase();
        }).toList();
      }

      // Sort the filtered list
      filteredComplaints.sort((a, b) => a['status']?.compareTo(b['status'] ?? '') ?? 0);

      // Update the displayed complaints
      _complaints = filteredComplaints;
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
          child: _complaints.isEmpty
              ? const Center(child: Text('No complaints found with the selected filters.'))
              : ListView.builder(
            itemCount: _complaints.length,
            itemBuilder: (context, index) {
              final complaint = _complaints[index];
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
                          const SizedBox(height: 4.0),
                          Text(complaint['description'] ?? 'No description provided'),
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
    return Row(
      children: [
        Text('$label: ', style: const TextStyle(fontWeight: FontWeight.bold)),
        Text(value ?? 'N/A'),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Complaints'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _fetchComplaints,
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Submit a Complaint'),
            Tab(text: 'Your Complaints'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: <Widget>[
          _buildComplaintForm(), // Tab 1: Form for submitting complaints
          _buildComplaintList(), // Tab 2: List of complaints
        ],
      ),
    );
  }
}

