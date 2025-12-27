import SwiftUI

struct HistoryView: View {
    @State private var selectedSegment = 0
    @State private var foodEntries: [FoodEntry] = []
    @State private var workoutEntries: [WorkoutEntry] = []
    
    var body: some View {
        NavigationView {
            VStack {
                Picker("", selection: $selectedSegment) {
                    Text("Food").tag(0)
                    Text("Workouts").tag(1)
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding()
                
                if selectedSegment == 0 {
                    foodList
                } else {
                    workoutList
                }
            }
            .navigationTitle("History")
            .onAppear {
                loadEntries()
            }
            .refreshable {
                loadEntries()
            }
        }
    }
    
    private var foodList: some View {
        List {
            ForEach(groupedFoodEntries.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(formatDate(date))) {
                    ForEach(groupedFoodEntries[date] ?? [], id: \.id) { entry in
                        FoodEntryRow(entry: entry)
                    }
                    .onDelete { indexSet in
                        deleteFoodEntries(at: indexSet, for: date)
                    }
                }
            }
        }
    }
    
    private var workoutList: some View {
        List {
            ForEach(groupedWorkoutEntries.keys.sorted(by: >), id: \.self) { date in
                Section(header: Text(formatDate(date))) {
                    ForEach(groupedWorkoutEntries[date] ?? [], id: \.id) { entry in
                        WorkoutEntryRow(entry: entry)
                    }
                    .onDelete { indexSet in
                        deleteWorkoutEntries(at: indexSet, for: date)
                    }
                }
            }
        }
    }
    
    private var groupedFoodEntries: [Date: [FoodEntry]] {
        Dictionary(grouping: foodEntries) { entry in
            Calendar.current.startOfDay(for: entry.timestamp ?? Date())
        }
    }
    
    private var groupedWorkoutEntries: [Date: [WorkoutEntry]] {
        Dictionary(grouping: workoutEntries) { entry in
            Calendar.current.startOfDay(for: entry.timestamp ?? Date())
        }
    }
    
    private func loadEntries() {
        foodEntries = DataStorageManager.shared.getAllFoodEntries()
        workoutEntries = DataStorageManager.shared.getAllWorkoutEntries()
    }
    
    private func deleteFoodEntries(at offsets: IndexSet, for date: Date) {
        let entries = groupedFoodEntries[date] ?? []
        for index in offsets {
            let entry = entries[index]
            DataStorageManager.shared.deleteFoodEntry(entry)
        }
        loadEntries()
    }
    
    private func deleteWorkoutEntries(at offsets: IndexSet, for date: Date) {
        let entries = groupedWorkoutEntries[date] ?? []
        for index in offsets {
            let entry = entries[index]
            DataStorageManager.shared.deleteWorkoutEntry(entry)
        }
        loadEntries()
    }
    
    private func formatDate(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
}

#Preview {
    HistoryView()
}

