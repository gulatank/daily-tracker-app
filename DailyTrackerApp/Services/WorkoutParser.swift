import Foundation

struct ParsedWorkout {
    let activityType: String
    let duration: Double // in minutes
    let intensity: String // "low", "moderate", "high"
}

class WorkoutParser {
    
    private let workoutKeywords: [String: String] = [
        "running": "running",
        "run": "running",
        "jogging": "jogging",
        "jog": "jogging",
        "walking": "walking",
        "walk": "walking",
        "cycling": "cycling",
        "bike": "cycling",
        "bicycle": "cycling",
        "swimming": "swimming",
        "swim": "swimming",
        "gym": "gym",
        "weight": "weightlifting",
        "weightlifting": "weightlifting",
        "lifting": "weightlifting",
        "yoga": "yoga",
        "pilates": "pilates",
        "dancing": "dancing",
        "dance": "dancing",
        "basketball": "basketball",
        "football": "football",
        "soccer": "soccer",
        "tennis": "tennis",
        "badminton": "badminton",
        "cricket": "cricket",
        "hiit": "hiit",
        "cardio": "cardio",
        "treadmill": "treadmill",
        "elliptical": "elliptical",
        "rowing": "rowing",
        "rowing machine": "rowing",
        "crossfit": "crossfit"
    ]
    
    private let durationKeywords: [String: Double] = [
        "hour": 60,
        "hours": 60,
        "hr": 60,
        "hrs": 60,
        "minute": 1,
        "minutes": 1,
        "min": 1,
        "mins": 1
    ]
    
    private let intensityKeywords: [String: String] = [
        "low": "low",
        "easy": "low",
        "light": "low",
        "slow": "low",
        "moderate": "moderate",
        "medium": "moderate",
        "normal": "moderate",
        "high": "high",
        "hard": "high",
        "intense": "high",
        "fast": "high",
        "sprint": "high"
    ]
    
    func parse(_ text: String) -> [ParsedWorkout] {
        let lowercased = text.lowercased()
        var workouts: [ParsedWorkout] = []
        
        // Split by common separators to find multiple workouts
        var sentences = lowercased.components(separatedBy: ",")
            .flatMap { $0.components(separatedBy: ".") }
            .flatMap { $0.components(separatedBy: " and ") }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        for sentence in sentences {
            if let workout = parseSentence(sentence) {
                workouts.append(workout)
            }
        }
        
        // If no workouts found in split sentences, try entire text
        if workouts.isEmpty, let workout = parseSentence(lowercased) {
            workouts.append(workout)
        }
        
        return workouts
    }
    
    private func parseSentence(_ sentence: String) -> ParsedWorkout? {
        let lowercased = sentence.lowercased()
        
        // Extract activity type
        var activityType: String? = nil
        for (keyword, activity) in workoutKeywords {
            if lowercased.contains(keyword) {
                activityType = activity
                break
            }
        }
        
        // Return nil if no workout keyword found
        guard let activityType = activityType else {
            return nil
        }
        
        // Extract duration
        var duration: Double = 30.0 // default 30 minutes
        
        // Look for patterns like "30 minutes", "1 hour", "45 mins"
        let words = lowercased.components(separatedBy: .whitespaces)
        for (index, word) in words.enumerated() {
            if let num = Double(word) {
                if index + 1 < words.count {
                    let nextWord = words[index + 1]
                    if let multiplier = durationKeywords[nextWord] {
                        duration = num * multiplier
                        break
                    }
                } else if index > 0 {
                    // Check previous word for duration keyword
                    let prevWord = words[index - 1]
                    if let multiplier = durationKeywords[prevWord] {
                        duration = num * multiplier
                        break
                    }
                }
            } else if let num = numberWordsToDouble(word) {
                if index + 1 < words.count {
                    let nextWord = words[index + 1]
                    if let multiplier = durationKeywords[nextWord] {
                        duration = num * multiplier
                        break
                    }
                }
            }
        }
        
        // Extract intensity
        var intensity = "moderate" // default
        for (keyword, int) in intensityKeywords {
            if lowercased.contains(keyword) {
                intensity = int
                break
            }
        }
        
        // Infer intensity from activity type if not specified
        if intensity == "moderate" && !intensityKeywords.keys.contains(where: { lowercased.contains($0) }) {
            let highIntensityActivities = ["running", "sprint", "hiit", "crossfit", "basketball", "football"]
            let lowIntensityActivities = ["walking", "yoga", "pilates"]
            
            if highIntensityActivities.contains(activityType) {
                intensity = "high"
            } else if lowIntensityActivities.contains(activityType) {
                intensity = "low"
            }
        }
        
        return ParsedWorkout(activityType: activityType, duration: duration, intensity: intensity)
    }
    
    private func numberWordsToDouble(_ word: String) -> Double? {
        let numberWords: [String: Double] = [
            "one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
            "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10,
            "half": 0.5, "quarter": 0.25
        ]
        return numberWords[word.lowercased()]
    }
}

