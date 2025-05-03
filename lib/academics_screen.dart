import 'package:flutter/material.dart';

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

class _CoursesTab extends StatelessWidget {
  const _CoursesTab();

  final List<Map<String, String>> _courses = const [
    {'code': 'CS101', 'name': 'Introduction to Computer Science'},
    {'code': 'MA101', 'name': 'Calculus I'},
    {'code': 'PH101', 'name': 'Physics I'},
    {'code': 'EN101', 'name': 'English Composition'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _courses.length,
      itemBuilder: (context, index) {
        final course = _courses[index];
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
}

class _AttendanceTab extends StatefulWidget {
  const _AttendanceTab();

  @override
  State<_AttendanceTab> createState() => _AttendanceTabState();
}

class _AttendanceTabState extends State<_AttendanceTab> {
  final Map<String, double> _attendance = {
    'CS101': 0.85,
    'MA101': 0.92,
    'PH101': 0.78,
    'EN101': 0.88,
  };

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _attendance.length,
      itemBuilder: (context, index) {
        final courseCode = _attendance.keys.elementAt(index);
        final percentage = _attendance.values.elementAt(index);
        return Card(
          margin: const EdgeInsets.all(8.0),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(courseCode, style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4.0),
                Text('Attendance: ${(percentage * 100).toStringAsFixed(1)}%'),
                const SizedBox(height: 8.0),
                LinearProgressIndicator(value: percentage),
              ],
            ),
          ),
        );
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
  final Map<String, Map<String, List<String>>> _courseSyllabi = const {
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

  List<String> get _courseNames => _courseSyllabi.keys.toList();

  Map<String, List<String>>? get _selectedSyllabus => _selectedCourse != null ? _courseSyllabi[_selectedCourse] : null;

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
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: unitTopics
                              .map((topic) => Padding(
                            padding: const EdgeInsets.symmetric(vertical: 4.0),
                            child: Text('- $topic'),
                          ))
                              .toList(),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ] else if (_selectedCourse != null) ...[
            const Text('Syllabus for this course is not available yet.', style: TextStyle(fontStyle: FontStyle.italic)),
          ] else ...[
            const Text('Please select a course to view its syllabus.', style: TextStyle(fontStyle: FontStyle.italic)),
          ],
        ],
      ),
    );
  }
}

