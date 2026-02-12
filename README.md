# Time Capsule

A simple Android app that lets you write messages to your future self. Set a time, lock it away, and receive your message when the time comes.

## Features

- 📝 Write personal messages to your future self
- 🔒 Lock messages until a specific date and time
- 🔔 Receive notifications when capsules are ready
- 🎨 Beautiful Material 3 design with Jetpack Compose

## Tech Stack

- **Kotlin** - Modern, expressive programming language
- **Jetpack Compose** - Declarative UI framework
- **Room Database** - Local data persistence
- **WorkManager** - Reliable background scheduling
- **Clean Architecture** - Separation of concerns
- **MVVM** - Modern app architecture pattern

## Project Structure

```
app/src/main/java/com/timecapsule/app/
├── data/
│   ├── local/
│   │   ├── dao/          # Data Access Objects
│   │   ├── database/     # Room database
│   │   └── entity/       # Database entities
│   └── repository/       # Repository implementations
├── domain/
│   ├── model/           # Domain models
│   ├── repository/      # Repository interfaces
│   └── usecase/         # Business logic
├── presentation/
│   ├── ui/
│   │   ├── components/   # Reusable UI components
│   │   ├── navigation/  # Navigation setup
│   │   ├── screens/     # App screens
│   │   └── theme/       # Material 3 theme
│   └── viewmodel/       # ViewModels
├── util/                # Utility classes
└── worker/              # WorkManager workers
```

## Building the App

### Prerequisites

- Android Studio Hedgehog or later
- JDK 17 or later
- Android SDK 34 or later

### Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd TimeCapsule
   ```

2. **Open in Android Studio**
   - Open Android Studio
   - Select "Open an existing project"
   - Navigate to the TimeCapsule folder

3. **Build the project**
   - Go to `Build > Make Project`
   - Or run `./gradlew build` from the terminal

4. **Run on device/emulator**
   - Connect a device or start an emulator
   - Click the "Run" button in Android Studio
   - Or run `./gradlew installDebug`

## GitHub Setup

To push this project to GitHub:

```bash
# Create a new repository on GitHub (via web interface)

# Add remote and push
git remote add origin https://github.com/YOUR_USERNAME/TimeCapsule.git
git branch -M main
git push -u origin main
```

## Architecture

This app follows Clean Architecture principles:

### Domain Layer
- Contains business logic and models
- Independent of other layers
- Defines interfaces for data access

### Data Layer
- Implements repository interfaces
- Manages local database with Room
- Converts between entities and domain models

### Presentation Layer
- Handles UI with Jetpack Compose
- Manages state with ViewModels
- Navigates between screens

## Permissions

The app requires the following permissions:

- **POST_NOTIFICATIONS** - To alert you when capsules are ready
- **RECEIVE_BOOT_COMPLETED** - To reschedule notifications after device restart
- **SCHEDULE_EXACT_ALARM** - For precise notification timing

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

MIT License - feel free to use and modify for your own projects!
