import Foundation

///
/// [one-call-parameter](https://openweathermap.org/api/one-call-api#parameter)
///
struct OneCall: Codable {
    var lat: Double
    var lon: Double
    var current: Forecast
    var hourly: [Forecast]
    var daily: [DailyForecast]
}

struct Forecast: Codable {
    var dt: Int
    var sunrise: Int?
    var sunset: Int?
    var temp: Double
    var feels_like: Double
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var uvi: Double
    var clouds: Double
    var visibility: Double
    var wind_speed: Double
    var wind_deg: Int
    var wind_gust: Double
    var weather: [Condition]
    var pop: Double?
}

struct DailyForecast: Codable {
    var dt: Int
    var sunrise: Int
    var sunset: Int
    var moonrise: Int
    var moonset: Int
    var moon_phase: Double
    var temp: Temp
    var feels_like: Temp
    var pressure: Int
    var humidity: Int
    var dew_point: Double
    var wind_speed: Double
    var wind_deg: Int
    var weather: [Forecast.Condition]
    var clouds: Double
    var pop: Double
    var rain: Double?
    var uvi: Double

    struct Temp: Codable {
        var day: Double
        var night: Double
        var eve: Double
        var morn: Double
        var min: Double?
        var max: Double?
    }
}

extension Forecast {

    struct Condition: Codable {
     var id: Int
     var main: String
     var description: String
     var icon: String
    }
}