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
            HStack(spacing: 2) {
                if let rain = rain {
                    Image(systemName: "cloud.rain")
                    Text(rain.toString(maximumFractionDigits: 2) + "mm")
                        .padding(.trailing, 18)
                }
                if let snow = snow {
                    Image(systemName: "cloud.snow")
                    Text(snow.toString(maximumFractionDigits: 2) + "mm")
                        .padding(.trailing, 18)
                }
            
                Image(systemName: "wind")
                Text(windSpeed.toString(maximumFractionDigits: 1) + "m/s")
                    .padding(.trailing, 18)
            
                Image(systemName: "barometer")
                Text("\(pressure)hPa")
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