import Foundation
import Combine

protocol AppRequest {
    associatedtype T
    var publisher: AnyPublisher<T, AppError> { get }

    var appid: String { get }
}

extension AppRequest {

    var appid: String { "" }
}

struct FindRequest: AppRequest {

    let keyword: String

    var publisher: AnyPublisher<Find, AppError> {
        guard let q = keyword.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed),
              let url = URL(string: "https://openweathermap.org/data/2.5/find?q=\(q)&appid=\(appid)&units=metric")
            else {
            return Fail(error: AppError.badURL)
                .eraseToAnyPublisher()
        }

        return URLSession.shared
            .dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: Find.self, decoder: JSONDecoder())
            .mapError { AppError.networkingFailed($0) }
            .eraseToAnyPublisher()
    }
}

