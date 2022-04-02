import Foundation
import ComposableArchitecture

struct WeatherClient {
    var searchCity: (String) -> Effect<[Find.City], AppError>
    var oneCall: (_ lat: Double, _ lon: Double) -> Effect<OneCall, AppError>
}

private let appid = ""

extension WeatherClient {
    
    static let live = WeatherClient(
        searchCity: { query in
            guard let q = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
                  let url = URL(string: "https://openweathermap.org/data/2.5/find?q=\(q)&appid=\(appid)&units=metric")
                else {
                return Effect(error: .badURL)
            }
            
            return URLSession.shared.dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: Find.self, decoder: JSONDecoder())
                .map { $0.list }
                .mapError { AppError.networkingFailed($0) }
                .eraseToEffect()
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
                return Effect(error: .badURL)
            }
            return URLSession.shared
                .dataTaskPublisher(for: url)
                .map { $0.data }
                .decode(type: OneCall.self, decoder: JSONDecoder())
                .mapError { AppError.networkingFailed($0) }
                .eraseToEffect()
        }
    )
    
    static let failing = Self(
        searchCity: { _ in .failing("WeatherClient.searchCity") },
        oneCall: { _,_ in .failing("WeatherClient.oneCall") }
    )
}
