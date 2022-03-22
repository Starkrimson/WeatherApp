import Foundation
import Combine

struct AppState {
    var search = Search()
}

extension AppState {

    struct Search {
        var keyword: String = ""
        var list: [Find.City] = []
    }
}
