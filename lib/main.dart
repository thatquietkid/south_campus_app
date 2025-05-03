import 'package:flutter/material.dart';
import 'academics_screen.dart';
import 'navigation_screen.dart';
import 'transport_screen.dart';
import 'hostel_screen.dart';
import 'cafeteria_screen.dart';
import 'events_screen.dart';
import 'complaints_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'South Campus App',
      theme: ThemeData(
        primarySwatch: Colors.deepPurple,
      ),
      home: const SplashScreen(), // Start with splash screen
    );
  }
}

/// Simple splash screen with logo
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 2), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const HomePage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/images/logo.jpg', // Ensure this path is correct
          width: 150,
        ),
      ),
    );
  }
}

/// Main home screen
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      //   title: const Text('South Campus'),
        leading: Padding(
          padding: const EdgeInsets.all(8.0),
      //     child: Image.asset(
      //       'assets/images/logo.jpg', // AppBar logo
      //       fit: BoxFit.contain,
      //     ),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Center(
              child: Image.asset(
                'assets/images/logo.jpg',
                height: 100.0,
              ),
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Welcome to South Campus!',
              style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16.0),
            // TextField(
            //   decoration: InputDecoration(
            //     hintText: 'Search...',
            //     prefixIcon: const Icon(Icons.search),
            //     border: OutlineInputBorder(
            //       borderRadius: BorderRadius.circular(10.0),
            //     ),
            //   ),
            // ),
            const SizedBox(height: 24.0),
            GridView.count(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              children: <Widget>[
                _buildFeatureTile(context, 'Academics', Icons.book, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const AcademicsScreen()),
                  );
                }),
                _buildFeatureTile(context, 'Campus Navigation', Icons.map, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const NavigationScreen()),
                  );
                }),
                _buildFeatureTile(context, 'Transport', Icons.directions_bus, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const TransportScreen()),
                  );
                }),
                _buildFeatureTile(context, 'Hostel', Icons.hotel, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const HostelScreen()),
                  );
                }),
                _buildFeatureTile(context, 'Cafeteria', Icons.restaurant_menu, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const CafeteriaScreen()),
                  );
                }),
                _buildFeatureTile(context, 'Events', Icons.event, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const EventsScreen()),
                  );
                }),
                _buildFeatureTile(context, 'Complaints', Icons.report_problem, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const ComplaintsScreen()),
                  );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureTile(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return Card(
      elevation: 2.0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Icon(icon, size: 40.0, color: Theme.of(context).primaryColor),
            const SizedBox(height: 8.0),
            Text(
              title,
              style: const TextStyle(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
