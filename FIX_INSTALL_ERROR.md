# Fix: Failed to Install App (Error 3002)

## Solution 1: Enable Developer Mode (Most Common Fix)

If you're running iOS 16 or later, you need to enable Developer Mode:

1. **On your iPhone:**
   - Go to **Settings** → **Privacy & Security**
   - Scroll down and look for **"Developer Mode"**
   - Toggle **Developer Mode** ON
   - Your iPhone will restart (or prompt to restart)

2. **After restart:**
   - You'll see a prompt asking to enable Developer Mode
   - Tap **"Turn On"**
   - Enter your passcode to confirm

3. **Try again in Xcode:**
   - Build and run again (`Cmd + R`)
   - The app should install now

## Solution 2: Check Device Trust

1. **On your iPhone:**
   - Settings → General → VPN & Device Management (or Device Management)
   - Verify your Mac/Developer certificate is trusted

2. **On your Mac:**
   - Make sure you've trusted the computer when connected
   - Try disconnecting and reconnecting the USB cable

## Solution 3: Clean Build

1. **In Xcode:**
   - Product → Clean Build Folder (`Shift + Cmd + K`)
   - Delete derived data: Xcode → Settings → Locations → Derived Data → Delete folder
   - Or run in terminal: `rm -rf ~/Library/Developer/Xcode/DerivedData/DailyTrackerApp-*`

2. **Rebuild:**
   - Try building again

## Solution 4: Check Signing

1. **In Xcode:**
   - Project settings → Signing & Capabilities
   - Ensure "Automatically manage signing" is checked
   - Select your Apple ID team
   - Check that Bundle Identifier is unique (should be `com.dailytracker.app`)

## Solution 5: Restart Everything

1. Disconnect iPhone
2. Quit Xcode completely
3. Restart Xcode
4. Reconnect iPhone
5. Unlock iPhone
6. Try again

## Solution 6: Check iOS Version Compatibility

Make sure your iPhone is running iOS 17.0 or later (as specified in the project settings).

If it's running an older version, you may need to:
- Update your iPhone to iOS 17.0+
- Or update the deployment target in Xcode project settings

---

**Most likely fix:** Enable Developer Mode in Settings → Privacy & Security → Developer Mode

