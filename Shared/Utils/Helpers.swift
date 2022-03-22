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
        "\(Int(self - 273.15))°C"
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