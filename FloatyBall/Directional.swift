//
//  Directional.swift
//  FloatyBall
//
//  Created by Graham on 4/20/23.
//

import Foundation
import SpriteKit

class Directional: SKSpriteNode {
    
//    let r = 10.0

    let direction: Direction
    
    init(direction: Direction) {
        self.direction = direction
        
        let texture: SKTexture
        switch direction {
        case .north:
            texture = SKTexture(imageNamed: "up-arrow.png")
        case .south:
            texture = SKTexture(imageNamed: "down-arrow.png")
        case .east:
            texture = SKTexture(imageNamed: "right-arrow.png")
        case .west:
            texture = SKTexture(imageNamed: "left-arrow.png")
        case .northeast, .northwest:
            texture = SKTexture(imageNamed: "up-arrow.png")
        case .southeast, .southwest:
            texture = SKTexture(imageNamed: "down-arrow.png")
        }
        
        super.init(texture: texture, color: .clear, size: CGSize(width: 100, height: 100))
        
        switch direction {
        case .northeast:
            self.zRotation = -45
        case .northwest:
            self.zRotation = 45
        case .southeast:
            self.zRotation = 45
        case .southwest:
            self.zRotation = -45
        case _:
            zRotation = 0
        }
        
        
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0.0, y: r * 2.0))
//        path.addLine(to: CGPoint(x: -r, y: -r * 2.0))
//        path.addLine(to: CGPoint(x: r, y: -r * 2.0))
//        path.addLine(to: CGPoint(x: 0.0, y: r * 2.0))
//        self.path = path.cgPath
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
