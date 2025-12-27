import SwiftUI
import AVFoundation

struct RecordingView: View {
    @StateObject private var recordingService = RecordingService()
    @StateObject private var speechService = SpeechRecognitionService()
    private let foodParser = FoodParser()
    private let workoutParser = WorkoutParser()
    
    @AppStorage("userWeight") private var userWeight: Double = 70.0
    
    @State private var transcriptionText = ""
    @State private var isProcessing = false
    @State private var recordingURL: URL?
    @State private var showingAlert = false
    @State private var alertMessage = ""
    @State private var entryType: EntryType? = nil
    @State private var showingPreview = false
    @State private var previewFoodItems: [ParsedFoodItem] = []
    @State private var previewWorkouts: [ParsedWorkout] = []
    @State private var duplicateWarnings: [DataStorageManager.DuplicateWarning] = []
    @State private var itemsToDelete: Set<Int> = []
    @State private var editingItemIndex: Int? = nil
    @State private var isVoiceCorrectionMode = false
    @State private var correctionText = ""
    @State private var isEditingTranscription = false
    @FocusState private var isTranscriptionFocused: Bool
    
    enum EntryType {
        case food
        case workout
    }
    
    var body: some View {
        NavigationView {
            VStack(spacing: 30) {
                Spacer()
                
                // Transcription display
                ScrollView {
                    if isEditingTranscription {
                        TextEditor(text: $transcriptionText)
                            .font(.body)
                            .frame(minHeight: 150)
                            .padding(4)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                            .focused($isTranscriptionFocused)
                            .onAppear {
                                isTranscriptionFocused = true
                            }
                    } else {
                        Text(transcriptionText.isEmpty ? "Your transcription will appear here..." : transcriptionText)
                            .font(.body)
                            .foregroundColor(transcriptionText.isEmpty ? .gray : .primary)
                            .padding()
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .background(Color(.systemGray6))
                            .cornerRadius(12)
                    }
                }
                .frame(height: 200)
                
                // Record button
                Button(action: {
                    if recordingService.isRecording {
                        stopRecording()
                    } else {
                        startRecording()
                    }
                }) {
                    ZStack {
                        Circle()
                            .fill(recordingService.isRecording ? Color.red : Color.blue)
                            .frame(width: 100, height: 100)
                        
                        Image(systemName: recordingService.isRecording ? "stop.fill" : "mic.fill")
                            .font(.system(size: 40))
                            .foregroundColor(.white)
                    }
                }
                .disabled(!recordingService.hasPermission || isProcessing)
                
                Text(recordingService.isRecording ? "Recording..." : (isProcessing ? "Processing..." : "Tap to Record"))
                    .font(.headline)
                    .foregroundColor(.secondary)
                
                if !recordingService.hasPermission {
                    Text("Microphone permission required")
                        .font(.caption)
                        .foregroundColor(.red)
                        .padding(.top, 4)
                }
                
                // Voice correction mode
                if isVoiceCorrectionMode {
                    VStack(spacing: 15) {
                        Text("Recording quantity/unit correction...")
                            .font(.headline)
                            .foregroundColor(.secondary)
                        
                        if !correctionText.isEmpty {
                            Text(correctionText)
                                .font(.body)
                                .padding()
                                .background(Color(.systemGray6))
                                .cornerRadius(8)
                        }
                        
                        Button(action: {
                            applyVoiceCorrection()
                        }) {
                            Text("Apply Correction")
                                .font(.headline)
                                .foregroundColor(.white)
                                .frame(maxWidth: .infinity)
                                .padding()
                                .background(Color.blue)
                                .cornerRadius(12)
                        }
                        .disabled(correctionText.isEmpty)
                        .padding(.horizontal)
                        
                        Button(action: {
                            cancelVoiceCorrection()
                        }) {
                            Text("Cancel")
                                .font(.subheadline)
                                .foregroundColor(.secondary)
                        }
                    }
                    .padding()
                }
                
                // Edit/Re-record buttons
                if !transcriptionText.isEmpty && !isProcessing && !isVoiceCorrectionMode {
                    HStack(spacing: 10) {
                        Button(action: {
                            if isEditingTranscription {
                                // Done editing - dismiss keyboard and save
                                isTranscriptionFocused = false
                                transcriptionText = transcriptionText.trimmingCharacters(in: .whitespacesAndNewlines)
                            }
                            isEditingTranscription.toggle()
                        }) {
                            HStack {
                                Image(systemName: isEditingTranscription ? "checkmark" : "pencil")
                                Text(isEditingTranscription ? "Done" : "Edit")
                            }
                            .font(.subheadline)
                            .foregroundColor(.blue)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.blue.opacity(0.1))
                            .cornerRadius(8)
                        }
                        
                        Button(action: {
                            transcriptionText = ""
                            isEditingTranscription = false
                        }) {
                            HStack {
                                Image(systemName: "arrow.counterclockwise")
                                Text("Re-record")
                            }
                            .font(.subheadline)
                            .foregroundColor(.orange)
                            .padding(.horizontal, 12)
                            .padding(.vertical, 6)
                            .background(Color.orange.opacity(0.1))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal)
                    
                    Button(action: {
                        processTranscription()
                    }) {
                        Text("Save Entry")
                            .font(.headline)
                            .foregroundColor(.white)
                            .frame(maxWidth: .infinity)
                            .padding()
                            .background(Color.green)
                            .cornerRadius(12)
                    }
                    .padding(.horizontal)
                }
                
                Spacer()
            }
            .padding()
            .navigationTitle("Voice Tracker")
            .alert("Alert", isPresented: $showingAlert) {
                Button("OK", role: .cancel) { }
            } message: {
                Text(alertMessage)
            }
            .onAppear {
                if !recordingService.hasPermission {
                    recordingService.requestMicrophonePermission()
                }
            }
            .onTapGesture {
                if isEditingTranscription {
                    isTranscriptionFocused = false
                }
            }
            .sheet(isPresented: $showingPreview) {
                PreviewSheet(
                    foodItems: previewFoodItems,
                    workouts: previewWorkouts,
                    duplicateWarnings: duplicateWarnings,
                    itemsToDelete: $itemsToDelete,
                    onSave: {
                        saveFromPreview()
                    },
                    onCancel: {
                        showingPreview = false
                        itemsToDelete.removeAll()
                    },
                    onVoiceCorrection: { index in
                        showingPreview = false
                        startVoiceCorrection(for: index)
                    },
                    transcription: transcriptionText,
                    onEditTranscription: {
                        showingPreview = false
                        isEditingTranscription = true
                    }
                )
            }
        }
    }
    
