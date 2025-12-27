import Foundation

class StatisticsService {
    static let shared = StatisticsService()
    private let storageManager = DataStorageManager.shared
    
    func getDailySummary(for date: Date) -> DailySummary {
        // Fetch food entries
        let foodEntries = storageManager.getFoodEntries(for: date)
        
        // Fetch workout entries
        let workoutEntries = storageManager.getWorkoutEntries(for: date)
        
        // Calculate totals
        let totalCaloriesConsumed = foodEntries.reduce(0.0) { $0 + $1.calories }
        let totalCaloriesBurnt = workoutEntries.reduce(0.0) { $0 + $1.caloriesBurnt }
        let netCalories = totalCaloriesConsumed - totalCaloriesBurnt
        
        let totalProtein = foodEntries.reduce(0.0) { $0 + $1.protein }
        let totalCarbs = foodEntries.reduce(0.0) { $0 + $1.carbs }
        let totalFats = foodEntries.reduce(0.0) { $0 + $1.fats }
        let totalFiber = foodEntries.reduce(0.0) { $0 + $1.fiber }
        let totalSugar = foodEntries.reduce(0.0) { $0 + $1.sugar }
        let totalSodium = foodEntries.reduce(0.0) { $0 + $1.sodium }
        
        return DailySummary(
            date: date,
            totalCaloriesConsumed: totalCaloriesConsumed,
            totalCaloriesBurnt: totalCaloriesBurnt,
            netCalories: netCalories,
            totalProtein: totalProtein,
            totalCarbs: totalCarbs,
            totalFats: totalFats,
            totalFiber: totalFiber,
            totalSugar: totalSugar,
            totalSodium: totalSodium,
            workoutCount: workoutEntries.count,
            foodEntryCount: foodEntries.count
        )
    }
    
    func getStatisticsSummary(period: String, startDate: Date, endDate: Date) -> StatisticsSummary {
        let calendar = Calendar.current
        var currentDate = calendar.startOfDay(for: startDate)
        let end = calendar.startOfDay(for: endDate)
        
        var dailySummaries: [DailySummary] = []
        
        while currentDate <= end {
            dailySummaries.append(getDailySummary(for: currentDate))
            currentDate = calendar.date(byAdding: .day, value: 1, to: currentDate)!
        }
        
        let count = Double(dailySummaries.count)
        guard count > 0 else {
            return StatisticsSummary(
                period: period,
                startDate: startDate,
                endDate: endDate,
                averageCaloriesConsumed: 0,
                averageCaloriesBurnt: 0,
                averageNetCalories: 0,
                averageProtein: 0,
                averageCarbs: 0,
                averageFats: 0,
                totalWorkouts: 0,
                totalFoodEntries: 0,
                dailySummaries: []
            )
        }
        
        let averageCaloriesConsumed = dailySummaries.reduce(0.0) { $0 + $1.totalCaloriesConsumed } / count
        let averageCaloriesBurnt = dailySummaries.reduce(0.0) { $0 + $1.totalCaloriesBurnt } / count
        let averageNetCalories = dailySummaries.reduce(0.0) { $0 + $1.netCalories } / count
        let averageProtein = dailySummaries.reduce(0.0) { $0 + $1.totalProtein } / count
        let averageCarbs = dailySummaries.reduce(0.0) { $0 + $1.totalCarbs } / count
        let averageFats = dailySummaries.reduce(0.0) { $0 + $1.totalFats } / count
        let totalWorkouts = dailySummaries.reduce(0) { $0 + $1.workoutCount }
        let totalFoodEntries = dailySummaries.reduce(0) { $0 + $1.foodEntryCount }
        
        return StatisticsSummary(
            period: period,
            startDate: startDate,
            endDate: endDate,
            averageCaloriesConsumed: averageCaloriesConsumed,
            averageCaloriesBurnt: averageCaloriesBurnt,
            averageNetCalories: averageNetCalories,
            averageProtein: averageProtein,
            averageCarbs: averageCarbs,
            averageFats: averageFats,
            totalWorkouts: totalWorkouts,
            totalFoodEntries: totalFoodEntries,
            dailySummaries: dailySummaries
        )
    }
    
    func getWeeklySummary(for date: Date) -> StatisticsSummary {
        let calendar = Calendar.current
        let weekday = calendar.component(.weekday, from: date)
        let startOfWeek = calendar.date(byAdding: .day, value: -(weekday - calendar.firstWeekday), to: date)!
        let endOfWeek = calendar.date(byAdding: .day, value: 6, to: startOfWeek)!
        return getStatisticsSummary(period: "weekly", startDate: startOfWeek, endDate: endOfWeek)
    }
    
    func getMonthlySummary(for date: Date) -> StatisticsSummary {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year, .month], from: date)
        let startOfMonth = calendar.date(from: components)!
        let endOfMonth = calendar.date(byAdding: DateComponents(month: 1, day: -1), to: startOfMonth)!
        return getStatisticsSummary(period: "monthly", startDate: startOfMonth, endDate: endOfMonth)
    }
    
    func getYearlySummary(for date: Date) -> StatisticsSummary {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.year], from: date)
        let startOfYear = calendar.date(from: components)!
        let endOfYear = calendar.date(byAdding: DateComponents(year: 1, day: -1), to: startOfYear)!
        return getStatisticsSummary(period: "yearly", startDate: startOfYear, endDate: endOfYear)
    }
}

