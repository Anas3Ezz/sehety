# fire_project

A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.

## Firebase Setup

This project uses Firebase for backend services. To set up Firebase:

1. Create a Firebase project at [Firebase Console](https://console.firebase.google.com/)
2. Enable the required Firebase services (Authentication, Firestore, etc.)
3. Add your Flutter app to the Firebase project
4. Download the configuration files:
   - `google-services.json` for Android (place in `android/app/`)
   - `GoogleService-Info.plist` for iOS (place in `ios/Runner/`)
5. Generate the Firebase options file:
   ```bash
   flutterfire configure --project=YOUR_PROJECT_ID
   ```
   Or create `lib/firebase_options.dart` manually with your Firebase configuration.

**Note**: Firebase configuration files (`lib/firebase_options.dart`, `android/app/google-services.json`, `ios/Runner/GoogleService-Info.plist`) are ignored by Git for security reasons. Each developer must set up their own Firebase configuration.
