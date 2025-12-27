import Foundation

// Simple file-based storage manager (replaces Core Data for now)
class DataStorageManager {
    static let shared = DataStorageManager()
    
    private let foodEntriesFileName = "food_entries.json"
    private let workoutEntriesFileName = "workout_entries.json"
    
    private var documentsDirectory: URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    private var foodEntriesURL: URL {
        documentsDirectory.appendingPathComponent(foodEntriesFileName)
    }
    
    private var workoutEntriesURL: URL {
        documentsDirectory.appendingPathComponent(workoutEntriesFileName)
    }
    
    // MARK: - Food Entries
    
    func saveFoodEntry(_ entry: FoodEntry) {
        var entries = loadFoodEntries()
        entries.append(entry)
        saveFoodEntries(entries)
    }
    
    func loadFoodEntries() -> [FoodEntry] {
        guard let data = try? Data(contentsOf: foodEntriesURL),
              let entries = try? JSONDecoder().decode([FoodEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    private func saveFoodEntries(_ entries: [FoodEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: foodEntriesURL)
        }
    }
    
    func deleteFoodEntry(_ entry: FoodEntry) {
        var entries = loadFoodEntries()
        entries.removeAll { $0.id == entry.id }
        saveFoodEntries(entries)
    }
    
    // MARK: - Workout Entries
    
    func saveWorkoutEntry(_ entry: WorkoutEntry) {
        var entries = loadWorkoutEntries()
        entries.append(entry)
        saveWorkoutEntries(entries)
    }
    
    func loadWorkoutEntries() -> [WorkoutEntry] {
        guard let data = try? Data(contentsOf: workoutEntriesURL),
              let entries = try? JSONDecoder().decode([WorkoutEntry].self, from: data) else {
            return []
        }
        return entries
    }
    
    private func saveWorkoutEntries(_ entries: [WorkoutEntry]) {
        if let data = try? JSONEncoder().encode(entries) {
            try? data.write(to: workoutEntriesURL)
        }
    }
    
    func deleteWorkoutEntry(_ entry: WorkoutEntry) {
        var entries = loadWorkoutEntries()
        entries.removeAll { $0.id == entry.id }
        saveWorkoutEntries(entries)
    }
    
    // MARK: - Helper Methods
    
    func getFoodEntries(for date: Date) -> [FoodEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return loadFoodEntries().filter { entry in
            guard let entryDate = entry.timestamp else { return false }
            return entryDate >= startOfDay && entryDate < endOfDay
        }
    }
    
    func getWorkoutEntries(for date: Date) -> [WorkoutEntry] {
        let calendar = Calendar.current
        let startOfDay = calendar.startOfDay(for: date)
        let endOfDay = calendar.date(byAdding: .day, value: 1, to: startOfDay)!
        
        return loadWorkoutEntries().filter { entry in
            guard let entryDate = entry.timestamp else { return false }
            return entryDate >= startOfDay && entryDate < endOfDay
        }
    }
    
    func getAllFoodEntries() -> [FoodEntry] {
        return loadFoodEntries().sorted { ($0.timestamp ?? Date()) > ($1.timestamp ?? Date()) }
    }
    
    func getAllWorkoutEntries() -> [WorkoutEntry] {
        return loadWorkoutEntries().sorted { ($0.timestamp ?? Date()) > ($1.timestamp ?? Date()) }
    }
    
    // MARK: - Duplicate Detection
    
    struct DuplicateWarning {
        let itemIndex: Int
        let existingEntry: Any
        let message: String
    }
    
    func checkForDuplicates(foodItems: [ParsedFoodItem], withinMinutes: Int = 30) -> [DuplicateWarning] {
        let recentEntries = getRecentFoodEntries(withinMinutes: withinMinutes)
        var warnings: [DuplicateWarning] = []
        
        for (index, item) in foodItems.enumerated() {
            for entry in recentEntries {
                // Check if same food name (case-insensitive) and similar quantity (within 20%)
                let nameMatch = entry.foodName.lowercased() == item.foodName.lowercased()
                let quantityMatch = abs(entry.quantity - item.quantity) / max(entry.quantity, item.quantity) < 0.2
                
                if nameMatch && quantityMatch {
                    warnings.append(DuplicateWarning(
                        itemIndex: index,
                        existingEntry: entry,
                        message: "Similar entry found: \(entry.foodName) (\(entry.quantity) \(entry.unit)) at \(formatTime(entry.timestamp ?? Date()))"
                    ))
                    break
                }
            }
        }
        
        return warnings
    }
    
    func checkForDuplicates(workout: ParsedWorkout, withinMinutes: Int = 30) -> DuplicateWarning? {
        let recentEntries = getRecentWorkoutEntries(withinMinutes: withinMinutes)
        
        for entry in recentEntries {
            // Check if same activity type and similar duration (within 10 minutes)
            let activityMatch = entry.activityType.lowercased() == workout.activityType.lowercased()
            let durationMatch = abs(entry.duration - workout.duration) < 10.0
            
            if activityMatch && durationMatch {
                return DuplicateWarning(
                    itemIndex: 0,
                    existingEntry: entry,
                    message: "Similar workout found: \(entry.activityType.capitalized) (\(Int(entry.duration)) min) at \(formatTime(entry.timestamp ?? Date()))"
                )
            }
        }
        
        return nil
    }
    
    private func getRecentFoodEntries(withinMinutes: Int) -> [FoodEntry] {
        let cutoffTime = Date().addingTimeInterval(-Double(withinMinutes * 60))
        return loadFoodEntries().filter { entry in
            guard let timestamp = entry.timestamp else { return false }
            return timestamp >= cutoffTime
        }
    }
    
    private func getRecentWorkoutEntries(withinMinutes: Int) -> [WorkoutEntry] {
        let cutoffTime = Date().addingTimeInterval(-Double(withinMinutes * 60))
        return loadWorkoutEntries().filter { entry in
            guard let timestamp = entry.timestamp else { return false }
            return timestamp >= cutoffTime
        }
    }
    
    private func formatTime(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

