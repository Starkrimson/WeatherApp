import SwiftUI
import Kingfisher

struct DailyForecastDetailView: View {
    let daily: DailyForecast
    
    var temps: [(String, String, String)] {
        [
            ("Morning", daily.temp.morn, daily.feels_like.morn),
            ("Afternoon", daily.temp.day, daily.feels_like.day),
            ("Evening", daily.temp.eve, daily.feels_like.eve),
            ("Night", daily.temp.night, daily.feels_like.night),
        ]
            .map {
                ($0.0, $0.1.celsius, $0.2.celsius)
            }
    }
    
    @Environment(\.horizontalSizeClass) var horizontalSizeClass: UserInterfaceSizeClass?
    
    var body: some View {
        let weather = daily.weather.first
        VStack(alignment: .leading) {
            HStack {
                if let url = weather?.icon.weatherIconURL {
                    KFImage(url)
                        .resizable()
                        .frame(width: 80, height: 80)
                }
                VStack(alignment: .leading) {
                    Text(weather?.description.capitalized ?? "")
                        .font(.title2)
                        .fontWeight(.medium)
                    Text("The high will be \(daily.temp.max?.celsius ?? ""),\(horizontalSizeClass == .compact ? "\n" : " ")the low will be \(daily.temp.min?.celsius ?? "").")
                }
            }
            HStack {
                if horizontalSizeClass == .regular {
                    Divider()
                        .background(Color(.systemRed))
                        .padding(.leading, 10)
                        .padding(.trailing, 20)
                }
                WeatherItems(
                    rain: daily.rain,
                    snow: daily.snow,
                    windSpeed: daily.wind_speed,
                    pressure: daily.pressure,
                    humidity: daily.humidity,
                    uvi: daily.uvi,
                    dewPoint: daily.dew_point,
                    visibility: nil)
            }
                .frame(height: 50)
                .padding(.bottom, 20)
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .bottom) {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("TEMPERATURE")
                            .footnote()
                        Text("FEELS LIKE")
                            .footnote()
                    }
                    ForEach(temps, id: \.0) { item in
                        VStack(alignment: .trailing) {
                            Text(item.0)
                            Text(item.1)
                            Text(item.2)
                        }.frame(width: 100)
                    }
                }
            }
                .padding(.bottom, 20)
            HStack {
                VStack {
                    Text("SUNRISE")
                        .footnote()
                    Text(daily.sunrise.toDate.string("hh:mm"))
                }
                    .padding(.trailing, 20)
                
                VStack {
                    Text("SUNSET")
                        .footnote()
                    Text(daily.sunset.toDate.string("hh:mm"))
                }
            }
        }
    }
}

private extension Text {
    func footnote() -> some View {
        font(.footnote)
            .foregroundColor(Color(.systemGray2))
            .frame(height: 20)
    }
}

