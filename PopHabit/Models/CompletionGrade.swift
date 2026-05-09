import Foundation
import SwiftUI

enum CompletionGrade: String, Codable {
    case F = "F"
    case D = "D"
    case C = "C"
    case B = "B"
    case A = "A"
    case S = "S"
    case SS = "SS"
    case SSS = "SSS"

    init(rate: Double) {
        switch rate {
        case 0..<0.2: self = .F
        case 0.2..<0.35: self = .D
        case 0.35..<0.50: self = .C
        case 0.50..<0.65: self = .B
        case 0.65..<0.80: self = .A
        case 0.80..<0.90: self = .S
        case 0.90..<0.97: self = .SS
        default: self = .SSS
        }
    }

    var color: String {
        switch self {
        case .F, .D: "8E8E93"
        case .C: "FFD60A"
        case .B: "007AFF"
        case .A: "34C759"
        case .S: "34C759"
        case .SS: "AF52DE"
        case .SSS: "FFD60A"
        }
    }

    var emoji: String {
        switch self {
        case .F: "💪"
        case .D: "🌱"
        case .C: "🌿"
        case .B: "⭐"
        case .A: "🌟"
        case .S: "💎"
        case .SS: "👑"
        case .SSS: "🏆"
        }
    }

    var ringColor: Color {
        switch self {
        case .F, .D: Color(hex: "8E8E93")
        case .C: Color.xpGold
        case .B: Color.primaryBlue
        case .A, .S: Color.popGreen
        case .SS: Color.levelPurple
        case .SSS: Color.xpGold
        }
    }
}
