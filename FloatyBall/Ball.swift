//
//  Ball.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//


import SpriteKit


class Ball : SKShapeNode {
    
    var velocity: CGVector = .zero
    
    var ballRadius = Constants.DEFAULT_BALL_RADIUS
    
    let ballSpeed = 125.0
    override init() {
        super.init()
        
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: Constants.DEFAULT_BALL_RADIUS, height: Constants.DEFAULT_BALL_RADIUS))
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
    
    func update() {
        self.physicsBody?.velocity = self.velocity
    }
    
    func moveIn(direction: Direction, screen: CGRect) {
        switch direction {
        case .north:
            if self.position.y > screen.maxY - Double(ballRadius){
//                print("off top")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dy = Constants.OBJECT_MOVE_SPEED
            }
        case .south:
            if self.position.y < Double(ballRadius) + screen.minY{
//                print("off bottom")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dy = -Constants.OBJECT_MOVE_SPEED
            }
        case .east:
            if self.position.x > screen.maxX - Double(ballRadius){
//                print("off right")
                self.velocity.dx = .zero
            }
            else {
                self.velocity.dx = Constants.OBJECT_MOVE_SPEED
            }
        case .west:
            if self.position.x < Double(ballRadius) + screen.minX{
//                print("off left")
                self.velocity.dx = .zero
            }
            else {
                self.velocity.dx = -Constants.OBJECT_MOVE_SPEED
            }
        }
    }
    
    //returns whether the ball size overflowed
    func increaseBallSize() -> Bool {
        print("increase")
        if ballRadius < Constants.BALL_SIZE_MAX {
            ballRadius += Constants.BALL_SIZE_DELTA
            updatePath()
            return false
        }
        else {
            ballRadius = Constants.DEFAULT_BALL_RADIUS
            updatePath()
            return true
        }
        
    }
    
    //returns whether the ball size overflowed
    func decreaseBallSize() -> Bool {
        if ballRadius > Constants.DEFAULT_BALL_RADIUS {
            ballRadius -= Constants.BALL_SIZE_DELTA
            updatePath()
            return false
        }
        else {
            ballRadius = Constants.BALL_SIZE_MAX
            updatePath()
            return true
        }
        
    }
    
    func updatePath() {
        print(ballRadius)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ballRadius, height: ballRadius))
        self.path = path.cgPath
        self.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
    }
    
    func stopMovement() {
        self.velocity = .zero
    }
    
}
