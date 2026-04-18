import Foundation

enum AppError: Error, LocalizedError {
    case invalidResponse
    case httpStatus(Int)
    case decodingError(String)
    case noData
    case locationUnavailable

    var errorDescription: String? {
        switch self {
        case .invalidResponse:
            return "Geçersiz sunucu yanıtı alındı."
        case let .httpStatus(code):
            return "Sunucu hatası: \(code)"
        case let .decodingError(reason):
            return "Veri işleme hatası: \(reason)"
        case .noData:
            return "Gösterilecek veri bulunamadı."
        case .locationUnavailable:
            return "Konum bilgisi alınamadı."
        }
    }
}
