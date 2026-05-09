import Foundation
import SwiftData

enum Frequency: String, Codable, CaseIterable {
    case daily
    case weekly
    case weekdays
    case weekends
    case custom

    var displayName: String {
        switch self {
        case .daily: "Daily"
        case .weekly: "Weekly"
        case .weekdays: "Weekdays"
        case .weekends: "Weekends"
        case .custom: "Custom"
        }
    }

    var systemName: String {
        switch self {
        case .daily: "calendar"
        case .weekly: "calendar.badge.clock"
        case .weekdays: "building.2"
        case .weekends: "sun.max"
        case .custom: "slider.horizontal.3"
        }
    }
}
