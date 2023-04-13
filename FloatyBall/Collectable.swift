//
//  Collectable.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SpriteKit

// super class of goodies and baddies
class Collectable: SKShapeNode {
    
    var moveSpeed = Constants.COLLECTABLE_MOVE_SPEED
    
    override init() {
        super.init()
        
        
    }
    
    func initPhysicsBody() {
        if let path = self.path {
            self.physicsBody = SKPhysicsBody(polygonFrom: path)
        }
        self.physicsBody?.collisionBitMask = 0b0000
        self.physicsBody?.contactTestBitMask = 0b0001
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func update(screen: CGRect) {
        
    }
    
}
