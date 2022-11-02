import Foundation
import ComposableArchitecture
import XCTestDynamicOverlay

struct WeatherClient {
    var searchCity: @Sendable (String) async throws -> [Find.City]
    var oneCall: @Sendable (_ lat: Double, _ lon: Double) async throws -> OneCall
}

private let appid = ""

extension DependencyValues {
    var weatherClient: WeatherClient {
        get { self[WeatherClient.self] }
        set { self[WeatherClient.self] = newValue }
    }
}

extension WeatherClient: DependencyKey {
    static var liveValue: WeatherClient = Self(
        searchCity: { query in
            guard let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://openweathermap.org/data/2.5/find?q=\(q)&appid=\(appid)&units=metric")
                else {
                throw AppError.badURL
            }
            
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(Find.self, from: data).list
        },
        oneCall: { lat, lon in
            var components = URLComponents(string: "https://openweathermap.org/data/2.5/onecall")
            components?.queryItems = [
                .init(name: "units", value: "metric"),
                .init(name: "appid", value: appid),
                .init(name: "lat", value: String(lat)),
                .init(name: "lon", value: String(lon)),
            ]
            guard let url = components?.url else {
                throw AppError.badURL
            }
            let (data, _) = try await URLSession.shared.data(from: url)
            return try JSONDecoder().decode(OneCall.self, from: data)
        }
    )
    
    static var previewValue: WeatherClient = Self { _ in
        testCities
    } oneCall: { _, _ in
        testOneCall
    }
    
    static var testValue: WeatherClient = Self(
        searchCity: unimplemented("WeatherClient.searchCity"),
        oneCall: unimplemented("WeatherClient.oneCall")
    )
}