    private func startRecording() {
        do {
            recordingURL = try recordingService.startRecording()
            transcriptionText = ""
            speechService.transcription = ""
        } catch {
            alertMessage = "Failed to start recording: \(error.localizedDescription)"
            showingAlert = true
        }
    }
    
    private func stopRecording() {
        guard let url = recordingService.stopRecording() else { return }
        recordingURL = url
        
        // Transcribe the audio
        isProcessing = true
        speechService.transcribeAudioFile(url: url) { result in
            DispatchQueue.main.async {
                isProcessing = false
                switch result {
                case .success(let text):
                    if isVoiceCorrectionMode {
                        correctionText = text
                    } else {
                        transcriptionText = text
                    }
                case .failure(let error):
                    alertMessage = "Transcription failed: \(error.localizedDescription)"
                    showingAlert = true
                }
            }
        }
    }
    
    private func processTranscription() {
        guard !transcriptionText.isEmpty else { return }
        
        isProcessing = true
        
        // Parse both food and workout from the same transcription
        let foodItems = foodParser.parse(transcriptionText)
        let workouts = workoutParser.parse(transcriptionText)
        
        // Check if we found anything
        if foodItems.isEmpty && workouts.isEmpty {
            // Ask user to clarify
            alertMessage = "Could not identify food or workout. Please try re-recording with more details."
            showingAlert = true
            isProcessing = false
            return
        }
        
        // Check for duplicates
        var warnings: [DataStorageManager.DuplicateWarning] = []
        if !foodItems.isEmpty {
            warnings.append(contentsOf: DataStorageManager.shared.checkForDuplicates(foodItems: foodItems))
        }
        for (index, workout) in workouts.enumerated() {
            if let warning = DataStorageManager.shared.checkForDuplicates(workout: workout) {
                warnings.append(DataStorageManager.DuplicateWarning(
                    itemIndex: previewFoodItems.count + index,
                    existingEntry: warning.existingEntry,
                    message: warning.message
                ))
            }
        }
        
        // Store preview data
        previewFoodItems = foodItems
        previewWorkouts = workouts
        duplicateWarnings = warnings
        itemsToDelete.removeAll()
        
        // Show preview sheet
        isProcessing = false
        showingPreview = true
    }
    
