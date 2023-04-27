//
//  HighScore.swift
//  FloatyBall
//
//  Created by Graham on 4/27/23.
//

import Foundation



class ScoreManager: ObservableObject {
    
    @Published var lifeTimeHighScore: Int
    @Published private var currentScore: Int
    
    
    let lifeTimeHighScoreKey = "highestScore"
    
    init() {
        lifeTimeHighScore = UserDefaults.standard.integer(forKey: lifeTimeHighScoreKey)
//        lifeTimeHighScore = 0
        currentScore = 0
    }
    
    func increaseScore() {
        currentScore += 1
    }
    
    func updateLifeTimeHighScore() {
        if currentScore >= lifeTimeHighScore {
            UserDefaults.standard.set(currentScore, forKey: lifeTimeHighScoreKey)
            lifeTimeHighScore = UserDefaults.standard.integer(forKey: lifeTimeHighScoreKey)
        }
    }
    
    func getHighScore() -> Int {
        return lifeTimeHighScore
    }
    
    func getCurrentScore() -> Int {
        return currentScore
    }
}
