import Foundation
import Combine

///
/// [one-call-api](https://openweathermap.org/api/one-call-api)
///
struct OneCallRequest: AppRequest {

    let lat: Double
    let lon: Double

    var publisher: AnyPublisher<OneCall, AppError> {
        var components = URLComponents(string: "https://openweathermap.org/data/2.5/onecall")
        components?.queryItems = [
            .init(name: "units", value: "metric"),
            .init(name: "appid", value: appid),
            .init(name: "lat", value: String(lat)),
            .init(name: "lon", value: String(lon)),
        ]

        guard let url = components?.url else {
            return Fail(error: AppError.badURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: OneCall.self, decoder: JSONDecoder())
            .mapError { AppError.networkingFailed($0) }
            .eraseToAnyPublisher()
    }
}