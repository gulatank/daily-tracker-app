import Foundation
import CoreData

@objc(FoodEntryEntity)
public class FoodEntryEntity: NSManagedObject {
    
}

extension FoodEntryEntity {
    @nonobjc public class func fetchRequest() -> NSFetchRequest<FoodEntryEntity> {
        return NSFetchRequest<FoodEntryEntity>(entityName: "FoodEntryEntity")
    }
    
    @NSManaged public var id: UUID?
    @NSManaged public var timestamp: Date?
    @NSManaged public var foodName: String?
    @NSManaged public var quantity: Double
    @NSManaged public var unit: String?
    @NSManaged public var calories: Double
    @NSManaged public var protein: Double
    @NSManaged public var carbs: Double
    @NSManaged public var fats: Double
    @NSManaged public var fiber: Double
    @NSManaged public var sugar: Double
    @NSManaged public var sodium: Double
    @NSManaged public var recordingUrl: String?
    @NSManaged public var transcription: String?
}

extension FoodEntryEntity: Identifiable {
    
}

struct FoodEntry: Codable, Identifiable {
    let id: UUID
    let timestamp: Date?
    let foodName: String
    let quantity: Double
    let unit: String
    let calories: Double
    let protein: Double
    let carbs: Double
    let fats: Double
    let fiber: Double
    let sugar: Double
    let sodium: Double
    let recordingUrl: String?
    let transcription: String?
    
    init(id: UUID = UUID(), timestamp: Date? = Date(), foodName: String, quantity: Double, unit: String, calories: Double, protein: Double, carbs: Double, fats: Double, fiber: Double = 0, sugar: Double = 0, sodium: Double = 0, recordingUrl: String? = nil, transcription: String? = nil) {
        self.id = id
        self.timestamp = timestamp
        self.foodName = foodName
        self.quantity = quantity
        self.unit = unit
        self.calories = calories
        self.protein = protein
        self.carbs = carbs
        self.fats = fats
        self.fiber = fiber
        self.sugar = sugar
        self.sodium = sodium
        self.recordingUrl = recordingUrl
        self.transcription = transcription
    }
}

extension FoodEntry {
    func toEntity(context: NSManagedObjectContext) -> FoodEntryEntity {
        let entity = FoodEntryEntity(context: context)
        entity.id = self.id
        entity.timestamp = self.timestamp
        entity.foodName = self.foodName
        entity.quantity = self.quantity
        entity.unit = self.unit
        entity.calories = self.calories
        entity.protein = self.protein
        entity.carbs = self.carbs
        entity.fats = self.fats
        entity.fiber = self.fiber
        entity.sugar = self.sugar
        entity.sodium = self.sodium
        entity.recordingUrl = self.recordingUrl
        entity.transcription = self.transcription
        return entity
    }
    
    init(from entity: FoodEntryEntity) {
        self.id = entity.id ?? UUID()
        self.timestamp = entity.timestamp ?? Date()
        self.foodName = entity.foodName ?? ""
        self.quantity = entity.quantity
        self.unit = entity.unit ?? ""
        self.calories = entity.calories
        self.protein = entity.protein
        self.carbs = entity.carbs
        self.fats = entity.fats
        self.fiber = entity.fiber
        self.sugar = entity.sugar
        self.sodium = entity.sodium
        self.recordingUrl = entity.recordingUrl
        self.transcription = entity.transcription
    }
}

