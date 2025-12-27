import SwiftUI

struct WorkoutEntryRow: View {
    let entry: WorkoutEntry
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text(entry.activityType.capitalized)
                    .font(.headline)
                Spacer()
                Text("\(Int(entry.caloriesBurnt)) kcal")
                    .font(.subheadline)
                    .foregroundColor(.orange)
            }
            
            HStack(spacing: 12) {
                Label("\(Int(entry.duration)) min", systemImage: "clock")
                    .font(.caption)
                    .foregroundColor(.secondary)
                
                Text(entry.intensity.capitalized)
                    .font(.caption)
                    .foregroundColor(.secondary)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 2)
                    .background(intensityColor(entry.intensity).opacity(0.2))
                    .cornerRadius(4)
                
                Text("MET: \(String(format: "%.1f", entry.metValue))")
                    .font(.caption)
                    .foregroundColor(.secondary)
            }
            
            if let time = formatTime(entry.timestamp) {
                Text(time)
                    .font(.caption2)
                    .foregroundColor(.secondary)
            }
        }
        .padding(.vertical, 4)
    }
    
    private func intensityColor(_ intensity: String) -> Color {
        switch intensity.lowercased() {
        case "low":
            return .green
        case "moderate":
            return .yellow
        case "high":
            return .red
        default:
            return .gray
        }
    }
    
    private func formatTime(_ date: Date?) -> String? {
        guard let date = date else { return nil }
        let formatter = DateFormatter()
        formatter.timeStyle = .short
        return formatter.string(from: date)
    }
}

#Preview {
    WorkoutEntryRow(entry: WorkoutEntry(
        activityType: "running",
        duration: 30,
        intensity: "moderate",
        caloriesBurnt: 343,
        metValue: 9.8
    ))
    .padding()
}

