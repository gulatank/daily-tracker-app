import Foundation

struct FoodNutrients {
    let name: String
    let calories: Double // per 100g or per serving
    let protein: Double // grams
    let carbs: Double // grams
    let fats: Double // grams
    let fiber: Double // grams
    let sugar: Double // grams
    let sodium: Double // mg
    let standardServing: Double // grams
    let standardUnit: String
}

class FoodDatabaseService {
    static let shared = FoodDatabaseService()
    
    // Local database for common Indian, Asian, and Western foods
    private let localFoodDatabase: [String: FoodNutrients] = {
        var db: [String: FoodNutrients] = [:]
        
        // Indian Foods (per 100g unless specified)
        db["roti"] = FoodNutrients(name: "Roti", calories: 297, protein: 7.85, carbs: 46.36, fats: 7.45, fiber: 4.9, sugar: 0, sodium: 298, standardServing: 60, standardUnit: "piece")
        db["chapati"] = db["roti"]
        db["naan"] = FoodNutrients(name: "Naan", calories: 310, protein: 8.0, carbs: 48.0, fats: 10.0, fiber: 2.0, sugar: 2.0, sodium: 400, standardServing: 90, standardUnit: "piece")
        db["dal"] = FoodNutrients(name: "Dal", calories: 105, protein: 6.8, carbs: 18.3, fats: 1.4, fiber: 4.8, sugar: 1.2, sodium: 300, standardServing: 200, standardUnit: "bowl")
        db["dal fry"] = FoodNutrients(name: "Dal Fry", calories: 125, protein: 6.8, carbs: 20.3, fats: 2.4, fiber: 4.8, sugar: 1.2, sodium: 400, standardServing: 200, standardUnit: "bowl")
        db["dal tadka"] = db["dal fry"]
        db["rice"] = FoodNutrients(name: "Rice", calories: 130, protein: 2.7, carbs: 28.0, fats: 0.3, fiber: 0.4, sugar: 0.05, sodium: 1, standardServing: 100, standardUnit: "cup")
        db["biriyani"] = FoodNutrients(name: "Biryani", calories: 225, protein: 12.0, carbs: 35.0, fats: 5.0, fiber: 2.0, sugar: 2.0, sodium: 600, standardServing: 250, standardUnit: "plate")
        db["biryani"] = db["biriyani"]
        db["paneer"] = FoodNutrients(name: "Paneer", calories: 295, protein: 18.3, carbs: 3.4, fats: 20.8, fiber: 0, sugar: 3.4, sodium: 15, standardServing: 100, standardUnit: "grams")
        db["paratha"] = FoodNutrients(name: "Paratha", calories: 326, protein: 6.36, carbs: 45.36, fats: 13.6, fiber: 2.7, sugar: 0, sodium: 500, standardServing: 100, standardUnit: "piece")
        db["dosa"] = FoodNutrients(name: "Dosa", calories: 133, protein: 2.7, carbs: 23.4, fats: 3.2, fiber: 1.5, sugar: 0.5, sodium: 300, standardServing: 50, standardUnit: "piece")
        db["idli"] = FoodNutrients(name: "Idli", calories: 39, protein: 2.2, carbs: 7.5, fats: 0.2, fiber: 1.0, sugar: 0.3, sodium: 220, standardServing: 38, standardUnit: "piece")
        db["sambar"] = FoodNutrients(name: "Sambar", calories: 85, protein: 3.5, carbs: 15.0, fats: 1.5, fiber: 3.0, sugar: 4.0, sodium: 450, standardServing: 150, standardUnit: "bowl")
        db["curry"] = FoodNutrients(name: "Curry", calories: 120, protein: 4.0, carbs: 12.0, fats: 6.0, fiber: 2.0, sugar: 5.0, sodium: 500, standardServing: 200, standardUnit: "bowl")
        db["aloo"] = FoodNutrients(name: "Aloo Curry", calories: 150, protein: 2.5, carbs: 20.0, fats: 6.5, fiber: 2.5, sugar: 3.0, sodium: 400, standardServing: 150, standardUnit: "bowl")
        db["gobi"] = FoodNutrients(name: "Gobi Curry", calories: 100, protein: 3.0, carbs: 12.0, fats: 4.0, fiber: 3.5, sugar: 4.0, sodium: 450, standardServing: 150, standardUnit: "bowl")
        db["chana"] = FoodNutrients(name: "Chana Masala", calories: 180, protein: 8.5, carbs: 28.0, fats: 4.5, fiber: 7.0, sugar: 5.0, sodium: 600, standardServing: 200, standardUnit: "bowl")
        db["chole"] = db["chana"]
        db["rajma"] = FoodNutrients(name: "Rajma", calories: 175, protein: 9.0, carbs: 26.0, fats: 4.0, fiber: 8.0, sugar: 4.0, sodium: 500, standardServing: 200, standardUnit: "bowl")
        
        // Asian Foods
        db["sushi"] = FoodNutrients(name: "Sushi", calories: 150, protein: 6.0, carbs: 28.0, fats: 2.0, fiber: 1.0, sugar: 3.0, sodium: 600, standardServing: 100, standardUnit: "piece")
        db["ramen"] = FoodNutrients(name: "Ramen", calories: 200, protein: 8.0, carbs: 35.0, fats: 4.0, fiber: 2.0, sugar: 2.0, sodium: 1200, standardServing: 250, standardUnit: "bowl")
        db["noodles"] = FoodNutrients(name: "Noodles", calories: 138, protein: 4.5, carbs: 25.0, fats: 2.1, fiber: 1.8, sugar: 0.5, sodium: 400, standardServing: 200, standardUnit: "bowl")
        db["fried rice"] = FoodNutrients(name: "Fried Rice", calories: 163, protein: 4.3, carbs: 28.0, fats: 3.8, fiber: 1.0, sugar: 0.8, sodium: 500, standardServing: 200, standardUnit: "plate")
        db["pho"] = FoodNutrients(name: "Pho", calories: 350, protein: 15.0, carbs: 45.0, fats: 10.0, fiber: 2.0, sugar: 3.0, sodium: 1000, standardServing: 350, standardUnit: "bowl")
        db["pad thai"] = FoodNutrients(name: "Pad Thai", calories: 357, protein: 14.0, carbs: 52.0, fats: 11.0, fiber: 2.5, sugar: 8.0, sodium: 800, standardServing: 200, standardUnit: "plate")
        db["dumpling"] = FoodNutrients(name: "Dumpling", calories: 42, protein: 2.0, carbs: 6.0, fats: 1.0, fiber: 0.3, sugar: 0.5, sodium: 200, standardServing: 25, standardUnit: "piece")
        
        // Western Foods
        db["pizza"] = FoodNutrients(name: "Pizza", calories: 266, protein: 11.0, carbs: 33.0, fats: 10.0, fiber: 2.3, sugar: 3.6, sodium: 551, standardServing: 100, standardUnit: "slice")
        db["pasta"] = FoodNutrients(name: "Pasta", calories: 131, protein: 5.0, carbs: 25.0, fats: 1.1, fiber: 1.8, sugar: 0.6, sodium: 6, standardServing: 100, standardUnit: "grams")
        db["burger"] = FoodNutrients(name: "Burger", calories: 354, protein: 16.0, carbs: 33.0, fats: 16.0, fiber: 2.0, sugar: 5.0, sodium: 497, standardServing: 150, standardUnit: "piece")
        db["sandwich"] = FoodNutrients(name: "Sandwich", calories: 250, protein: 10.0, carbs: 35.0, fats: 8.0, fiber: 3.0, sugar: 5.0, sodium: 600, standardServing: 150, standardUnit: "piece")
        db["salad"] = FoodNutrients(name: "Salad", calories: 20, protein: 1.0, carbs: 4.0, fats: 0.2, fiber: 1.5, sugar: 2.0, sodium: 10, standardServing: 100, standardUnit: "grams")
        db["chicken"] = FoodNutrients(name: "Chicken", calories: 165, protein: 31.0, carbs: 0.0, fats: 3.6, fiber: 0, sugar: 0, sodium: 74, standardServing: 100, standardUnit: "grams")
        db["bread"] = FoodNutrients(name: "Bread", calories: 265, protein: 9.0, carbs: 49.0, fats: 3.2, fiber: 2.7, sugar: 5.7, sodium: 491, standardServing: 100, standardUnit: "grams")
        
        return db
    }()
    
