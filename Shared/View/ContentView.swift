import SwiftUI

struct ContentView: View {
    var body: some View {
        Text("Hello, world!")
            .padding()
            .onTapGesture {
                let token = SubscriptionToken()
                FindRequest(keyword: "广州guangzhou")
                    .publisher
                    .sink(receiveCompletion: { completion in
                        dump(completion)
                        token.unseal()
                    }, receiveValue: { s in
                        dump(s)
                    })
                    .seal(in: token)
//                OneCallRequest(lat: 22.5455, lon: 114.0683)
//                    .publisher
//                    .sink(receiveCompletion: { completion in
//                        dump(completion)
//                        token.unseal()
//                    }, receiveValue: { s in
//                        dump(s)
//                    })
//                    .seal(in: token)
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
