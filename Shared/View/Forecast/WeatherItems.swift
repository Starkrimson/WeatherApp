import SwiftUI

struct WeatherItems: View {
    let rain: Double?
    let snow: Double?
    let windSpeed : Double
    let pressure: Int
    let humidity: Int
    let uvi: Double
    let dewPoint: Double
    let visibility: Double?
    
    var body: some View {
        VStack(alignment: .leading) {
            HStack(spacing: 20) {
                if let rain = rain {
                    Label(rain.toString(maximumFractionDigits: 2) + "mm", systemImage: "cloud.rain")
                }
                if let snow = snow {
                    Label(snow.toString(maximumFractionDigits: 2) + "mm", systemImage: "cloud.snow")
                }
                
                Label(windSpeed.toString(maximumFractionDigits: 1) + "m/s", systemImage: "wind")
                
                Label("\(pressure)hPa", systemImage: "barometer")
            }
            
            HStack(spacing: 20) {
                Text("Humidity: \(humidity)%")
                Text("UV: \(uvi.toString)")
                Text("Dew point: \(dewPoint.celsius)")
            }
            
            if let visibility = visibility {
                Text("Visibility: \((visibility / 1000).toString(maximumFractionDigits: 1))km")
            }
        }
    }
}
