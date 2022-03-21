import Foundation

struct Find: Codable {

    var message: String
    var cod: String
    var count: Int
    var list: [City]

    struct City: Codable {
        var id: Int
        var name: String
        var coord: Coord
        var main: Main
        var dt: Int
        var wind: Wind
        var sys: Sys
        var rain: Double?
        var snow: Double?
        var clouds: Clouds
        var weather: [Forecast.Condition]
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
        var temp_min: Double
        var temp_max: Double
        var pressure: Int
        var humidity: Int
        var sea_level: Int
        var grnd_level: Int
    }

    struct Wind: Codable {
        var speed: Double
        var deg: Int
    }

    struct Sys: Codable {
        var country: String
    }

    struct Clouds: Codable {
        var all: Int
    }
}