    private func saveFromPreview() {
        isProcessing = true
        
        // Filter out deleted items
        let foodItemsToSave = previewFoodItems.enumerated().compactMap { index, item in
            itemsToDelete.contains(index) ? nil : item
        }
        
        let workoutsToSave = previewWorkouts.enumerated().compactMap { index, workout in
            itemsToDelete.contains(previewFoodItems.count + index) ? nil : workout
        }
        
        var savedFoodCount = 0
        var savedWorkoutCount = 0
        
        // Save food items if found
        if !foodItemsToSave.isEmpty {
            savedFoodCount = saveFoodEntries(foodItemsToSave)
        }
        
        // Save workouts if found
        for workout in workoutsToSave {
            saveWorkoutEntry(workout)
            savedWorkoutCount += 1
        }
        
        // Update success message
        var messages: [String] = []
        if savedFoodCount > 0 {
            messages.append("Saved \(savedFoodCount) food item(s)")
        }
        if savedWorkoutCount > 0 {
            messages.append("Saved \(savedWorkoutCount) workout(s)")
        }
        alertMessage = messages.joined(separator: " and ")
        showingAlert = true
        
        // Clear and close
        showingPreview = false
        itemsToDelete.removeAll()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            transcriptionText = ""
            isProcessing = false
        }
    }
    
    private func saveFoodEntries(_ items: [ParsedFoodItem]) -> Int {
        let foodDB = FoodDatabaseService.shared
        let recordingUrlString = recordingURL?.absoluteString
        var savedCount = 0
        var notFoundItems: [String] = []
        
        for item in items {
            if let nutrients = foodDB.getNutrients(for: item.foodName, quantity: item.quantity, unit: item.unit) {
                let entry = FoodEntry(
                    foodName: nutrients.name,
                    quantity: item.quantity,
                    unit: item.unit,
                    calories: nutrients.calories,
                    protein: nutrients.protein,
                    carbs: nutrients.carbs,
                    fats: nutrients.fats,
                    fiber: nutrients.fiber,
                    sugar: nutrients.sugar,
                    sodium: nutrients.sodium,
                    recordingUrl: recordingUrlString,
                    transcription: transcriptionText
                )
                
                DataStorageManager.shared.saveFoodEntry(entry)
                savedCount += 1
            } else {
                // Food not found in database - save with default values
                let entry = FoodEntry(
                    foodName: item.foodName,
                    quantity: item.quantity,
                    unit: item.unit,
                    calories: 0, // Will need manual entry
                    protein: 0,
                    carbs: 0,
                    fats: 0,
                    recordingUrl: recordingUrlString,
                    transcription: transcriptionText
                )
                
                DataStorageManager.shared.saveFoodEntry(entry)
                notFoundItems.append(item.foodName)
                savedCount += 1
            }
        }
        
        // Store not found items for later use in alert (if needed)
        if !notFoundItems.isEmpty && savedCount > 0 {
            // Note: This will be handled in processTranscription if needed
        }
        
        return savedCount
    }
    
    private func saveWorkoutEntry(_ workout: ParsedWorkout) {
        let calories = WorkoutCalorieCalculator.shared.calculateCalories(
            activityType: workout.activityType,
            duration: workout.duration,
            intensity: workout.intensity,
            weight: userWeight
        )
        
        let entry = WorkoutEntry(
            activityType: workout.activityType,
            duration: workout.duration,
            intensity: workout.intensity,
            caloriesBurnt: calories.calories,
            metValue: calories.metValue,
            recordingUrl: recordingURL?.absoluteString,
            transcription: transcriptionText
        )
        
        DataStorageManager.shared.saveWorkoutEntry(entry)
    }
    
    func startVoiceCorrection(for index: Int) {
        editingItemIndex = index
        isVoiceCorrectionMode = true
        correctionText = ""
        // Start recording for correction
        do {
            recordingURL = try recordingService.startRecording()
        } catch {
            alertMessage = "Failed to start recording: \(error.localizedDescription)"
            showingAlert = true
            isVoiceCorrectionMode = false
        }
    }
    
    private func applyVoiceCorrection() {
        guard let index = editingItemIndex, !correctionText.isEmpty else { return }
        
        // Parse the correction text for quantity and unit
        let correctionItems = foodParser.parse(correctionText)
        
        if let correction = correctionItems.first, index < previewFoodItems.count {
            // Update the item with corrected quantity/unit
            var updatedItems = previewFoodItems
            updatedItems[index] = ParsedFoodItem(
                foodName: updatedItems[index].foodName,
                quantity: correction.quantity,
                unit: correction.unit
            )
            previewFoodItems = updatedItems
            
            // Re-check for duplicates with updated items
            var warnings: [DataStorageManager.DuplicateWarning] = []
            if !updatedItems.isEmpty {
                warnings.append(contentsOf: DataStorageManager.shared.checkForDuplicates(foodItems: updatedItems))
            }
            for (idx, workout) in previewWorkouts.enumerated() {
                if let warning = DataStorageManager.shared.checkForDuplicates(workout: workout) {
                    warnings.append(DataStorageManager.DuplicateWarning(
                        itemIndex: updatedItems.count + idx,
                        existingEntry: warning.existingEntry,
                        message: warning.message
                    ))
                }
            }
            duplicateWarnings = warnings
        }
        
        // Reset correction mode
        cancelVoiceCorrection()
        
        // Show preview again with updated items
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
            showingPreview = true
        }
    }
    
    private func cancelVoiceCorrection() {
        isVoiceCorrectionMode = false
        editingItemIndex = nil
        correctionText = ""
        if recordingService.isRecording {
            _ = recordingService.stopRecording()
        }
    }
}

