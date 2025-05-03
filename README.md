# South Campus App - University of Delhi

## Problem Statement

Design and develop a mobile application tailored for students, faculty, and visitors of the South Campus, University of Delhi. The app serves as a one-stop solution to access academic resources, navigate the campus, check transport and hostel details, view cafeteria menus, get event updates, and raise facility complaints — enhancing the day-to-day campus experience through digital integration.

## Description

The South Campus App is a mobile application designed to improve the campus experience for students, faculty, and visitors at the South Campus, University of Delhi.  It provides a centralized platform for accessing essential campus information and services, making it easier to navigate the campus and stay connected with campus life.

## Key Features

The app includes the following key features:

* **Academic Resources:** Access to course information, attendance records, and syllabus details.
* **Campus Navigation:** Interactive map and navigation tools to help users find their way around the South Campus.
* **Transport and Hostel Details:** Information on campus transportation options and hostel accommodations.
* **Cafeteria Menus:** View daily menus and information for campus cafeterias.
* **Event Updates:** Stay informed about upcoming campus events and activities.
* **Facility Complaints:** A system for users to submit and track facility-related complaints.

## Technologies Used

* **Frontend:**
    * Dart
    * Flutter
    * Android Studio

## Setup Instructions

To set up the project on your local machine, follow these steps:

1.  **Clone the Repository:**
    ```bash
    git clone <repository_url>  # Replace <repository_url> with the actual URL of your Git repository
    cd south_campus_app
    ```

2.  **Install Flutter:**
    * Ensure you have the Flutter SDK installed. If not, follow the official Flutter installation guide: [https://flutter.dev/docs/get-started/install](https://flutter.dev/docs/get-started/install)

3.  **Set up Android Studio:**
     * Install Android Studio: [https://developer.android.com/studio](https://developer.android.com/studio)
     * Configure an Android emulator or connect a physical Android device.

4.  **Install Dependencies:**
    ```bash
    flutter pub get
    ```

5.  **Run the App:**
    ```bash
    flutter run
    ```
    This command builds and runs the app on your connected Android device or emulator.

## Usage Instructions

* **Home Screen:** Provides an overview of the app's main features and navigation options.
* **Academics:** Access course details, attendance, and syllabus information.
* **Campus Navigation:** Use the interactive map to find locations on campus.
* **Transport & Hostel:** View details about transport and hostel facilities.
* **Cafeteria:** Check the menus of campus cafeterias.
* **Events:** Browse upcoming campus events.
* **Complaints:** Submit and track facility complaints.

## Project Structure

The project structure is organized as follows:

south_campus_app/
  lib/
    main.dart            # Entry point of the Flutter application
    screens/           # Directory containing the different screens of the app
      home_screen.dart     # Home screen widget
      academics_screen.dart  # Academics section widget
      navigation_screen.dart # Campus Navigation screen widget
      transport_hostel_screen.dart # Transport and Hostel details
      cafeteria_screen.dart   # Cafeteria Menu
      events_screen.dart    # Events Listing
      complaints_screen.dart # Complaints section
    models/            # Directory for data models
      course.dart        # Course data model
      attendance.dart    # Attendance data model
      syllabus.dart      # Syllabus data model
      event.dart         # Event data model
      complaint.dart     # Complaint data model
    widgets/           # Reusable widgets
      ...
  ...

## Contributing Guidelines

Contributions are welcome! To contribute to the project, please follow these guidelines:

1.  Fork the repository.
2.  Create a new branch for your feature or bug fix.
3.  Make your changes and commit them with clear and concise commit messages.
4.  Test your changes thoroughly.
5.  Submit a pull request to the `main` branch.

Please adhere to the existing coding style and conventions used in the project.

## License

This project is licensed under the [MIT License](LICENSE) - see the `LICENSE` file for details.

## Backend Information

* The app uses a REST API for data retrieval.
* Key endpoints include:
    * `GET /courses`: Retrieves all courses.
    * `GET /attendance/{userId}`: Retrieves attendance for a specific user.
    * `POST /complaints`: Submits a new facility complaint.
* The backend is built using [Specify your backend framework/language, e.g., Node.js with Express.js]
* The database used is [Specify your database, e.g., PostgreSQL].
* Authentication is handled using [Specify your authentication method, e.g., JWT].

---
