import Foundation

struct Find: Codable {

    var message: String
    var cod: String
    var count: Int
    var list: [City]

    struct City: Codable, Equatable, Identifiable {
        var id: Int
        var name: String
        var coord: Coord
        var main: Main
        var sys: Sys
        var weather: [Forecast.Condition]
    
        static func ==(lhs: Find.City, rhs: Find.City) -> Bool {
            lhs.id == rhs.id
        }
    }
}

extension Find.City {

    struct Coord: Codable {
        var lat: Double
        var lon: Double
    }

    struct Main: Codable {
        var temp: Double
        var feels_like: Double
    }

    struct Sys: Codable {
        var country: String
    }
}