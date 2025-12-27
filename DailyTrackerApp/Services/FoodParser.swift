import Foundation

struct ParsedFoodItem {
    let foodName: String
    let quantity: Double
    let unit: String
}

class FoodParser {
    
    // Common food keywords
    private let indianFoods = ["roti", "chapati", "naan", "dal", "dal fry", "dal tadka", "rice", "biriyani", "biryani", "curry", "sabzi", "sabji", "paratha", "dosa", "idli", "sambar", "rasam", "paneer", "palak", "aloo", "gobi", "bhindi", "rajma", "chana", "chole"]
    
    private let asianFoods = ["sushi", "ramen", "noodles", "fried rice", "dim sum", "dumpling", "pho", "pad thai", "curry", "teriyaki", "tempura"]
    
    private let westernFoods = ["pizza", "pasta", "burger", "sandwich", "salad", "soup", "bread", "chicken", "beef", "pork", "fish", "steak"]
    
    private let quantityKeywords = ["one", "two", "three", "four", "five", "six", "seven", "eight", "nine", "ten", "half", "quarter", "full", "some", "a", "an", "piece", "pieces", "cup", "cups", "bowl", "bowls", "plate", "plates", "serving", "servings"]
    
    private let units = ["piece", "pieces", "cup", "cups", "bowl", "bowls", "plate", "plates", "serving", "servings", "gram", "grams", "kg", "kilogram", "ml", "liter", "litre", "tbsp", "tablespoon", "tsp", "teaspoon", "bowl of", "bowls of", "plate of", "plates of"]
    
    // Workout keywords to filter out from food parsing
    private let workoutKeywords = ["run", "running", "ran", "jog", "jogging", "walk", "walking", "cycle", "cycling", "bike", "swim", "swimming", "gym", "weight", "weightlifting", "lifting", "yoga", "pilates", "dance", "dancing", "basketball", "football", "soccer", "tennis", "badminton", "cricket", "hiit", "cardio", "treadmill", "elliptical", "rowing", "crossfit", "exercise", "workout"]
    
    func parse(_ text: String) -> [ParsedFoodItem] {
        let lowercased = text.lowercased()
        var items: [ParsedFoodItem] = []
        
        // Split by common separators
        var sentences = lowercased.components(separatedBy: ",")
            .flatMap { $0.components(separatedBy: ".") }
            .flatMap { $0.components(separatedBy: " and ") }
            .map { $0.trimmingCharacters(in: .whitespaces) }
            .filter { !$0.isEmpty }
        
        for sentence in sentences {
            // Skip sentences that contain workout keywords
            let lowerSentence = sentence.lowercased()
            if workoutKeywords.contains(where: { lowerSentence.contains($0) }) {
                continue
            }
            if let item = parseSentence(sentence) {
                items.append(item)
            }
        }
        
        // If no items found, try to extract from entire text (but skip if it contains workout keywords)
        if items.isEmpty && !workoutKeywords.contains(where: { lowercased.contains($0) }), let item = parseSentence(lowercased) {
            items.append(item)
        }
        
        return items
    }
    
