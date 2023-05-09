//
//  GameplayView.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SwiftUI
import SpriteKit

struct GameplayView: View {
    
    @Environment(\.dismiss) var dismiss
    
    var highScore: ScoreManager
    
    var difficulty: Difficulty
    
    var controlManager: ControlManager
    
    var ballSpeed: BallSpeed
    
    init(_ parameters: GameplayViewParameters) {
        self.highScore = parameters.highScore
        self.difficulty = parameters.difficulty
        self.controlManager = parameters.controlManager
        
        
        
        self.ballSpeed = parameters.ballSpeed
    }
    
    
    
    var gameScene: GameScene {
        let gameScene = GameScene()
        
        gameScene.scaleMode = .resizeFill
        gameScene.presentingView = self
        gameScene.highScore = highScore
        gameScene.settings = Settings(difficulty: difficulty)
        gameScene.controlManager = controlManager
        gameScene.ballSpeed = ballSpeed
        
        return gameScene
    }
    
    var body: some View {
    
        SpriteView(scene: gameScene)
        
    }
}

//struct GameplayView_Previews: PreviewProvider {
//    static var previews: some View {
//        GameplayView(highScore: ScoreManager())
//    }
//}
