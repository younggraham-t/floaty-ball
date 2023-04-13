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
    
    var gameScene: GameScene {
        let gameScene = GameScene()
        gameScene.scaleMode = .resizeFill
        gameScene.presentingView = self
        return gameScene
    }
    
    var body: some View {
        SpriteView(scene: gameScene)
    }
}

struct GameplayView_Previews: PreviewProvider {
    static var previews: some View {
        GameplayView()
    }
}
