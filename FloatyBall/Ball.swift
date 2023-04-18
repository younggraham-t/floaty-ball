//
//  Ball.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//


import SpriteKit


class Ball : SKShapeNode {
    
    
    let ballSpeed = 125.0
    override init() {
        super.init()
        
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Constants.BALL_RADIUS, height: Constants.BALL_RADIUS))
//        let path = UIBezierPath()
//        path.move(to: CGPoint(x: 0.0, y: r * 2.0))
//        path.addLine(to: CGPoint(x: -r, y: -r * 2.0))
//        path.addLine(to: CGPoint(x: r, y: -r * 2.0))
//        path.addLine(to: CGPoint(x: 0.0, y: r * 2.0))
        self.path = path.cgPath
        
        self.fillColor = .blue
        self.strokeColor = .white
        self.glowWidth = 1.0
        self.isAntialiased = true
        
        self.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
        self.physicsBody?.collisionBitMask = 0b0000
        self.physicsBody?.contactTestBitMask = 0b0001
        
        self.name = NodeNames.ball.rawValue
        
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
