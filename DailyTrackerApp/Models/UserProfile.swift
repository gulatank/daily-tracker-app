import Foundation

struct UserProfile: Codable {
    var age: Int
    var gender: String // "male", "female", "other"
    var weight: Double // in kg
    var height: Double // in cm
    var activityLevel: String // "sedentary", "lightly_active", "moderately_active", "very_active"
    
    init(age: Int = 37, gender: String = "male", weight: Double = 70.0, height: Double = 170.0, activityLevel: String = "moderately_active") {
        self.age = age
        self.gender = gender
        self.weight = weight
        self.height = height
        self.activityLevel = activityLevel
    }
    
    // BMR calculation using Mifflin-St Jeor Equation
    func calculateBMR() -> Double {
        let weightFactor = 10 * weight
        let heightFactor = 6.25 * height
        let ageFactor = 5 * Double(age)
        
        if gender.lowercased() == "male" {
            return weightFactor + heightFactor - ageFactor + 5
        } else {
            return weightFactor + heightFactor - ageFactor - 161
        }
    }
    
    // TDEE calculation (Total Daily Energy Expenditure)
    func calculateTDEE() -> Double {
        let bmr = calculateBMR()
        let activityMultipliers: [String: Double] = [
            "sedentary": 1.2,
            "lightly_active": 1.375,
            "moderately_active": 1.55,
            "very_active": 1.725
        ]
        return bmr * (activityMultipliers[activityLevel] ?? 1.55)
    }
}

