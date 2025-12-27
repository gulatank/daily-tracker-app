# Daily Tracker App

A voice-based daily tracking app for iPhone that helps you record food intake and workouts using voice recordings. The app automatically converts your voice recordings into structured data with nutritional information and calorie calculations.

## Features

- **Voice Recording**: Record your food intake and workouts using natural language
- **Automatic Parsing**: Converts voice recordings into structured food and workout entries
- **Nutrition Tracking**: Tracks calories, macros (protein, carbs, fats), and micronutrients
- **Workout Tracking**: Calculates calories burnt based on activity type, duration, and intensity using MET values
- **Statistics**: View daily, weekly, monthly, yearly, and custom date range statistics
- **Local Storage**: All data is stored locally on your device (private and secure)
- **Indian Food Support**: Includes database of common Indian, Asian, and Western foods

## Requirements

- iOS 17.0 or later
- iPhone device (for testing)
- Xcode 15.0 or later
- macOS (for development)
- Free Apple Developer account (for device installation)

## Project Structure

```
DailyTrackerApp/
├── DailyTrackerAppApp.swift       # Main app entry point
├── Models/                         # Data models
│   ├── FoodEntry.swift
│   ├── WorkoutEntry.swift
│   ├── DailySummary.swift
│   ├── UserProfile.swift
│   └── DataModel.xcdatamodeld     # Core Data model
├── Services/                       # Business logic
│   ├── RecordingService.swift
│   ├── SpeechRecognitionService.swift
│   ├── FoodParser.swift
│   ├── WorkoutParser.swift
│   ├── FoodDatabaseService.swift
│   ├── WorkoutCalorieCalculator.swift
│   ├── StatisticsService.swift
│   └── CoreDataManager.swift
├── Views/                          # UI components
│   ├── RecordingView.swift
│   ├── HistoryView.swift
│   ├── StatisticsView.swift
│   ├── SettingsView.swift
│   └── Components/
│       ├── FoodEntryRow.swift
│       └── WorkoutEntryRow.swift
└── Resources/                      # Assets and resources
```

## Building the Project

### Option 1: Open in Xcode

1. Open the project in Xcode:
   ```bash
   open DailyTrackerApp.xcodeproj
   ```

2. Select your development team in the Signing & Capabilities section of the project settings

3. Connect your iPhone via USB or ensure it's on the same WiFi network

4. Select your iPhone as the build target

5. Click the Run button (▶️) or press `Cmd + R`

### Option 2: Command Line Build

1. Build the project:
   ```bash
   xcodebuild -project DailyTrackerApp.xcodeproj -scheme DailyTrackerApp -configuration Debug -sdk iphoneos CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO
   ```

2. For device installation, use Xcode's Archive and Distribute feature

## Free Deployment Options

### Option 1: Direct Device Installation (Recommended - Free)

1. **Create Free Apple Developer Account** (if you don't have one):
   - Go to https://developer.apple.com
   - Sign in with your Apple ID
   - Accept the developer agreement (free for personal use)

2. **Configure Signing in Xcode**:
   - Open the project in Xcode
   - Select the project in the navigator
   - Go to "Signing & Capabilities"
   - Check "Automatically manage signing"
   - Select your Apple ID team

3. **Install on Your iPhone**:
   - Connect iPhone via USB
   - Select your iPhone as the build target
   - Click Run (▶️)
   - On first launch, trust the developer certificate:
     - Settings → General → VPN & Device Management
     - Tap your developer certificate
     - Tap "Trust"

### Option 2: TestFlight (Free, but requires paid developer account)

If you have an Apple Developer Program membership ($99/year):
1. Archive the app in Xcode
2. Upload to TestFlight
3. Install via TestFlight app on your iPhone

### Option 3: Local Development Build (Free)

Same as Option 1 - just build and run directly from Xcode to your device. The app will stay on your device as long as you keep signing it (valid for 7 days, then re-sign).

## Permissions

The app requires the following permissions:
- **Microphone**: To record your voice entries
- **Speech Recognition**: To convert voice to text

These permissions are requested when you first use the recording feature.

## Usage

### Recording Food Entries

1. Tap the microphone button on the Record tab
2. Speak naturally, for example:
   - "I ate 2 rotis with dal"
   - "Had biryani for lunch"
   - "Ate a bowl of rice with curry"

3. Stop recording when done
4. Review the transcription
5. Tap "Save Entry" to save

### Recording Workout Entries

1. Tap the microphone button
2. Speak your workout, for example:
   - "Ran for 30 minutes"
   - "Did 45 minutes of weightlifting"
   - "Cycled for 1 hour at moderate intensity"

3. Stop recording and save

### Viewing Statistics

- Navigate to the Statistics tab
- Select a time period (Daily, Weekly, Monthly, Yearly, or Custom)
- View calories consumed, calories burnt, net calories, and macro breakdown
- See trends over time with charts

### Settings

- Configure your profile (age, gender, weight, height)
- View your BMR (Basal Metabolic Rate) and TDEE (Total Daily Energy Expenditure)
- Set your activity level

## Food Database

The app includes a local database of common foods:
- **Indian**: Roti, dal, rice, biryani, paneer, dosa, idli, sambar, curries, etc.
- **Asian**: Sushi, ramen, noodles, fried rice, pho, pad thai, dumplings, etc.
- **Western**: Pizza, pasta, burger, sandwich, salad, chicken, etc.

If a food is not found, it will be saved with 0 calories - you can edit it manually later.

## Workout Calorie Calculation

The app uses MET (Metabolic Equivalent of Task) values to calculate calories burnt:
- Formula: `Calories = MET × Weight(kg) × Duration(hours)`
- Supports various activities: running, cycling, swimming, gym workouts, yoga, etc.
- Accounts for intensity levels (low, moderate, high)

## Data Storage

- All data is stored locally using Core Data
- No data is sent to external servers
- Completely private and secure
- Data persists between app launches

## Troubleshooting

### Speech Recognition Not Working
- Check that speech recognition permission is granted
- Ensure device has internet connection (required for first-time setup)
- Try speaking more clearly and at a normal pace

### Microphone Not Working
- Check microphone permission in Settings
- Ensure no other apps are using the microphone
- Restart the app

### Food Not Recognized
- Try using more specific food names
- Include quantities (e.g., "2 rotis" instead of "some rotis")
- Check if the food is in the database, or it will be saved with 0 calories for manual editing

### Build Errors
- Ensure you're using Xcode 15.0 or later
- Check that your signing certificate is valid
- Clean build folder: Product → Clean Build Folder (Cmd + Shift + K)

## Future Enhancements

- Integration with USDA Food API for more comprehensive food database
- Support for more cuisines and foods
- Meal planning features
- Export data to CSV/JSON
- iCloud sync (optional)
- Apple Watch companion app
- Widget support

## License

This is a personal project. Feel free to modify and use as needed.

## Support

For issues or questions, check the code comments or modify the app to suit your needs.

