import Foundation

struct CityViewModel: Codable, Identifiable, CustomStringConvertible, Equatable {
    
    init(city: Find.City) {
        self.city = city
    }
    
    private let city: Find.City
    
    var id: Int { city.id }
    var name: String { city.name }
    var coord: Find.City.Coord { city.coord }
    var country: String { city.sys.country }
    
    var description: String {
        "\(name), \(country)"
    }
}
