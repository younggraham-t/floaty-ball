//
//  Collectable.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SpriteKit

protocol Collectable {
    func initPhysicsBody();
    func update(screen: CGRect) -> Bool;
}

// super class of goodies and baddies
class CollectableObject: SKShapeNode, Collectable {

    var moveSpeed: Double = Constants.OBJECT_MOVE_SPEED
    var moveDirection: Direction = .west //default direction
    
    var velocity: CGVector {
        
        var dx: Double = 0
        var dy: Double = 0
        
        switch moveDirection {
        case .north:
            dy = moveSpeed
        case .south:
            dy = -moveSpeed
        case .east:
            dx = moveSpeed
        case .west:
            dx = -moveSpeed
        }
        
        return CGVector(dx: dx,  dy: dy)
    }
    
    func setColorParams(strokeColor: UIColor, fillColor: UIColor) {
        self.fillColor = fillColor
        self.strokeColor = strokeColor
        self.glowWidth = 1.0
        self.isAntialiased = true
    }
    
    
    
    func initPhysicsBody() {
        if let path = self.path {
            self.physicsBody = SKPhysicsBody(polygonFrom: path)
        }
        self.physicsBody?.collisionBitMask = 0b0000
        self.physicsBody?.contactTestBitMask = 0b0001
    }
    
    
    // returns true if self is off the screen in the move direction
    func update(screen: CGRect) -> Bool {
        self.physicsBody?.velocity = self.velocity
        
        switch moveDirection {
        case .north:
            if self.position.y > screen.maxY {
                return true
            }
        case .south:
            if self.position.y < screen.minY {
                return true
            }
        case .east:
            if self.position.x > screen.maxX {
                return true
            }
        case .west:
            if self.position.x < screen.minX {
                return true
            }
        }
        return false
    }
    
    func increaseSpeed(by amount: Double) {
        self.moveSpeed += amount
    }
    
}