    func getNutrients(for foodName: String, quantity: Double, unit: String) -> FoodNutrients? {
        let lowercased = foodName.lowercased().trimmingCharacters(in: .whitespaces)
        
        // Try exact match first
        if let nutrients = localFoodDatabase[lowercased] {
            return scaleNutrients(nutrients, quantity: quantity, unit: unit)
        }
        
        // Try partial match
        for (key, nutrients) in localFoodDatabase {
            if lowercased.contains(key) || key.contains(lowercased) {
                return scaleNutrients(nutrients, quantity: quantity, unit: unit)
            }
        }
        
        return nil
    }
    
    private func scaleNutrients(_ baseNutrients: FoodNutrients, quantity: Double, unit: String) -> FoodNutrients {
        // Convert quantity to standard serving size
        let standardQuantity: Double
        
        // Normalize units
        let normalizedUnit = unit.lowercased()
        let standardUnitLower = baseNutrients.standardUnit.lowercased()
        
        if normalizedUnit == standardUnitLower {
            standardQuantity = quantity
        } else {
            // Try to convert between common units
            // For now, assume 1 serving = 1 piece/bowl/plate/cup
            if (normalizedUnit.contains("piece") || normalizedUnit.contains("pieces")) && standardUnitLower.contains("piece") {
                standardQuantity = quantity
            } else if (normalizedUnit.contains("bowl") || normalizedUnit.contains("bowls")) && standardUnitLower.contains("bowl") {
                standardQuantity = quantity
            } else if (normalizedUnit.contains("plate") || normalizedUnit.contains("plates")) && standardUnitLower.contains("plate") {
                standardQuantity = quantity
            } else if (normalizedUnit.contains("cup") || normalizedUnit.contains("cups")) && standardUnitLower.contains("cup") {
                standardQuantity = quantity
            } else {
                // Default: assume quantity is in servings
                standardQuantity = quantity
            }
        }
        
        // Calculate nutrients based on standard serving
        let multiplier = standardQuantity * (baseNutrients.standardServing / 100.0)
        
        return FoodNutrients(
            name: baseNutrients.name,
            calories: baseNutrients.calories * multiplier,
            protein: baseNutrients.protein * multiplier,
            carbs: baseNutrients.carbs * multiplier,
            fats: baseNutrients.fats * multiplier,
            fiber: baseNutrients.fiber * multiplier,
            sugar: baseNutrients.sugar * multiplier,
            sodium: baseNutrients.sodium * multiplier,
            standardServing: baseNutrients.standardServing,
            standardUnit: baseNutrients.standardUnit
        )
    }
    
    // Search for foods (for future enhancement with USDA API)
    func searchFoods(query: String, completion: @escaping ([FoodNutrients]) -> Void) {
        // For now, return local matches
        let lowercased = query.lowercased()
        let matches = localFoodDatabase.values.filter { food in
            food.name.lowercased().contains(lowercased)
        }
        completion(Array(matches))
    }
}

