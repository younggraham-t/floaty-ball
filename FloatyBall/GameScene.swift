//
//  GameScene.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SpriteKit

class GameScene : SKScene, SKPhysicsContactDelegate {
    
    //------------------ Variables -------------------
    
    
    
    var presentingView: GameplayView? = nil
    
    var ball: Ball = Ball()
    
    var collectables = Set<CollectableObject>() //uses set to make removal easier (for memory management)
    
    var currentTouches: Set<UITouch> = Set()
    
    var directionals = [Directional]()
    
    var score = 0
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: 0")
    

    // ------------------- Updates --------------------
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        //update the ball
        ball.update()
        
        // update all the collectables
        for collectable in collectables {

            if collectable.update(screen: self.frame) {
                collectable.removeFromParent()
                collectables.remove(collectable)
            }
            
        }
        
        //check all the touches for if a direction is being pressed
        for touch in currentTouches {
            for directional in directionals {
                if closeEnough(directional, touch) {
//                    print("touched the directional")
                    let direction = directional.direction
                    ball.moveIn(direction: direction, screen: self.frame)
                }
            }
        }
        
        if currentTime > Constants.SPAWN_COLLECTABLE_TIME {
            //spawn new collectables
            let doesSpawn = Double.random(in: 0...1) < Constants.COLLECTABLE_SPAWN_CHANCE
            if doesSpawn {
                spawnCollectable()
            }
        }
        
    }
    
    func spawnCollectable() {
        let isGoody = Double.random(in: 0...1) < Constants.PERCENT_BADDIES
        let newCollectable: CollectableObject
        let moveDirection = randomizeMoveDirection()
        
        if isGoody {
            newCollectable = Goody(moveDirection: moveDirection)
        }
        else {
            newCollectable = Baddy(moveDirection: moveDirection)
        }
        
        switch moveDirection {
        case .north:
            let randomInSide = Double.random(in: frame.minX...frame.maxX)
            newCollectable.position = CGPoint(x: randomInSide, y: frame.minY)
        case .south:
            let randomInSide = Double.random(in: frame.minX...frame.maxX)
            newCollectable.position = CGPoint(x: randomInSide, y: frame.maxY)
        case .east:
            let randomInSide = Double.random(in: frame.minY...frame.maxY)
            newCollectable.position = CGPoint(x: frame.minX, y: randomInSide)
        case .west:
            let randomInSide = Double.random(in: frame.minY...frame.maxY)
            newCollectable.position = CGPoint(x: frame.maxX, y: randomInSide)
        }
        collectables.insert(newCollectable)
        self.addChild(newCollectable)
    }
    
    func randomizeMoveDirection() -> Direction {
        let isHorizontal = Double.random(in: 0...1) < 0.5
        let isMin = Double.random(in: 0...1) < 0.5
        let moveDirection: Direction
        if isHorizontal {
            if isMin { // if it starts at the min and moves to the max
                moveDirection = .east
            }
            else {
                moveDirection = .west
            }
        }
        else {
            if isMin { // if it starts at the min and moves to the max
                moveDirection = .north
            }
            else {
                moveDirection = .south
            }
        }
        return moveDirection
    }
    
    
    // ------------------- Touches ----------------------
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            print("touch - began")
            currentTouches.insert(touch)
            
        }
    }
    
    func closeEnough(_ target: SKSpriteNode, _ touch: UITouch) -> Bool {
        let tolerance = 100.0
        let targetPosition = target.position
        let touchPosition = touch.location(in: self)

        let closeInX = abs(targetPosition.x - touchPosition.x) <= tolerance
        let closeInY = abs(targetPosition.y - touchPosition.y) <= tolerance
        
        return closeInX && closeInY
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touch - moved")

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("touch - ended")
        for touch in touches {
            currentTouches.remove(touch)
        }
        self.ball.stopMovement()
    }
    
    
    
    
    // ------------- Collision ------------
    

    
    func didBegin(_ contact: SKPhysicsContact) {
        guard let nodeA = contact.bodyA.node else { return }
        guard let nodeB = contact.bodyB.node else { return }
    
        
        // run two cases where either nodeA is a ball or nodeB is a ball but if either is a button just return and do nothing
        
        switch nodeA.name {
    
        case NodeNames.button.rawValue:
            return
            
        case NodeNames.ball.rawValue: //nodeA is a ball
            handleBallCase(ballNode: nodeA, nonBallNode: nodeB)
            return
            
        case NodeNames.goody.rawValue, NodeNames.baddy.rawValue: //nodeA isn't a ball
            break
            
        case _: // should never happen as long as the names are correct
            //probably should throw an error but it shouldn't be a problem and i dont want to deal with that right now
            print("invalid name for nodeA")
            
        }
        
        switch nodeB.name {
            
        case NodeNames.button.rawValue:
            return
            
        case NodeNames.ball.rawValue: //nodeB is a ball
            handleBallCase(ballNode: nodeB, nonBallNode: nodeA)
            return
            
        case NodeNames.goody.rawValue, NodeNames.baddy.rawValue: //nodeB isn't a ball
            break
            
        case _: // should never happen as long as the names are correct
            //probably should throw an error but it shouldn't be a problem and i dont want to deal with that right now
            print("invalid name for nodeB")
        }
        
    }
    
    func handleBallCase(ballNode: SKNode, nonBallNode: SKNode) {
        switch nonBallNode.name {
            
        case NodeNames.goody.rawValue: // if nonBallNode is a goody remove the goody and increase score/ball size
            remove(node: nonBallNode) //remove(node:) calls remove(coin:) if it's a goody
            collectables.remove(nonBallNode as! CollectableObject)
            let didOverflow = ball.increaseBallSize()
            if didOverflow {
                for collectable in collectables {
                    collectable.increaseSpeed(by: Constants.DELTA_OBJECT_SPEED)
                }
                score += 1
                scoreLabel.text = "Score: \(score)"
            }
            return
            
        case NodeNames.baddy.rawValue: // if nonBallNode is a baddy and lower ball size/ end game
            remove(node: nonBallNode)
            collectables.remove(nonBallNode as! CollectableObject)
            let didOverflow = ball.decreaseBallSize()
            if didOverflow {
                remove(node: ballNode)
                stopGame()
                
            }
            return
            
        case _: // should never happen as long as the names are correct
            //probably should throw an error but it shouldn't be a problem and i dont want to deal with that right now
            print("invalid name for nonBallNode")
            return
        }
    }
        
    func remove(node: SKNode) {
//        switch node.name {
//        case NodeNames.coin.rawValue:
//            remove(coin: node)
//            return
//        case NodeNames.ship.rawValue, NodeNames.ghost.rawValue:
//            node.removeFromParent()
//            return
//        case _:
//            print("Invalid name")
//            return
//        }
        node.removeFromParent()
    }

    
    
    // ---------------- Game Start/ End -------------
    override func didMove(to view: SKView) {
        print("did move")
        view.isMultipleTouchEnabled = true
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(ball)
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        createDirectionals()

    }
    
    func createDirectionals() {
        for direction in Direction.allCases {
            let newDirectional = Directional(direction: direction)
            switch direction {
            case .east:
                newDirectional.position = CGPoint(x: self.frame.minX + 150, y: self.frame.minY + 50)
            case .west:
                newDirectional.position = CGPoint(x: self.frame.minX + 50, y: self.frame.minY + 50)
            case .north:
                newDirectional.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 150)
            case .south:
                newDirectional.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.minY + 50)
            }
            newDirectional.zPosition = 1
            directionals.append(newDirectional)
            addChild(newDirectional)

        }
    
    }
    
    func stopGame() {
        presentingView?.dismiss()
    }
}