// Preview Sheet
struct PreviewSheet: View {
    let foodItems: [ParsedFoodItem]
    let workouts: [ParsedWorkout]
    let duplicateWarnings: [DataStorageManager.DuplicateWarning]
    @Binding var itemsToDelete: Set<Int>
    let onSave: () -> Void
    let onCancel: () -> Void
    var onVoiceCorrection: ((Int) -> Void)? = nil
    var transcription: String = ""
    var onEditTranscription: (() -> Void)? = nil
    
    var body: some View {
        NavigationView {
            List {
                // Transcription section
                if !transcription.isEmpty {
                    Section(header: Text("Transcription")) {
                        VStack(alignment: .leading, spacing: 8) {
                            Text(transcription)
                                .font(.body)
                            if let onEdit = onEditTranscription {
                                Button(action: onEdit) {
                                    HStack {
                                        Image(systemName: "pencil")
                                        Text("Edit & Re-parse")
                                    }
                                    .font(.subheadline)
                                    .foregroundColor(.blue)
                                }
                            }
                        }
                        .padding(.vertical, 4)
                    }
                }
                
                // Food items
                if !foodItems.isEmpty {
                    Section(header: Text("Food Items")) {
                        ForEach(Array(foodItems.enumerated()), id: \.offset) { index, item in
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(item.foodName.capitalized)
                                        .font(.headline)
                                    Text("\(item.quantity) \(item.unit)")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    // Show duplicate warning if exists
                                    if let warning = duplicateWarnings.first(where: { $0.itemIndex == index }) {
                                        Text(warning.message)
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                    }
                                }
                                
                                Spacer()
                                
                                Button(action: {
                                    onVoiceCorrection?(index)
                                }) {
                                    Image(systemName: "mic.fill")
                                        .foregroundColor(.blue)
                                        .font(.caption)
                                }
                                
                                if itemsToDelete.contains(index) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if itemsToDelete.contains(index) {
                                    itemsToDelete.remove(index)
                                } else {
                                    itemsToDelete.insert(index)
                                }
                            }
                        }
                    }
                }
                
                // Workouts
                if !workouts.isEmpty {
                    Section(header: Text("Workouts")) {
                        ForEach(Array(workouts.enumerated()), id: \.offset) { index, workout in
                            let workoutIndex = foodItems.count + index
                            HStack {
                                VStack(alignment: .leading, spacing: 4) {
                                    Text(workout.activityType.capitalized)
                                        .font(.headline)
                                    Text("\(Int(workout.duration)) min - \(workout.intensity) intensity")
                                        .font(.subheadline)
                                        .foregroundColor(.secondary)
                                    
                                    // Show duplicate warning if exists
                                    if let warning = duplicateWarnings.first(where: { $0.itemIndex == workoutIndex }) {
                                        Text(warning.message)
                                            .font(.caption)
                                            .foregroundColor(.orange)
                                    }
                                }
                                
                                Spacer()
                                
                                if itemsToDelete.contains(workoutIndex) {
                                    Image(systemName: "checkmark.circle.fill")
                                        .foregroundColor(.red)
                                } else {
                                    Image(systemName: "circle")
                                        .foregroundColor(.gray)
                                }
                            }
                            .contentShape(Rectangle())
                            .onTapGesture {
                                if itemsToDelete.contains(workoutIndex) {
                                    itemsToDelete.remove(workoutIndex)
                                } else {
                                    itemsToDelete.insert(workoutIndex)
                                }
                            }
                        }
                    }
                }
            }
            .navigationTitle("Review Entries")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") {
                        onCancel()
                    }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        onSave()
                    }
                }
            }
        }
    }
}

#Preview {
    RecordingView()
}

