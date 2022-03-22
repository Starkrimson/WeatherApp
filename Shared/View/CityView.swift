import SwiftUI

struct CityView: View {
    @EnvironmentObject var store: Store
    let city: CityViewModel
    
    var forecast: OneCall? {
        store.appState.cityList.forecast?[city.id]
    }
    
    var current: some View {
        VStack {
            Text("\(forecast?.current.dt ?? 0)")
            Text(city.description)
                .font(.title)
                .fontWeight(.medium)
                .onAppear {
                    if forecast == nil {
                        store.dispatch(.loadCityForecast(city: city))
                    }
                }
        }
    }
    
    var hourly: some View {
        VStack {
            Text("Hourly forecast")
                .font(.title2)
                .fontWeight(.medium)
        }
    }
    
    var daily: some View {
        VStack {
            Text("8-Day forecast")
                .font(.title2)
                .fontWeight(.medium)
        }
    }
    
    var body: some View {
        ScrollView {
            current
            hourly
            daily
        }
    }
}

struct CityView_Previews: PreviewProvider {
    static var previews: some View {
        let city = CityViewModel(city: SearchView_Previews.debugList()[0])
        return CityView(city: city)
            .environmentObject(Store())
            .frame(width: 375, height: 667)
            .background(Color.black)
    }
}
