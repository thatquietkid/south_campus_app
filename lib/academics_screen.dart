import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class AcademicsScreen extends StatefulWidget {
  const AcademicsScreen({super.key});

  @override
  State<AcademicsScreen> createState() => _AcademicsScreenState();
}

class _AcademicsScreenState extends State<AcademicsScreen> with TickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Academics'),
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(text: 'Courses'),
            Tab(text: 'Attendance'),
            Tab(text: 'Syllabus'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CoursesTab(),
          _AttendanceTab(),
          _SyllabusTab(),
        ],
      ),
    );
  }
}

class DataStore {
  // Attendance data will now be fetched from the API
  static const syllabi = {
    'Introduction to Computer Science': {
      'Unit 1: Basics of Computing': ['Introduction to computers', 'Hardware and Software', 'Operating Systems'],
      'Unit 2: Programming Fundamentals': ['Data types', 'Control structures', 'Functions'],
      'Unit 3: Object-Oriented Programming': ['Classes and objects', 'Inheritance', 'Polymorphism'],
      'Unit 4: Data Structures': ['Arrays', 'Linked lists', 'Stacks and Queues'],
      'Unit 5: Algorithms': ['Sorting', 'Searching', 'Basic algorithm analysis'],
    },
    'Calculus I': {
      'Unit 1: Limits and Continuity': ['Definition of a limit', 'Limit laws', 'Continuity'],
      'Unit 2: Derivatives': ['Definition of the derivative', 'Differentiation rules', 'Chain rule'],
      'Unit 3: Applications of Derivatives': ['Rates of change', 'Optimization', 'Related rates'],
      'Unit 4: Integrals': ['Definite and indefinite integrals', 'Fundamental Theorem of Calculus'],
      'Unit 5: Techniques of Integration': ['Substitution', 'Integration by parts'],
    },
    'Physics I': {
      'Unit 1: Mechanics': ['Kinematics', 'Newton\'s laws of motion', 'Work and energy'],
      'Unit 2: Waves and Oscillations': ['Simple harmonic motion', 'Wave properties', 'Superposition'],
      'Unit 3: Thermodynamics': ['Heat and temperature', 'First law of thermodynamics', 'Entropy'],
      'Unit 4: Electromagnetism': ['Electric fields', 'Magnetic fields', 'Electromagnetic induction'],
      'Unit 5: Optics': ['Reflection and refraction', 'Lenses and mirrors', 'Interference and diffraction'],
    },
    'English Composition': {
      'Unit 1: Introduction to Academic Writing': ['Purpose and audience', 'Thesis statements', 'Essay structure'],
      'Unit 2: Research and Citation': ['Finding sources', 'Evaluating sources', 'MLA and APA styles'],
      'Unit 3: Argumentative Writing': ['Developing arguments', 'Counterarguments', 'Persuasive techniques'],
      'Unit 4: Narrative Writing': ['Plot and character development', 'Point of view', 'Descriptive language'],
      'Unit 5: Literary Analysis': ['Interpreting texts', 'Identifying themes', 'Analyzing literary devices'],
    },
  };
}

class _CoursesTab extends StatefulWidget {
  const _CoursesTab();

  @override
  State<_CoursesTab> createState() => _CoursesTabState();
}

class _CoursesTabState extends State<_CoursesTab> {
  late Future<List<Map<String, dynamic>>> _coursesFuture;

  Future<List<Map<String, dynamic>>> _fetchCourses() async {
    final url = Uri.parse('https://south-campus-backend.onrender.com/courses');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) {
        return {
          'code': item['code'] ?? '',
          'name': item['title'] ?? '',
        };
      }).toList();
    } else {
      throw Exception('Failed to load courses');
    }
  }

  @override
  void initState() {
    super.initState();
    _coursesFuture = _fetchCourses();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _coursesFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No courses available.'));
        } else {
          final courses = snapshot.data!;
          return ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(course['name'] ?? 'Course Name Unavailable',
                          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4.0),
                      Text('Code: ${course['code'] ?? 'Code Unavailable'}'),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class _AttendanceTab extends StatefulWidget {
  const _AttendanceTab();

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
  late Future<List<Map<String, dynamic>>> _attendanceFuture;

  Future<List<Map<String, dynamic>>> _fetchAttendance() async {
    final url = Uri.parse('https://south-campus-backend.onrender.com/course-attendance');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final List<dynamic> data = json.decode(response.body);
      return data.map((item) {
        return {
          'code': item['code'] ?? '',
          'title': item['title'] ?? '',
          'attendance_percentage': item['attendance_percentage'] as double? ?? 0.0,
        };
      }).toList();
    } else {
      throw Exception('Failed to load attendance data');
    }
  }

  Color _getColor(double percentage) {
    if (percentage >= 0.9) return Colors.green;
    if (percentage >= 0.75) return Colors.orange;
    return Colors.red;
  }

  @override
  void initState() {
    super.initState();
    _attendanceFuture = _fetchAttendance();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: _attendanceFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text('No attendance data available.'));
        } else {
          final attendanceData = snapshot.data!;
          return ListView.builder(
            itemCount: attendanceData.length,
            itemBuilder: (context, index) {
              final attendance = attendanceData[index];
              final code = attendance['code'];
              final title = attendance['title'];
              final percentage = attendance['attendance_percentage'] as double;
              return Card(
                margin: const EdgeInsets.all(8.0),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(title ?? code ?? 'Course', style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 4.0),
                      Text('Code: $code'),
                      const SizedBox(height: 4.0),
                      Text('Attendance: ${(percentage * 100).toStringAsFixed(1)}%'),
                      const SizedBox(height: 8.0),
                      LinearProgressIndicator(value: percentage, color: _getColor(percentage)),
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

class _SyllabusTab extends StatefulWidget {
  const _SyllabusTab();

  @override
  State<_SyllabusTab> createState() => _SyllabusTabState();
}

class _SyllabusTabState extends State<_SyllabusTab> {
  String? _selectedCourse;

  List<String> get _courseNames => DataStore.syllabi.keys.toList();

  Map<String, List<String>>? get _selectedSyllabus =>
      _selectedCourse != null ? DataStore.syllabi[_selectedCourse] : null;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          DropdownButtonFormField<String>(
            decoration: const InputDecoration(
              labelText: 'Select a Course',
              border: OutlineInputBorder(),
            ),
            value: _selectedCourse,
            items: _courseNames.map((course) {
              return DropdownMenuItem<String>(
                value: course,
                child: Text(course),
              );
            }).toList(),
            onChanged: (String? newValue) {
              setState(() {
                _selectedCourse = newValue;
              });
            },
          ),
          const SizedBox(height: 16.0),
          if (_selectedSyllabus != null) ...[
            const Text(
              'Syllabus:',
              style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8.0),
            ListView.builder(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _selectedSyllabus!.length,
              itemBuilder: (context, index) {
                final unitTitle = _selectedSyllabus!.keys.elementAt(index);
                final unitTopics = _selectedSyllabus!.values.elementAt(index);
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  child: ExpansionTile(
                    title: Text(unitTitle, style: const TextStyle(fontWeight: FontWeight.bold)),
                    children: unitTopics
                        .map((topic) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 16.0),
                      child: Text('- $topic'),
                    ))
                        .toList(),
                  ),
                );
              },
            ),
          ] else if (_selectedCourse != null) ...[
            const Text('Syllabus for this course is not available yet.',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ] else ...[
            const Text('Please select a course to view its syllabus.',
                style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}