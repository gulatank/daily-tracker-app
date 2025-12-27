import CoreData
import Foundation

class CoreDataManager {
    static let shared = CoreDataManager()
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "DataModel")
        container.loadPersistentStores { description, error in
            if let error = error {
                fatalError("Core Data failed to load: \(error.localizedDescription)")
            }
        }
        container.viewContext.automaticallyMergesChangesFromParent = true
        return container
    }()
    
    var viewContext: NSManagedObjectContext {
        return container.viewContext
    }
    
    func save() throws {
        let context = container.viewContext
        if context.hasChanges {
            try context.save()
        }
    }
    
    func saveAsync() {
        let context = container.viewContext
        if context.hasChanges {
            context.perform {
                do {
                    try context.save()
                } catch {
                    print("Error saving context: \(error.localizedDescription)")
                }
            }
        }
    }
    
    func delete(_ object: NSManagedObject) {
        container.viewContext.delete(object)
        do {
            try save()
        } catch {
            print("Error saving after delete: \(error.localizedDescription)")
        }
    }
}

