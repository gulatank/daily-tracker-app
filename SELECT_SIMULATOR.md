# How to Select iPhone Simulator (NOT Mac!)

## The Problem

You're accidentally selecting a Mac simulator instead of an iPhone simulator. The error shows `"device_platform" = "com.apple.platform.macosx"` which means it's trying to run on Mac.

## Solution: Select iPhone Simulator

### Step 1: Find the Device Selector

In Xcode's top toolbar, look for the device selector dropdown (it's next to the Play/Stop buttons).

### Step 2: Select iPhone Simulator

1. **Click the device selector dropdown**
2. **Look for "iPhone" simulators** - they'll be listed under "iOS Simulator" or similar
3. **Select one of these:**
   - iPhone 17
   - iPhone 17 Pro
   - iPhone 17 Pro Max
   - iPhone 16
   - iPhone 15
   - etc.

### Step 3: Make Sure It's NOT These:

❌ **Don't select:**
- "My Mac" or "Mac" (any Mac)
- "Mac Catalyst" 
- Any device that says "Mac" in the name

✅ **DO select:**
- Anything that says "iPhone" in the name
- Under "iOS Simulator" section

### Step 4: Build and Run

1. Clean build: `Shift + Cmd + K`
2. Build and run: `Cmd + R`
3. The iPhone Simulator app should open
4. Your app should install and launch

## Visual Guide

```
[Xcode Toolbar]
[▶️] [⏹]  [Device Selector ▼]
            ├─ iPhone 17 ✅ SELECT THIS
            ├─ iPhone 17 Pro ✅ OR THIS
            ├─ iPhone 17 Pro Max ✅ OR THIS
            ├─ My Mac ❌ NOT THIS
            └─ iPad... ❌ NOT THIS (unless you want iPad)
```

## If You Don't See iPhone Simulators

1. In Xcode: **Xcode → Settings → Platforms** (or Components)
2. Make sure iOS simulators are installed
3. Or: **Xcode → Window → Devices and Simulators**
4. Click "+" to add an iPhone simulator if needed

## Quick Check

After selecting, the device selector should show something like:
- "iPhone 17" ✅
- NOT "My Mac" ❌

Try it now!

