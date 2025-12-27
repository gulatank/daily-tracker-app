import Foundation

struct DailySummary: Codable, Identifiable {
    let id: UUID
    let date: Date
    let totalCaloriesConsumed: Double
    let totalCaloriesBurnt: Double
    let netCalories: Double
    let totalProtein: Double
    let totalCarbs: Double
    let totalFats: Double
    let totalFiber: Double
    let totalSugar: Double
    let totalSodium: Double
    let workoutCount: Int
    let foodEntryCount: Int
    
    init(id: UUID = UUID(), date: Date, totalCaloriesConsumed: Double, totalCaloriesBurnt: Double, netCalories: Double, totalProtein: Double, totalCarbs: Double, totalFats: Double, totalFiber: Double, totalSugar: Double, totalSodium: Double, workoutCount: Int, foodEntryCount: Int) {
        self.id = id
        self.date = date
        self.totalCaloriesConsumed = totalCaloriesConsumed
        self.totalCaloriesBurnt = totalCaloriesBurnt
        self.netCalories = netCalories
        self.totalProtein = totalProtein
        self.totalCarbs = totalCarbs
        self.totalFats = totalFats
        self.totalFiber = totalFiber
        self.totalSugar = totalSugar
        self.totalSodium = totalSodium
        self.workoutCount = workoutCount
        self.foodEntryCount = foodEntryCount
    }
}

struct StatisticsSummary: Codable {
    let period: String // "daily", "weekly", "monthly", "yearly", "custom"
    let startDate: Date
    let endDate: Date
    let averageCaloriesConsumed: Double
    let averageCaloriesBurnt: Double
    let averageNetCalories: Double
    let averageProtein: Double
    let averageCarbs: Double
    let averageFats: Double
    let totalWorkouts: Int
    let totalFoodEntries: Int
    let dailySummaries: [DailySummary]
}

