# Recording Function Error - Debugging Guide

## Current Status
App launches on simulator, but recording function throws an error.

## Quick Debugging Steps

### 1. Check Xcode Console
When you try to record, check the Xcode console (bottom panel) for:
- Error messages
- Permission denials
- Audio session errors

### 2. Verify Permissions in Info.plist
Ensure these are present:
- `NSMicrophoneUsageDescription`
- `NSSpeechRecognitionUsageDescription`

### 3. Common Issues & Solutions

#### Issue: "Microphone permission denied"
**Solution**: 
- Check Settings → Privacy & Security → Microphone
- Make sure app has permission

#### Issue: Simulator microphone not working
**Solution**: 
- Simulator may not have microphone access
- Try: Simulator menu → I/O → Keyboard → Enable "Connect Hardware Keyboard" (may help)
- **Best solution**: Test on physical iPhone device

#### Issue: Audio session errors
**Solution**: 
- Check RecordingService.swift audio session setup
- May need to configure AVAudioSession properly

#### Issue: Speech recognition not available
**Solution**:
- Check if speech recognition is authorized
- May require internet connection for first-time setup
- Check SpeechRecognitionService authorization status

### 4. Test Checklist

- [ ] Check Xcode console for specific error message
- [ ] Verify microphone permission is granted
- [ ] Verify speech recognition permission is granted
- [ ] Try on physical device (not simulator)
- [ ] Check if audio session is configured correctly
- [ ] Verify AVAudioRecorder initialization

## Key Files to Review

1. **RecordingView.swift** - Lines ~70-120 (startRecording, stopRecording methods)
2. **RecordingService.swift** - Audio recording implementation
3. **SpeechRecognitionService.swift** - Speech recognition setup
4. **Info.plist** - Permission descriptions

## Recommended Next Steps

1. **Copy the exact error message** from Xcode console
2. **Share the error** so we can fix it specifically
3. **Try on physical device** if simulator has limitations
4. **Check permissions** are properly requested

The error details will help pinpoint the exact issue!

