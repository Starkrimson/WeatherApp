import Foundation
import ComposableArchitecture

struct WeatherClient {
    var searchCity: (String) -> Effect<[Find.City], AppError>
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
        }
    )
    
    static let failing = Self(
        searchCity: { _ in .failing("WeatherClient.searchCity") }
    )
}
