import Foundation

struct OpenWeatherResponse<Result: Codable>: Codable {
    var cod: String?
    var message: String?
    
    let result: Result
    
    init(from decoder: Decoder) throws {
        let container: KeyedDecodingContainer<OpenWeatherResponse<Result>.CodingKeys> = try decoder.container(keyedBy: OpenWeatherResponse<Result>.CodingKeys.self)
        self.message = try container.decodeIfPresent(String.self, forKey: OpenWeatherResponse<Result>.CodingKeys.message)

        do {
            cod = try String(container.decode(Int.self, forKey: .cod))
        } catch DecodingError.typeMismatch {
            cod = try container.decode(String.self, forKey: .cod)
        } catch {
            cod = nil
        }

        if let cod, cod != "200" {
            throw AppError.errorDescription(message ?? "")
        }
        
        self.result = try Result(from: decoder)
    }
}

///
/// [one-call-parameter](https://openweathermap.org/api/one-call-api#parameter)
///
struct OneCall: Codable, Equatable {
    var lat: Double
    var lon: Double
    var current: Forecast
    var hourly: [Forecast]
    var daily: [DailyForecast]
    
    static func == (lhs: OneCall, rhs: OneCall) -> Bool {
        (lhs.lat, lhs.lon) == (rhs.lat, rhs.lon)
    }
}

struct Forecast: Codable, Identifiable {
    var id: Int { dt }
    
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
    var wind_gust: Double?
    var weather: [Condition]
    var pop: Double?
    var rain: VolumeForLastHour?
    var snow: VolumeForLastHour?
    
    struct VolumeForLastHour: Codable {
        var lastHour: Double?
    
        enum CodingKeys: String, CodingKey {
            case lastHour = "1h"
        }
    }
}

struct DailyForecast: Codable, Identifiable {
    var id: Int { dt }
    
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
    var snow: Double?
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

    struct Condition: Codable, Identifiable {
     var id: Int
     var main: String
     var description: String
     var icon: String
    }
}
