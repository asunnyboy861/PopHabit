import Foundation

enum Trend: String, Codable {
    case improving
    case stable
    case needsLove

    var displayName: String {
        switch self {
        case .improving: "Improving"
        case .stable: "Stable"
        case .needsLove: "Needs Love"
        }
    }

    var systemName: String {
        switch self {
        case .improving: "arrow.up.right"
        case .stable: "arrow.right"
        case .needsLove: "heart"
        }
    }

    var colorHex: String {
        switch self {
        case .improving: "34C759"
        case .stable: "007AFF"
        case .needsLove: "FF6B9D"
        }
    }
}
