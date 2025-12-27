# Testing Guide - Daily Tracker App

## Quick Start Testing

### 1. Build and Run in Simulator

**In Xcode:**
1. Select a simulator (e.g., iPhone 17) from the device selector at the top
2. Press `Cmd + R` or click the Play button
3. Wait for the app to build and launch

**Via Command Line:**
```bash
cd /Users/ankurgulati/work/projects/daily_tracker_app
xcodebuild -project DailyTrackerApp.xcodeproj \
  -scheme DailyTrackerApp \
  -configuration Debug \
  -sdk iphonesimulator \
  -destination 'platform=iOS Simulator,name=iPhone 17' \
  build
```

### 2. Test on Physical iPhone

**Prerequisites:**
- iPhone connected via USB
- Trusted the computer on iPhone
- Developer certificate configured in Xcode

**Steps:**
1. In Xcode, select your iPhone from the device selector
2. Press `Cmd + R` to build and run
3. On first launch, go to iPhone Settings → General → VPN & Device Management
4. Trust your developer certificate

## Testing Checklist

### ✅ Basic Functionality

- [ ] **App Launches**: App opens without crashing
- [ ] **Tab Navigation**: All 4 tabs work (Record, History, Statistics, Settings)
- [ ] **Permissions**: Microphone and Speech Recognition permissions are requested

### ✅ Recording View

- [ ] **Record Button**: Tap to start/stop recording
- [ ] **Voice Input**: Speak a food entry (e.g., "I ate 2 rotis with dal")
- [ ] **Transcription**: Text appears after recording stops
- [ ] **Save Entry**: Tap "Save Entry" button to save
- [ ] **Workout Entry**: Record a workout (e.g., "Ran for 30 minutes")

### ✅ Food Recognition

Test with various food phrases:
- [ ] "I ate 2 rotis with dal"
- [ ] "Had biryani for lunch"
- [ ] "Ate a bowl of rice"
- [ ] "I had pizza for dinner"
- [ ] "Ate some noodles"

### ✅ Workout Recognition

Test with various workout phrases:
- [ ] "Ran for 30 minutes"
- [ ] "Did 45 minutes of weightlifting"
- [ ] "Cycled for 1 hour"
- [ ] "Walked for 20 minutes"
- [ ] "Did yoga for 30 minutes"

### ✅ History View

- [ ] **Food Entries**: See saved food entries grouped by date
- [ ] **Workout Entries**: See saved workout entries grouped by date
- [ ] **Delete**: Swipe to delete entries
- [ ] **Refresh**: Pull down to refresh the list

### ✅ Statistics View

- [ ] **Daily Summary**: View today's statistics
- [ ] **Period Selection**: Switch between Daily/Weekly/Monthly/Yearly/Custom
- [ ] **Charts**: See calorie trends (if you have multiple days of data)
- [ ] **Macros**: View protein, carbs, fats breakdown

### ✅ Settings View

- [ ] **Profile**: Update age, weight, height
- [ ] **BMR/TDEE**: See calculated values
- [ ] **Activity Level**: Change activity level

## Common Test Scenarios

### Scenario 1: Record a Meal
1. Go to Record tab
2. Tap microphone button
3. Say: "I ate 2 rotis with dal"
4. Stop recording
5. Review transcription
6. Tap "Save Entry"
7. Check History tab - entry should appear

### Scenario 2: Record a Workout
1. Go to Record tab
2. Tap microphone button
3. Say: "Ran for 30 minutes at moderate intensity"
4. Stop recording
5. Review transcription
6. Tap "Save Entry"
7. Check History tab - workout should appear with calories burnt

### Scenario 3: View Statistics
1. Record a few food entries and workouts
2. Go to Statistics tab
3. Select "Daily" period
4. Verify calories consumed and burnt are shown
5. Switch to "Weekly" to see weekly averages

### Scenario 4: Update Profile
1. Go to Settings tab
2. Update weight to 75 kg
3. Check BMR and TDEE values update
4. Record a workout - calories should be calculated with new weight

## Troubleshooting

### App Crashes on Launch
- Check Console for error messages
- Verify Core Data model is properly added
- Clean build folder: `Shift + Cmd + K`

### Recording Not Working
- Check microphone permission in Settings
- Verify speech recognition permission
- Try speaking more clearly

### Food Not Recognized
- Try more specific phrases (include quantities)
- Check if food is in the database (see FoodDatabaseService.swift)
- Food will be saved with 0 calories if not found - you can edit manually later

### Build Errors
- Clean build folder: `Shift + Cmd + K`
- Delete derived data: `rm -rf ~/Library/Developer/Xcode/DerivedData/DailyTrackerApp-*`
- Restart Xcode

## Performance Testing

- [ ] **Multiple Entries**: Add 50+ entries and check performance
- [ ] **Statistics Calculation**: Test with 30+ days of data
- [ ] **Memory**: Check for memory leaks with Instruments

## Edge Cases

- [ ] **Empty Transcription**: What happens if speech recognition fails?
- [ ] **Invalid Food**: Food not in database
- [ ] **No Workout Duration**: Workout without time specified
- [ ] **Very Long Recording**: Test with 2+ minute recordings
- [ ] **Special Characters**: Test with food names containing special characters

## Next Steps After Testing

1. **Fix Issues**: Address any bugs found during testing
2. **Improve Parsing**: Add more food/workout patterns based on test results
3. **Expand Database**: Add more foods to FoodDatabaseService
4. **UI Polish**: Improve UI based on usage feedback

## Command Line Testing

You can also test specific components via command line:

```bash
# Build only (no run)
xcodebuild -project DailyTrackerApp.xcodeproj -scheme DailyTrackerApp build

# Run tests (if you add unit tests later)
xcodebuild test -project DailyTrackerApp.xcodeproj -scheme DailyTrackerApp

# Check for warnings
xcodebuild -project DailyTrackerApp.xcodeproj -scheme DailyTrackerApp build 2>&1 | grep warning
```

Happy Testing! 🎉

