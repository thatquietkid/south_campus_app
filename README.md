# South Campus App (Flutter Frontend)

&#x20;&#x20;

This is the Flutter frontend for the **South Campus App** (University of Delhi). It interacts with a Go backend and presents a mobile interface for students to access academic info, cafeteria menus, event updates, bus schedules, hostel details, and more.

> \[!NOTE] The app fetches real-time data from a live backend hosted on [Render](https://render.com). Backend API: [https://south-campus-backend.onrender.com](https://south-campus-backend.onrender.com)

---

## 🚀 Features

* 📚 View Courses & Syllabus
* 🧮 Check Attendance (dynamic)
* 🥪 Cafeteria Menu (dynamic)
* 🚌 Bus Routes with schedule (dynamic)
* 🏨 Hostel Info (dynamic)
* 📅 Events Feed (dynamic)
* 🛠️ Submit Facility Complaints

---

## 📁 Project Structure

```
south_campus_app/
├── lib/
│   ├── main.dart            # Entry point
│   ├── screens/             # Screens (Academics, Cafeteria, Transport, etc.)
│   ├── models/              # Dart data models
│   ├── services/            # API calls and network layer
│   ├── widgets/             # Reusable components
├── assets/                  # App icons, fonts, etc.
├── pubspec.yaml             # Project dependencies
└── README.md                # Project documentation
```

---

## 🧑‍💻 Getting Started

### 1. Clone the Repo

```bash
git clone https://github.com/thatquietkid/south_campus_app.git
cd south_campus_app
```

### 2. Install Dependencies

```bash
flutter pub get
```

### 3. Run the App

```bash
flutter run
```

Make sure a device or emulator is connected.

---

## 🌐 API Integration

The app uses `http` package to fetch data from:

* `/courses`
* `/cafeteria-items`
* `/bus-routes`
* `/events`
* `/complaints` (GET & POST)

These are consumed using custom service classes under `lib/services/`.

---

## 🔒 Authentication

Authentication is handled in the backend using JWT. Future versions of the app may include login flows for admin-only actions (e.g. adding cafeteria items).

---

## 📄 License

[MIT License](LICENSE)

---

## Built by [@thatquietkid](https://github.com/thatquietkid/)
