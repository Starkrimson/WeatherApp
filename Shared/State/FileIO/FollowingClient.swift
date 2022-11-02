import Foundation
import ComposableArchitecture
import CoreData

struct FollowingClient {
    var fetch: @Sendable () async throws -> [CityViewModel]
    var save: @Sendable (CityViewModel) throws -> CityViewModel
    var delete: @Sendable (CityViewModel) throws -> CityViewModel
    var move: @Sendable ([CityViewModel], _ indexSet: IndexSet, _ toIndex: Int) throws -> [CityViewModel]
}

extension DependencyValues {
    var followingClient: FollowingClient {
        get { self[FollowingClient.self] }
        set { self[FollowingClient.self] = newValue }
    }
}

extension FollowingClient: DependencyKey {
    static var liveValue: FollowingClient = Self(
        fetch: {
            let context = Persistence.shared.viewContext
            let request = FollowingCity.fetchRequest()
            request.sortDescriptors = [
                .init(keyPath: \FollowingCity.index, ascending: true)
            ]
            return try context.fetch(request).map(CityViewModel.init)
        },
        save: {
            let viewContext = Persistence.shared.viewContext
            let object = $0.instance(with: viewContext)
            if viewContext.hasChanges {
                try viewContext.save()
            }
            return $0
        },
        delete: {
            let viewContext = Persistence.shared.viewContext
            let object = $0.instance(with: viewContext)
            viewContext.delete(object)
            if viewContext.hasChanges {
                try viewContext.save()
            }
            return $0
        },
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
            
            try Persistence.shared.viewContext.save()
            return list
        }
    )
    
//    static let falling = Self(
//        fetch: { .failing("FollowingClient.fetch") },
//        save: { _ in .failing("FollowingClient.save") },
//        delete: { _ in .failing("FollowingClient.delete") },
//        move: { _,_,_ in .failing("FollowingClient.move") }
//    )
}
