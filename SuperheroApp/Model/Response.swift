import Foundation


enum Endpoint: String {
    case characters = "characters"
    case comics = "comics"
    case creators = "creators"
    case events = "events"
    case series = "series"
    case stories = "stories"
}

enum APIError: Error, CustomNSError{
    case apiError
    case invalidEndpoint
    case noData
    case invalidResponse
    case serializationError
    
    var localizedDescription: String{
        switch self {
        case .apiError:
            return "Failed to fetch the data"
        case .invalidEndpoint:
            return "Invaid Endpoint"
        case .noData:
            return "No data"
        case .invalidResponse:
            return "Invalid Response"
        case .serializationError:
            return "Failed to decode Data"
        }
    }
    
    var errorUserInfo: [String : Any]{
        [NSLocalizedDescriptionKey: localizedDescription]
    }
}

struct ResponseModel: Codable {
    var data: Response
}

struct Response: Codable {
    let limit: Int
    let total: Int
    let count: Int
    var results: [Results]
}

struct Results: Codable {
    let id: Int
    let name: String
    var thumbnail: Thumbnail
}

struct Thumbnail: Codable {
    
    let path: String
    let type: String
    
    enum CodingKeys: String, CodingKey{
        case path
        case type = "extension"
    }
    
    enum ImageVariants: String {
        case portraitSmall = "portrait_small"
        case portraitMedium = "portrait_medium"
        case portraitXLarge = "portrait_xlarge"
        case portraitFantastic = "portrait_fantastic"
    }
    
    var imageVariant: ImageVariants = .portraitSmall
    
    var imageURL: URL? {
        return URL(string: "\(path)/\(imageVariant.rawValue).\(type)")
    }
    
    internal mutating func selectImageSize(size: ImageVariants) {
        self.imageVariant = size
    }
}

