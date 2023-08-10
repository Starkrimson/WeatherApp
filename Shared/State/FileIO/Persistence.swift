import CoreData
import CustomDump
import ComposableArchitecture

class Persistence {
    
    static let shared = Persistence()
    private init() { }
    
    var viewContext: NSManagedObjectContext {
        container.viewContext
    }
    
    lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Weather")
        container.loadPersistentStores { _, error in
            if let error = error {
                customDump(error)
            }
        }
        return container
    }()
}

protocol ManagedObject {
    func instance(with context: NSManagedObjectContext) -> NSManagedObject
}
