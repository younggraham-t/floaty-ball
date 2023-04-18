//
//  Collectable.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SpriteKit

protocol Collectable {
    func initPhysicsBody();
    func update(screen: CGRect);
}

// super class of goodies and baddies
class CollectableObject: SKShapeNode, Collectable {

    var moveSpeed: Int = Constants.COLLECTABLE_MOVE_SPEED

    
    func initPhysicsBody() {
        if let path = self.path {
            self.physicsBody = SKPhysicsBody(polygonFrom: path)
        }
        self.physicsBody?.collisionBitMask = 0b0000
        self.physicsBody?.contactTestBitMask = 0b0001
    }
    
    func update(screen: CGRect) {
        
    }
    
}