    private func parseSentence(_ sentence: String) -> ParsedFoodItem? {
        let words = sentence.components(separatedBy: .whitespaces)
        
        // Find food name
        var foodName = ""
        var quantity: Double = 1.0
        var unit = "serving"
        
        // Extract numbers
        let numberWords: [String: Double] = [
            "one": 1, "two": 2, "three": 3, "four": 4, "five": 5,
            "six": 6, "seven": 7, "eight": 8, "nine": 9, "ten": 10,
            "half": 0.5, "quarter": 0.25
        ]
        
        // Check for numeric quantities
        for (index, word) in words.enumerated() {
            if let num = Double(word) {
                quantity = num
                // Check if next word(s) form a unit (e.g., "bowls of", "bowl of")
                if index + 1 < words.count {
                    let nextWord = words[index + 1].lowercased()
                    // Check for "X bowls of" or "X bowl of" pattern
                    if index + 2 < words.count && (nextWord == "bowl" || nextWord == "bowls" || nextWord == "plate" || nextWord == "plates") {
                        let thirdWord = words[index + 2].lowercased()
                        if thirdWord == "of" {
                            unit = nextWord == "bowl" || nextWord == "bowls" ? "bowls" : "plates"
                            // Extract food name from remaining words (skip "of")
                            if index + 3 < words.count {
                                foodName = Array(words[(index + 3)...]).joined(separator: " ")
                            }
                        } else if units.contains(nextWord) {
                            unit = nextWord
                            if index + 2 < words.count {
                                foodName = Array(words[(index + 2)...]).joined(separator: " ")
                            }
                        } else {
                            foodName = Array(words[(index + 1)...]).joined(separator: " ")
                        }
                    } else if units.contains(nextWord) {
                        unit = nextWord
                        // Extract food name from remaining words
                        if index + 2 < words.count {
                            foodName = Array(words[(index + 2)...]).joined(separator: " ")
                        }
                    } else {
                        foodName = Array(words[(index + 1)...]).joined(separator: " ")
                    }
                }
                break
            } else if let num = numberWords[word.lowercased()] {
                quantity = num
                if index + 1 < words.count {
                    let nextWord = words[index + 1].lowercased()
                    // Check for "X bowls of" or "X bowl of" pattern
                    if index + 2 < words.count && (nextWord == "bowl" || nextWord == "bowls" || nextWord == "plate" || nextWord == "plates") {
                        let thirdWord = words[index + 2].lowercased()
                        if thirdWord == "of" {
                            unit = nextWord == "bowl" || nextWord == "bowls" ? "bowls" : "plates"
                            // Extract food name from remaining words (skip "of")
                            if index + 3 < words.count {
                                foodName = Array(words[(index + 3)...]).joined(separator: " ")
                            }
                        } else if units.contains(nextWord) {
                            unit = nextWord
                            if index + 2 < words.count {
                                foodName = Array(words[(index + 2)...]).joined(separator: " ")
                            }
                        } else {
                            foodName = Array(words[(index + 1)...]).joined(separator: " ")
                        }
                    } else if units.contains(nextWord) {
                        unit = nextWord
                        if index + 2 < words.count {
                            foodName = Array(words[(index + 2)...]).joined(separator: " ")
                        }
                    } else {
                        foodName = Array(words[(index + 1)...]).joined(separator: " ")
                    }
                }
                break
            }
        }
        
        // If no quantity found, try to find food name directly
        if foodName.isEmpty {
            // Look for food keywords
            for foodList in [indianFoods, asianFoods, westernFoods] {
                for food in foodList {
                    if sentence.contains(food) {
                        foodName = extractFoodName(containing: food, from: sentence)
                        break
                    }
                }
                if !foodName.isEmpty { break }
            }
        }
        
        // Clean up food name
        foodName = foodName
            .replacingOccurrences(of: "i ate", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "i had", with: "", options: .caseInsensitive)
            .replacingOccurrences(of: "i'm eating", with: "", options: .caseInsensitive)
            .trimmingCharacters(in: .whitespaces)
        
        // Validate: foodName must contain actual food keywords, not just random words
        if foodName.isEmpty {
            return nil
        }
        
        // Additional validation: if foodName was set from number parsing but doesn't contain food keywords, reject it
        let lowerFoodName = foodName.lowercased()
        let allFoods = indianFoods + asianFoods + westernFoods
        if !allFoods.contains(where: { lowerFoodName.contains($0) }) {
            // Food name doesn't contain any known food keyword - likely not a food item
            return nil
        }
        
        // Better quantity detection for common patterns
        if sentence.contains("a ") || sentence.contains("an ") {
            quantity = 1.0
        } else if sentence.contains("couple of") || sentence.contains("couple") {
            quantity = 2.0
        } else if sentence.contains("few") {
            quantity = 3.0
        } else if sentence.contains("some") || sentence.contains("a bit") {
            quantity = 0.5
        } else if sentence.contains("full") || sentence.contains("complete") {
            quantity = 1.0
        }
        
        return ParsedFoodItem(foodName: foodName, quantity: quantity, unit: unit)
    }
    
    private func extractFoodName(containing keyword: String, from text: String) -> String {
        let words = text.components(separatedBy: .whitespaces)
        if let index = words.firstIndex(where: { $0.contains(keyword) }) {
            var endIndex = index + 1
            // Try to capture common food combinations (e.g., "dal fry", "fried rice")
            if endIndex < words.count {
                let nextWord = words[endIndex]
                if ["fry", "fried", "tadka", "curry", "soup", "salad"].contains(nextWord.lowercased()) {
                    endIndex += 1
                }
            }
            return Array(words[index..<min(endIndex, words.count)]).joined(separator: " ")
        }
        return keyword
    }
}

