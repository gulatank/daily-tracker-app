import SwiftUI
import Charts

struct StatisticsView: View {
    @State private var selectedPeriod: StatisticsPeriod = .daily
    @State private var customStartDate = Date()
    @State private var customEndDate = Date()
    @State private var showingDatePicker = false
    @State private var statistics: StatisticsSummary?
    
    enum StatisticsPeriod: String, CaseIterable {
        case daily = "Daily"
        case weekly = "Weekly"
        case monthly = "Monthly"
        case yearly = "Yearly"
        case custom = "Custom"
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 20) {
                    // Period selector
                    Picker("Period", selection: $selectedPeriod) {
                        ForEach(StatisticsPeriod.allCases, id: \.self) { period in
                            Text(period.rawValue).tag(period)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding()
                    .onChange(of: selectedPeriod) { _ in
                        loadStatistics()
                    }
                    
                    // Custom date picker
                    if selectedPeriod == .custom {
                        DatePicker("Start Date", selection: $customStartDate, displayedComponents: .date)
                            .padding(.horizontal)
                            .onChange(of: customStartDate) { _ in
                                loadStatistics()
                            }
                        
                        DatePicker("End Date", selection: $customEndDate, displayedComponents: .date)
                            .padding(.horizontal)
                            .onChange(of: customEndDate) { _ in
                                loadStatistics()
                            }
                    }
                    
                    if let stats = statistics {
                        statisticsContent(stats)
                    } else {
                        ProgressView()
                            .padding()
                    }
                }
            }
            .navigationTitle("Statistics")
            .onAppear {
                loadStatistics()
            }
        }
    }
    
    private func statisticsContent(_ stats: StatisticsSummary) -> some View {
        VStack(spacing: 20) {
            // Summary cards
            VStack(spacing: 12) {
                StatCard(title: "Avg Calories Consumed", value: String(format: "%.0f", stats.averageCaloriesConsumed), unit: "kcal", color: .blue)
                StatCard(title: "Avg Calories Burnt", value: String(format: "%.0f", stats.averageCaloriesBurnt), unit: "kcal", color: .orange)
                StatCard(title: "Avg Net Calories", value: String(format: "%.0f", stats.averageNetCalories), unit: "kcal", color: stats.averageNetCalories > 0 ? .red : .green)
            }
            .padding(.horizontal)
            
            // Macro breakdown
            VStack(alignment: .leading, spacing: 8) {
                Text("Average Macronutrients")
                    .font(.headline)
                    .padding(.horizontal)
                
                MacroBar(title: "Protein", value: stats.averageProtein, unit: "g", color: .red)
                MacroBar(title: "Carbs", value: stats.averageCarbs, unit: "g", color: .blue)
                MacroBar(title: "Fats", value: stats.averageFats, unit: "g", color: .yellow)
            }
            .padding()
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
            // Activity summary
            HStack(spacing: 20) {
                VStack {
                    Text("\(stats.totalFoodEntries)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Food Entries")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                
                Divider()
                
                VStack {
                    Text("\(stats.totalWorkouts)")
                        .font(.title)
                        .fontWeight(.bold)
                    Text("Workouts")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            .frame(maxWidth: .infinity)
            .background(Color(.systemGray6))
            .cornerRadius(12)
            .padding(.horizontal)
            
                    // Daily trend chart
            if !stats.dailySummaries.isEmpty && stats.dailySummaries.count > 1 {
                VStack(alignment: .leading, spacing: 8) {
                    Text("Daily Trend")
                        .font(.headline)
                        .padding(.horizontal)
                    
                    Chart {
                        ForEach(stats.dailySummaries) { summary in
                            LineMark(
                                x: .value("Date", summary.date, unit: .day),
                                y: .value("Calories", summary.totalCaloriesConsumed)
                            )
                            .foregroundStyle(.blue)
                            .symbol(.circle)
                            
                            LineMark(
                                x: .value("Date", summary.date, unit: .day),
                                y: .value("Calories", summary.totalCaloriesBurnt)
                            )
                            .foregroundStyle(.orange)
                            .symbol(.square)
                        }
                    }
                    .chartYAxis {
                        AxisMarks(position: .leading)
                    }
                    .frame(height: 200)
                    .padding()
                    .background(Color(.systemGray6))
                    .cornerRadius(12)
                    .padding(.horizontal)
                }
            }
        }
        .padding(.vertical)
    }
    
    private func loadStatistics() {
        let service = StatisticsService.shared
        let date = Date()
        
        switch selectedPeriod {
        case .daily:
            let summary = service.getDailySummary(for: date)
            statistics = StatisticsSummary(
                period: "daily",
                startDate: date,
                endDate: date,
                averageCaloriesConsumed: summary.totalCaloriesConsumed,
                averageCaloriesBurnt: summary.totalCaloriesBurnt,
                averageNetCalories: summary.netCalories,
                averageProtein: summary.totalProtein,
                averageCarbs: summary.totalCarbs,
                averageFats: summary.totalFats,
                totalWorkouts: summary.workoutCount,
                totalFoodEntries: summary.foodEntryCount,
                dailySummaries: [summary]
            )
        case .weekly:
            statistics = service.getWeeklySummary(for: date)
        case .monthly:
            statistics = service.getMonthlySummary(for: date)
        case .yearly:
            statistics = service.getYearlySummary(for: date)
        case .custom:
            statistics = service.getStatisticsSummary(period: "custom", startDate: customStartDate, endDate: customEndDate)
        }
    }
}

struct StatCard: View {
    let title: String
    let value: String
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            VStack(alignment: .leading) {
                Text(title)
                    .font(.caption)
                    .foregroundColor(.secondary)
                HStack(alignment: .firstTextBaseline, spacing: 4) {
                    Text(value)
                        .font(.title2)
                        .fontWeight(.bold)
                    Text(unit)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            Spacer()
        }
        .padding()
        .background(color.opacity(0.1))
        .cornerRadius(12)
    }
}

struct MacroBar: View {
    let title: String
    let value: Double
    let unit: String
    let color: Color
    
    var body: some View {
        HStack {
            Text(title)
                .frame(width: 80, alignment: .leading)
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    Rectangle()
                        .fill(Color(.systemGray5))
                        .frame(height: 20)
                    
                    Rectangle()
                        .fill(color)
                        .frame(width: geometry.size.width * min(value / 200.0, 1.0), height: 20)
                }
            }
            .frame(height: 20)
            
            Text("\(Int(value)) \(unit)")
                .font(.caption)
                .frame(width: 60, alignment: .trailing)
        }
        .padding(.horizontal)
    }
}

#Preview {
    StatisticsView()
}

