import Foundation
import Combine

struct AppState {
    var search = Search()
    var cityList = CityList()
}

extension AppState {

    class Search {
        @Published var keyword: String = ""
        var list: [Find.City] = []
        
        var state: State = .normal
        
        enum State: Equatable {
            case normal, loading, noResult, failed(String)
        }
    }
}

extension AppState {
    
    struct CityList {
        
        @FileStorage(directory: .cachesDirectory, fileName: "forecast.json")
        var forecast: [Int: OneCall]?
        
        @FileStorage(directory: .documentDirectory, fileName: "followingList.json")
        var followingList: [CityViewModel]?
        
        var loadingCityIDSet: Set<Int> = []
        
        func isFollowing(_ id: Int) -> Bool {
            followingList?.contains(where: { $0.id == id }) == true
        }
    }
}