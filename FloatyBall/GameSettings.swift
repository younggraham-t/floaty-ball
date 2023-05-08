//
//  GameSettings.swift
//  FloatyBall
//
//  Created by Graham on 4/29/23.
//

import Foundation
import SwiftUI


enum Difficulty: String, CaseIterable, Identifiable {
    case Easy, Normal, Hard
    var id: Self { self }
}

class Settings: ObservableObject {
    
    var difficulty: Difficulty
//    @Published var scoreManager: ScoreManager
    
    var collectableMoveSpeed: Double {
        let output = Constants.OBJECT_MOVE_SPEED
        switch self.difficulty {
        case .Easy:
            return output - 50.0
        case .Normal:
            return output
        case .Hard:
            return output + 50.0

        }
    }
    var deltaMoveSpeed: Double {
        let output = Constants.DELTA_OBJECT_SPEED
        switch self.difficulty {
        case .Easy:
            return output - 25.0
        case .Normal:
            return output
        case .Hard:
            return output + 25.0

        }
    }
    
    var percentBaddies: Double {
        let output = Constants.PERCENT_BADDIES
        switch self.difficulty {
        case .Easy:
            return output - 0.25
        case .Normal:
            return output
        case .Hard:
            return output + 0.25
        }
    }
    init(difficulty: Difficulty) {
        self.difficulty = difficulty
    }

}
