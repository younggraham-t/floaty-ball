//
//  GameScene.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    var presentingView: GameplayView? = nil
    
    var ball: Ball = Ball()
    
    override func didMove(to view: SKView) {
        print("did move")
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(ball)
        
        
    }

    override func update(_ currentTime: TimeInterval) {
        
        
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    func stopGame() {
        presentingView?.dismiss()
    }
}
