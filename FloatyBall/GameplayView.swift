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
    
    init(highScore: ScoreManager) {
        self.highScore = highScore
    }
    
    var gameScene: GameScene {
        let gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        gameScene.presentingView = self
        gameScene.highScore = highScore
        return gameScene
    }
    
    var body: some View {
        SpriteView(scene: gameScene)
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView(highScore: ScoreManager())
    }
}
