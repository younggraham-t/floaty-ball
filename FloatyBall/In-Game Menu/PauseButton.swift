//
//  PauseButton.swift
//  FloatyBall
//
//  Created by Graham on 4/29/23.
//

import Foundation
import SpriteKit

class PauseButton: SKNode {
    
    var gameScene: GameScene? = nil
    
    override init() {
        super.init()
        let rectangle = CGRect(x: 0, y: 0, width: 10, height: 30)
        
        let rectangle1 = SKShapeNode(rect: rectangle)
        rectangle1.position = CGPoint(x: frame.midX - 10, y: frame.midY)
        rectangle1.fillColor = .gray
        
        let rectangle2 = SKShapeNode(rect: rectangle)
        rectangle2.position = CGPoint(x: frame.midX + 10, y: frame.midY)
        rectangle2.fillColor = .gray
        
        addChild(rectangle1)
        addChild(rectangle2)
        
        self.isUserInteractionEnabled = true
        
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        gameScene?.pauseGame()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
