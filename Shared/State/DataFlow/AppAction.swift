import Foundation

enum AppAction {
    case find
    case findCityDone(result: Result<[Find.City], AppError>)
    
    case loadCityForecast(city: CityViewModel)
    case loadCityForecastDone(result: Result<(Int, OneCall), AppError>)
}