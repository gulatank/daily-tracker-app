import SwiftUI

struct FoodEntryRow: View {
    let entry: FoodEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.foodName)
                    .font(.headline)
                Spacer()
                Text("\(Int(entry.calories)) kcal")
                    .font(.subheadline)
                    .foregroundColor(.secondary)
            }
            
            HStack(spacing: 12) {
                Label("\(String(format: "%.1f", entry.quantity)) \(entry.unit)", systemImage: "scalemass")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                if entry.protein > 0 || entry.carbs > 0 || entry.fats > 0 {
                    Text("P: \(Int(entry.protein))g")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("C: \(Int(entry.carbs))g")
                        .font(.caption)
                        .foregroundColor(.secondary)
                    
                    Text("F: \(Int(entry.fats))g")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            
            if let time = formatTime(entry.timestamp) {
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func formatTime(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    FoodEntryRow(entry: FoodEntry(
        foodName: "Roti",
        quantity: 2,
        unit: "pieces",
        calories: 594,
        protein: 15.7,
        carbs: 92.7,
        fats: 14.9
    ))
    .padding()
}

