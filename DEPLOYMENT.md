# Deployment Guide - Daily Tracker App

## Quick Start: Deploy to Your iPhone (Free)

### Prerequisites

1. **Mac with Xcode installed**
   - Download Xcode from the Mac App Store (free)
   - Minimum version: Xcode 15.0

2. **iPhone**
   - iOS 17.0 or later
   - Connected via USB or same WiFi network

3. **Apple ID** (free)
   - You can use any Apple ID you already have

### Step-by-Step Deployment

#### Step 1: Open Project in Xcode

```bash
cd /Users/ankurgulati/work/projects/daily_tracker_app
open DailyTrackerApp.xcodeproj
```

Or simply double-click `DailyTrackerApp.xcodeproj` in Finder.

#### Step 2: Configure Signing

1. In Xcode, click on the project name "DailyTrackerApp" in the left navigator
2. Select the "DailyTrackerApp" target
3. Click on the "Signing & Capabilities" tab
4. Check "Automatically manage signing"
5. Select your Apple ID from the "Team" dropdown
   - If you don't see your Apple ID, click "Add Account..." and sign in
6. Xcode will automatically create a provisioning profile

#### Step 3: Connect Your iPhone

1. Connect your iPhone to your Mac via USB cable
2. Unlock your iPhone
3. If prompted "Trust This Computer?", tap "Trust"
4. Enter your iPhone passcode if prompted

#### Step 4: Select Your iPhone as Build Target

1. At the top of Xcode, click the device selector (next to the Run button)
2. Select your iPhone from the list of available devices
   - It should show as "[Your Name]'s iPhone"

#### Step 5: Build and Run

1. Click the Run button (▶️) or press `Cmd + R`
2. Xcode will build the app (first build may take a few minutes)
3. The app will automatically install on your iPhone

#### Step 6: Trust the Developer Certificate (First Time Only)

1. On your iPhone, open Settings
2. Go to General → VPN & Device Management (or Device Management)
3. Tap on your Apple ID under "Developer App"
4. Tap "Trust [Your Apple ID]"
5. Tap "Trust" to confirm

#### Step 7: Launch the App

1. Find the "DailyTrackerApp" icon on your iPhone home screen
2. Tap to open
3. Grant microphone and speech recognition permissions when prompted

### Troubleshooting

#### "No signing certificate found"

**Solution**: Make sure "Automatically manage signing" is checked and you've selected your Apple ID team.

#### "Unable to install DailyTrackerApp"

**Solution**: 
- Make sure your iPhone is unlocked
- Check that you've trusted the developer certificate (Step 6)
- Try disconnecting and reconnecting your iPhone

#### "Developer Mode is disabled"

**Solution** (iOS 16+):
1. On iPhone: Settings → Privacy & Security → Developer Mode
2. Toggle Developer Mode ON
3. Restart iPhone if prompted
4. Reconnect and try again

#### Build Errors

**Solution**:
- Clean build folder: Product → Clean Build Folder (Cmd + Shift + K)
- Restart Xcode
- Ensure you're using the latest Xcode version

#### App Expires After 7 Days

**Solution**: This is normal for free developer accounts. Simply:
1. Reconnect iPhone to Mac
2. Build and run again (Cmd + R)
3. This will re-sign the app for another 7 days

### Keeping the App Running

With a free Apple Developer account, apps expire after 7 days. To keep using the app:

1. **Option A**: Build and run again every 7 days (takes 1 minute)
2. **Option B**: Upgrade to paid Apple Developer Program ($99/year) for 1-year signing

### Building for Distribution (Optional)

If you want to share with others or install on multiple devices:

1. In Xcode: Product → Archive
2. Once archived: Window → Organizer
3. Select your archive
4. Click "Distribute App"
5. Choose "Development" for testing, or "App Store Connect" for App Store

### Alternative: Build via Command Line

```bash
# Build for device
xcodebuild -project DailyTrackerApp.xcodeproj \
  -scheme DailyTrackerApp \
  -configuration Debug \
  -destination 'platform=iOS,name=[Your iPhone Name]' \
  -allowProvisioningUpdates

# Or build and install directly
xcodebuild -project DailyTrackerApp.xcodeproj \
  -scheme DailyTrackerApp \
  -destination 'platform=iOS,name=[Your iPhone Name]' \
  -allowProvisioningUpdates \
  install
```

## Testing Checklist

After deployment, test these features:

- [ ] Record a food entry (e.g., "I ate 2 rotis with dal")
- [ ] Record a workout entry (e.g., "Ran for 30 minutes")
- [ ] View entries in History tab
- [ ] Check statistics for today
- [ ] View weekly/monthly statistics
- [ ] Update settings (weight, age, etc.)
- [ ] Test with different foods and workouts
- [ ] Verify data persists after app restart

## Next Steps

1. **Customize Foods**: Edit `FoodDatabaseService.swift` to add more foods
2. **Adjust Parsing**: Modify `FoodParser.swift` and `WorkoutParser.swift` to improve recognition
3. **Add Features**: Extend functionality based on your needs

## Support

If you encounter issues:
1. Check Xcode console for error messages
2. Verify all permissions are granted
3. Ensure iOS version is 17.0 or later
4. Try a clean build (Cmd + Shift + K)

Enjoy tracking your daily food and workouts!

