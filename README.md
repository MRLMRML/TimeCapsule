# Time Capsule

A simple cross-platform app to send messages to your future self. Built with Flutter.

## Features

- 📝 Write personal messages to your future self
- 🔒 Lock messages until a specific date and time
- 🔔 Receive notifications when capsules are ready
- 🎨 Beautiful Material 3 design
- 📱 Works on iOS, Android, and Web

## Tech Stack

- **Flutter** - Cross-platform UI framework
- **Dart** - Programming language
- **Hive** - Lightweight local database
- **Provider** - State management
- **WorkManager** - Background task scheduling
- **GoRouter** - Declarative navigation
- **Flutter Local Notifications** - Push notifications

## Project Structure

```
lib/
├── data/
│   └── local/              # Database (Hive)
├── domain/
│   ├── model/              # Data models
│   └── repository/          # Repository interfaces & implementations
├── presentation/
│   ├── components/         # Reusable UI components
│   ├── navigation/         # Router configuration
│   ├── screens/            # App screens
│   ├── theme/              # App theming
│   └── viewmodel/          # ViewModels
├── utils/                  # Utility classes
└── workers/               # Background workers
```

## Getting Started

### Prerequisites

- Flutter SDK 3.0+
- Dart 3.0+
- Android Studio / VS Code

### Installation

1. **Clone the repository**
   ```bash
   git clone https://github.com/MRLMRML/TimeCapsule.git
   cd TimeCapsule
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Generate Hive adapters**
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run on your device/emulator**
   ```bash
   flutter run
   ```

## Building for Release

### Android
```bash
flutter build apk --release
```

### iOS
```bash
flutter build ios --release
```

### Web
```bash
flutter build web
```

## Architecture

This app follows Clean Architecture principles:

### Domain Layer
- **Models**: Data classes (TimeCapsule)
- **Repository**: Abstract interfaces for data access

### Data Layer
- **Hive**: Local NoSQL database
- **Repository Implementation**: Concrete data access

### Presentation Layer
- **Provider**: State management
- **Material 3**: Modern declarative UI
- **GoRouter**: Type-safe navigation

## Permissions

### iOS
Add to `ios/Runner/Info.plist`:
```xml
<key>NSUserNotificationUsageDescription</key>
<string>We need this to notify you when your capsule is ready.</string>
```

### Android
Add to `android/app/src/main/AndroidManifest.xml`:
```xml
<uses-permission android:name="android.permission.POST_NOTIFICATIONS" />
<uses-permission android:name="android.permission.RECEIVE_BOOT_COMPLETED" />
<uses-permission android:name="android.permission.SCHEDULE_EXACT_ALARM" />
<uses-permission android:name="android.permission.USE_EXACT_ALARM" />
<uses-permission android:name="android.permission.VIBRATE" />
<uses-permission android:name="android.permission.WAKE_LOCK" />
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - feel free to use and modify for your own projects!
