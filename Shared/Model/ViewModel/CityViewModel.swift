import Foundation
import CoreData

struct CityViewModel: Identifiable, CustomStringConvertible, Equatable, Hashable {
    
    init(city: Find.City) {
        self.city = city
    }
    
    init(city: FollowingCity) {
        self.city = .init(with: city)
        self.index = Int(city.index)
        self.objectID = city.objectID
    }
    
    private let city: Find.City
    
    var index: Int?
    var objectID: NSManagedObjectID?
    
    var id: Int { city.id }
    var name: String { city.name }
    var coord: Find.City.Coord { city.coord }
    var country: String { city.sys.country }
    
    var description: String {
        "\(name), \(country)"
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

extension CityViewModel: ManagedObject {
    func instance(with context: NSManagedObjectContext) -> NSManagedObject {
        if let objectID = objectID {
            return context.object(with: objectID)
        }
        let object = FollowingCity(context: context)
        object.id = Int32(id)
        object.name = name
        object.lat = coord.lat
        object.lon = coord.lon
        object.country = country
        object.index = Int32(index ?? 0)
        return object
    }
}
