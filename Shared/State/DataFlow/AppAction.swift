import Foundation

enum AppAction {
    case find
    case findCityDone(result: Result<[Find.City], AppError>)
}