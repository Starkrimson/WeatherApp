import Foundation

enum AppError: Error, Identifiable {
    var id: String { localizedDescription }

    case badURL
    case networkingFailed(Error)
}

extension AppError: LocalizedError {
    var localizedDescription: String {
        switch self {
        case .badURL: return "无效 URL"
        case .networkingFailed(let error):
            return error.localizedDescription
        }
    }
}