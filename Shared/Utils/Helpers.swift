import Foundation

extension String {

    /// "cn".flagUrl => 🇨🇳
    var flagURL: URL {
        URL(string: "https://openweathermap.org/images/flags/\(lowercased()).png")!
    }

    ///
    /// "09d".weatherIconURL => 🌧
    /// [icon URL](https://openweathermap.org/weather-conditions#How-to-get-icon-URL)
    ///
    var weatherIconURL: URL {
        URL(string: "https://openweathermap.org/img/wn/\(self)@2x.png")!
    }
}

extension Double {

    // 开尔文转摄氏度
    var k2c: String {
        (self - 273.15).toString(maximumFractionDigits: 0) + "°C"
    }
    
    var celsius: String {
        toString(maximumFractionDigits: 0) + "°C"
    }

    var toString: String {
        toString()
    }

    func toString(maximumFractionDigits: Int = 3) -> String {
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = maximumFractionDigits
        let number = NSNumber(value: self)
        return formatter.string(from: number) ?? ""
    }
}

extension Int {
    
    var toDate: Date {
        Date(timeIntervalSince1970: Double(self))
    }
}

extension Date {
    
    func string(_ localizedDateFormatFromTemplates: String..., locale identifier: String? = Locale.preferredLanguages.first) -> String {
        let dateFormatter = DateFormatter()
        let template = localizedDateFormatFromTemplates.reduce(into: "") { $0 += $1 }
        dateFormatter.locale = Locale(identifier: identifier ?? "en_US")
        dateFormatter.setLocalizedDateFormatFromTemplate(template)
        return dateFormatter.string(from: self)
    }
}