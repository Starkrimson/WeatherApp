import Foundation

enum AppAction {
    case find
    case findCityDone(result: Result<[Find.City], AppError>)
    case clearFind
    
    case follow(city: CityViewModel)
    
    case loadCityForecast(city: CityViewModel)
    case loadCityForecastDone(result: Result<(Int, OneCall), AppError>)
}