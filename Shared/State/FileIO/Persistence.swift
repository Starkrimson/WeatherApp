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
        
    func fetch<T>(_ type: T.Type, sortDescriptors: [NSSortDescriptor]? = nil)
    -> Effect<[T], AppError> where T: NSManagedObject {
        do {
            let context = Persistence.shared.viewContext
            let request = T.fetchRequest()
            request.sortDescriptors = sortDescriptors
            let value = try context.fetch(request)
            return Effect(value: value as! [T])
        } catch {
            return Effect(error: .networkingFailed(error))
        }
    }
    
    func save<Element>(_ e: Element)
    -> Effect<NSManagedObject, Never> where Element: ManagedObject {
        let object = e.instance(with: viewContext)
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        return Effect(value: object)
    }
    
    func delete<Element>(_ e: Element)
    -> Effect<Element, Never> where Element: ManagedObject {
        let object = e.instance(with: viewContext)
        viewContext.delete(object)
        if viewContext.hasChanges {
            try? viewContext.save()
        }
        return Effect(value: e)
    }
}

protocol ManagedObject {
    func instance(with context: NSManagedObjectContext) -> NSManagedObject
}
