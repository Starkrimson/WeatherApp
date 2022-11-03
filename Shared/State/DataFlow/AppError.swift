import Foundation

enum AppError: Error, Equatable, Identifiable {
    var id: String { localizedDescription }

    case badURL
    case networkingFailed(Error)
    case errorDescription(String)
    
    static func ==(lhs: AppError, rhs: AppError) -> Bool {
        lhs.id == rhs.id
    }
}

extension AppError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .badURL: return "无效 URL"
        case .networkingFailed(let error):
            return error.localizedDescription
        case .errorDescription(let description):
            return description
        }
    }
}
