import Foundation

class WorkoutCalorieCalculator {
    static let shared = WorkoutCalorieCalculator()
    
    // MET values for common activities (Metabolic Equivalent of Task)
    // Based on Compendium of Physical Activities
    private let metValues: [String: [String: Double]] = [
        "running": ["low": 6.0, "moderate": 9.8, "high": 11.5],
        "jogging": ["low": 6.0, "moderate": 7.0, "high": 9.8],
        "walking": ["low": 3.5, "moderate": 4.3, "high": 5.0],
        "cycling": ["low": 4.0, "moderate": 6.8, "high": 10.0],
        "swimming": ["low": 6.0, "moderate": 8.3, "high": 10.0],
        "gym": ["low": 3.5, "moderate": 5.0, "high": 6.0],
        "weightlifting": ["low": 3.0, "moderate": 5.0, "high": 6.0],
        "yoga": ["low": 2.5, "moderate": 3.0, "high": 4.0],
        "pilates": ["low": 3.0, "moderate": 3.5, "high": 4.5],
        "dancing": ["low": 4.8, "moderate": 6.0, "high": 7.8],
        "basketball": ["low": 6.0, "moderate": 8.0, "high": 10.0],
        "football": ["low": 7.0, "moderate": 8.0, "high": 10.0],
        "soccer": ["low": 7.0, "moderate": 8.0, "high": 10.0],
        "tennis": ["low": 5.0, "moderate": 7.3, "high": 9.0],
        "badminton": ["low": 5.5, "moderate": 7.0, "high": 8.5],
        "cricket": ["low": 4.8, "moderate": 5.0, "high": 6.0],
        "hiit": ["low": 6.0, "moderate": 8.5, "high": 12.0],
        "cardio": ["low": 5.0, "moderate": 7.0, "high": 9.0],
        "treadmill": ["low": 4.0, "moderate": 6.0, "high": 8.0],
        "elliptical": ["low": 5.0, "moderate": 6.5, "high": 8.0],
        "rowing": ["low": 6.0, "moderate": 7.0, "high": 8.5],
        "crossfit": ["low": 6.0, "moderate": 9.0, "high": 12.0],
        "general exercise": ["low": 3.5, "moderate": 5.0, "high": 7.0]
    ]
    
    func calculateCalories(activityType: String, duration: Double, intensity: String, weight: Double) -> (calories: Double, metValue: Double) {
        let lowercasedActivity = activityType.lowercased()
        let lowercasedIntensity = intensity.lowercased()
        
        // Get MET value
        var metValue: Double = 5.0 // default moderate activity
        
        if let activityMETs = metValues[lowercasedActivity] {
            metValue = activityMETs[lowercasedIntensity] ?? activityMETs["moderate"] ?? 5.0
        } else {
            // Try to find similar activity
            for (activity, intensities) in metValues {
                if lowercasedActivity.contains(activity) || activity.contains(lowercasedActivity) {
                    metValue = intensities[lowercasedIntensity] ?? intensities["moderate"] ?? 5.0
                    break
                }
            }
        }
        
        // Calculate calories: MET × weight(kg) × duration(hours)
        // Duration is in minutes, so convert to hours
        let durationHours = duration / 60.0
        let calories = metValue * weight * durationHours
        
        return (calories, metValue)
    }
    
    func getMETValue(for activityType: String, intensity: String) -> Double {
        let lowercasedActivity = activityType.lowercased()
        let lowercasedIntensity = intensity.lowercased()
        
        if let activityMETs = metValues[lowercasedActivity] {
            return activityMETs[lowercasedIntensity] ?? activityMETs["moderate"] ?? 5.0
        }
        
        return 5.0 // default
    }
}

