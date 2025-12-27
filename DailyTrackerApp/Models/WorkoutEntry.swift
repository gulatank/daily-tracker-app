import Foundation
import CoreData

@objc(WorkoutEntryEntity)
public class WorkoutEntryEntity: NSManagedObject {
    
}

extension WorkoutEntryEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<WorkoutEntryEntity> {
        return NSFetchRequest<WorkoutEntryEntity>(entityName: "WorkoutEntryEntity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var activityType: String?
    @NSManaged public var duration: Double
    @NSManaged public var intensity: String?
    @NSManaged public var caloriesBurnt: Double
    @NSManaged public var metValue: Double
    @NSManaged public var recordingUrl: String?
    @NSManaged public var transcription: String?
}

extension WorkoutEntryEntity: Identifiable {
    
}

struct WorkoutEntry: Codable, Identifiable {
    let id: UUID
    let timestamp: Date?
    let activityType: String
    let duration: Double // in minutes
    let intensity: String // "low", "moderate", "high"
    let caloriesBurnt: Double
    let metValue: Double
    let recordingUrl: String?
    let transcription: String?
    
    init(id: UUID = UUID(), timestamp: Date? = Date(), activityType: String, duration: Double, intensity: String, caloriesBurnt: Double, metValue: Double, recordingUrl: String? = nil, transcription: String? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.activityType = activityType
        self.duration = duration
        self.intensity = intensity
        self.caloriesBurnt = caloriesBurnt
        self.metValue = metValue
        self.recordingUrl = recordingUrl
        self.transcription = transcription
    }
}

extension WorkoutEntry {
    func toEntity(context: NSManagedObjectContext) -> WorkoutEntryEntity {
        let entity = WorkoutEntryEntity(context: context)
        entity.id = self.id
        entity.timestamp = self.timestamp
        entity.activityType = self.activityType
        entity.duration = self.duration
        entity.intensity = self.intensity
        entity.caloriesBurnt = self.caloriesBurnt
        entity.metValue = self.metValue
        entity.recordingUrl = self.recordingUrl
        entity.transcription = self.transcription
        return entity
    }
    
    init(from entity: WorkoutEntryEntity) {
        self.id = entity.id ?? UUID()
        self.timestamp = entity.timestamp ?? Date()
        self.activityType = entity.activityType ?? ""
        self.duration = entity.duration
        self.intensity = entity.intensity ?? "moderate"
        self.caloriesBurnt = entity.caloriesBurnt
        self.metValue = entity.metValue
        self.recordingUrl = entity.recordingUrl
        self.transcription = entity.transcription
    }
}

