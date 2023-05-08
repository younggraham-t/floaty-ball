//
//  HighScore.swift
//  FloatyBall
//
//  Created by Graham on 4/27/23.
//

import Foundation
import SwiftUI



class ScoreManager: ObservableObject {
    
    
    
    @Published var lifeTimeHighScore: Int
    private var currentScore: Int
    
    @Published var difficulty: Difficulty = .Normal
    

    
    init() {
        let diff: Difficulty = .Normal
        self.difficulty = diff
        
        currentScore = 0
        lifeTimeHighScore = UserDefaults.standard.integer(forKey: diff.rawValue)
    }
    
    func setDifficulty(newDifficulty: Difficulty) {
        self.difficulty = newDifficulty
        lifeTimeHighScore = UserDefaults.standard.integer(forKey: self.difficulty.rawValue)
    }
   
    
    
    func increaseScore() {
        currentScore += 1
    }
    
    func updateLifeTimeHighScore() {
        if currentScore >= lifeTimeHighScore {
        
            UserDefaults.standard.set(currentScore, forKey: self.difficulty.rawValue)
            lifeTimeHighScore = UserDefaults.standard.integer(forKey: self.difficulty.rawValue)
        
            
        }
    }

    
    func getCurrentScore() -> Int {
        return currentScore
    }
}
