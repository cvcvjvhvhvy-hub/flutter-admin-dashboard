# Admin Dashboard (Flutter Android)

This is a standalone Flutter admin dashboard for Android. 

Quick start:

```bash
cd dashboard_app
flutter pub get
flutter run
```

Notes:
- The data layer is a simple in-memory `MockService` (no backend).
- Pages: Users, Content, Notifications.
- Use Material design; localize/RTL as needed.

Build APK:

```bash
cd dashboard_app
flutter pub get
flutter build apk --release
# The APK file is in build/app/outputs/flutter-apk/app-release.apk
```

