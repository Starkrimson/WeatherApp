import Foundation
import Combine

struct AppState {
    var search = Search()
    var cityList = CityList()
}

extension AppState {

    struct Search {
        var keyword: String = ""
        var list: [Find.City] = []
    }
}

extension AppState {
    
    struct CityList {
        
        @FileStorage(directory: .cachesDirectory, fileName: "forecast.json")
        var forecast: [Int: OneCall]?
    }
}