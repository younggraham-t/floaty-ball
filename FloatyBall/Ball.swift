//
//  Ball.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//


import SpriteKit


class Ball : SKShapeNode {
    
    var velocity: CGVector = .zero
    
    var ballDiameter = Constants.DEFAULT_BALL_DIAMETER
    
    var moveSpeed: Double = Constants.OBJECT_MOVE_SPEED

    override init() {
        super.init()
        
        
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ballDiameter, height: ballDiameter))
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
            if self.position.y > screen.maxY - self.frame.height {
//                print("off top")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dy = moveSpeed
            }
        case .south:
            if self.position.y < screen.minY + Double(Constants.DEFAULT_BALL_DIAMETER) {
//                print("off bottom")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dy = -moveSpeed
            }
        case .east:
            if self.position.x > screen.maxX - self.frame.width {
//                print("off right")
                self.velocity.dx = .zero
            }
            else {
                self.velocity.dx = moveSpeed
            }
        case .west:
            if self.position.x < screen.minX + Double(Constants.DEFAULT_BALL_DIAMETER) {
//                print("off left")
                self.velocity.dx = .zero
            }
            else {
                self.velocity.dx = -moveSpeed
            }
        case .northwest:
            if self.position.x < screen.minX + Double(Constants.DEFAULT_BALL_DIAMETER) {
//                print("off left")
                self.velocity.dx = .zero
            }
            else if self.position.y > screen.maxY - self.frame.height {
//                print("off top")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dx = -moveSpeed
                self.velocity.dy = moveSpeed
            }
        case .northeast:
            if self.position.y > screen.maxY - self.frame.height {
//                print("off top")
                self.velocity.dy = .zero
            }
            else if self.position.x > screen.maxX - self.frame.width {
//                print("off right")
                self.velocity.dx = .zero
            }
            else {
                self.velocity.dx = moveSpeed
                self.velocity.dy = moveSpeed
            }
        case .southwest:
            if self.position.x < screen.minX + Double(Constants.DEFAULT_BALL_DIAMETER) {
//                print("off left")
                self.velocity.dx = .zero
            }
            else if self.position.y < screen.minY + Double(Constants.DEFAULT_BALL_DIAMETER) {
//                print("off bottom")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dx = -moveSpeed
                self.velocity.dy = -moveSpeed
            }
        case .southeast:
            if self.position.x > screen.maxX - self.frame.width {
//                print("off right")
               self.velocity.dx = .zero
            }
            else if self.position.y < screen.minY + Double(Constants.DEFAULT_BALL_DIAMETER) {
//                print("off bottom")
                self.velocity.dy = .zero
            }
            else {
                self.velocity.dx = moveSpeed
                self.velocity.dy = -moveSpeed
            }
        }
    }
    
    //returns whether the ball size overflowed
    func increaseBallSize() -> Bool {
//        print("increase")
        if ballDiameter < Constants.BALL_SIZE_MAX_DIAMETER {
            ballDiameter += Constants.BALL_SIZE_DELTA
            //decrease the ball speed
            if moveSpeed > Constants.MIN_BALL_SPEED {
                moveSpeed -= Constants.DELTA_BALL_SPEED
            }
            updatePath()
            return false
        }
        else {
            ballDiameter = Constants.DEFAULT_BALL_DIAMETER
            //reset the ball speed
            moveSpeed = Constants.OBJECT_MOVE_SPEED
            updatePath()
            return true
        }
        
    }
    
    //returns whether the ball size overflowed
    func decreaseBallSize() -> Bool {
        if ballDiameter > Constants.BALL_SIZE_MIN_DIAMETER {
            ballDiameter -= Constants.BALL_SIZE_DELTA
            //increase the ball speed
            moveSpeed += Constants.DELTA_BALL_SPEED
            updatePath()
            return false
        }
        else {
            return true
        }
        
    }
    
    func updatePath() {
//        print(ballDiameter)
        let path = UIBezierPath(ovalIn: CGRect(x: 0, y: 0, width: ballDiameter, height: ballDiameter))
        self.path = path.cgPath
        self.physicsBody = SKPhysicsBody(polygonFrom: path.cgPath)
    }
    
    func stopMovement() {
        stopXMovement()
        stopYMovement()
    }
    
    func stopXMovement() {
        self.velocity.dx = .zero
    }
    
    func stopYMovement() {
        self.velocity.dy = .zero
        
    }
    
}
