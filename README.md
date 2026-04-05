A new Flutter project.

## Getting Started

This project is a starting point for a Flutter application.

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

# Sign in Screen 
<img width="326" height="704" alt="image" src="https://github.com/user-attachments/assets/a31fb025-fdfe-4bbe-9adb-07228e8e4373" />

# Sign up Screen 
<img width="320" height="705" alt="image" src="https://github.com/user-attachments/assets/b33eaaff-bb2b-4127-8125-7e743411ba62" />
