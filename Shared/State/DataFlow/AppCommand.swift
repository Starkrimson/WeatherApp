import Foundation
import Combine

protocol AppCommand {
    func execute(in store: AppStore)
}

struct FindAppCommand: AppCommand {

    func execute(in store: AppStore) {
        let token = SubscriptionToken()

        FindRequest(keyword: store.appState.search.keyword)
            .publisher
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.findCityDone(result: .failure(error)))
                }
                token.unseal()
            }, receiveValue: { s in
                store.dispatch(.findCityDone(result: .success(s.list)))
            })
            .seal(in: token)
    }
}

struct OneCallCommand: AppCommand {
    let city: CityViewModel
    
    func execute(in store: AppStore) {
        let token = SubscriptionToken()
        
        OneCallRequest(lat: city.coord.lat, lon: city.coord.lon)
            .publisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completion in
                if case .failure(let error) = completion {
                    store.dispatch(.loadCityForecastDone(cityID: city.id, result: .failure(error)))
                }
                token.unseal()
            }, receiveValue: { value in
                store.dispatch(.loadCityForecastDone(cityID: city.id, result: .success(value)))
            })
            .seal(in: token)
    }
}

class SubscriptionToken {
    var cancellable: AnyCancellable?
    func unseal() { cancellable = nil }
}

extension AnyCancellable {
    func seal(in token: SubscriptionToken) {
        token.cancellable = self
    }
}
