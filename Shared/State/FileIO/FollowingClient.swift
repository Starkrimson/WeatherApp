import Foundation
import ComposableArchitecture
import CoreData

struct FollowingClient {
    var fetch: () -> Effect<[CityViewModel], AppError>
    var save: (CityViewModel) -> Effect<CityViewModel, Never>
    var delete: (CityViewModel) -> Effect<CityViewModel, Never>
    var move: ([CityViewModel], _ indexSet: IndexSet, _ toIndex: Int) -> Effect<[CityViewModel], AppError>
}

extension FollowingClient {
    static let live = Self(
        fetch: {
            Persistence.shared.fetch(FollowingCity.self, sortDescriptors: [
                .init(keyPath: \FollowingCity.index, ascending: true)
            ])
            .map { $0.map(CityViewModel.init) }
        },
        save: {
            Persistence.shared.save($0)
                .map { .init(city: $0 as! FollowingCity) }
        },
        delete: Persistence.shared.delete,
        move: { list, indexSet, toIndex in
            var list = list
            list.move(fromOffsets: indexSet, toOffset: toIndex)
            let range: Range<Int> = {
                let fromIndex = indexSet.first!
                if fromIndex < toIndex {
                    return fromIndex..<toIndex
                }
                return toIndex..<fromIndex+1
            }()
            range.forEach { i in
                list[i].index = i
                if let objId = list[i].objectID,
                   let obj = Persistence.shared.viewContext.object(with: objId) as? FollowingCity {
                    obj.index = Int32(i)
                }
            }
            
            do {
                try Persistence.shared.viewContext.save()
                return Effect(value: list)
            } catch {
                return Effect(error: .networkingFailed(error))
            }
        }
    )
    
    static let falling = Self(
        fetch: { .failing("FollowingClient.fetch") },
        save: { _ in .failing("FollowingClient.save") },
        delete: { _ in .failing("FollowingClient.delete") },
        move: { _,_,_ in .failing("FollowingClient.move") }
    )
}

