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
    
    var touchesToDirectionals = [UITouch: Directional]()
    
    var directionals = [Directional]()
    
    var score = 0
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: 0")
    
    var collectablesCurrentSpeed = Constants.OBJECT_MOVE_SPEED
    
    
    

    // ------------------- Updates --------------------
    
    var collectableTime = 0.0
    
    override func update(_ currentTime: TimeInterval) {
        if collectableTime == 0.0 {
            collectableTime = currentTime
        }
        
        //update the ball
        ball.update()
        
        // update all the collectables
        for collectable in collectables {
            if collectable.update(screen: self.frame) { // update returns true if it leaves the screen
                collectable.removeFromParent()
                collectables.remove(collectable)
            }
        }
        
        //check all the touches for if a direction is being pressed
        for touch in touchesToDirectionals.keys {
            if let directional = touchesToDirectionals[touch] {
                let direction = directional.direction
                ball.moveIn(direction: direction, screen: self.frame)
            }
            
        }
        
        if collectableTime != 0.0 && collectableTime + Constants.SPAWN_COLLECTABLE_TIME < currentTime {
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
            newCollectable = Goody(moveDirection: moveDirection, speed: collectablesCurrentSpeed)
        }
        else {
            newCollectable = Baddy(moveDirection: moveDirection, speed: collectablesCurrentSpeed)
        }
       
        let randomInSide = randomizeSpawnLocationInSide(moveDirection: moveDirection)
        
        switch moveDirection {
        case .north:
            newCollectable.position = CGPoint(x: randomInSide, y: frame.minY - Constants.COLLECTABLE_LONG_AXIS_LENGTH)
        case .south:
            newCollectable.position = CGPoint(x: randomInSide, y: frame.maxY)
        case .east:
            newCollectable.position = CGPoint(x: frame.minX - Constants.COLLECTABLE_LONG_AXIS_LENGTH, y: randomInSide)
        case .west:
            newCollectable.position = CGPoint(x: frame.maxX, y: randomInSide)
        }
        collectables.insert(newCollectable)
        self.addChild(newCollectable)
    }
    
    func randomizeSpawnLocationInSide(moveDirection: Direction) -> Double {
        var randomInSide = 0.0
        switch moveDirection {
        case .north, .south:
            let horizontalSpawnRange = Constants.COLLECTABLE_SHORT_AXIS_LENGTH+frame.minX...frame.maxX-Constants.COLLECTABLE_SHORT_AXIS_LENGTH
            randomInSide = Double.random(in: horizontalSpawnRange)
        case .east, .west:
            let verticalSpawnRange = Constants.COLLECTABLE_SHORT_AXIS_LENGTH+frame.minY...frame.maxY-Constants.COLLECTABLE_SHORT_AXIS_LENGTH
            randomInSide = Double.random(in: verticalSpawnRange)
        }
        return randomInSide
    }
    
    func randomizeMoveDirection() -> Direction {
        let isHorizontal = Double.random(in: 0...1) < 0.5 // 50% chance for vertical or horizontal
        let isMin = Double.random(in: 0...1) < 0.5 // 50% chance for min to max
        let moveDirection: Direction
        if isHorizontal {
            // if it starts at the min and moves to the max
            moveDirection = isMin ? .east : .west
        }
        else {
            // if it starts at the min and moves to the max
            moveDirection = isMin ? .south : .north
        }
        return moveDirection
    }
    
    
    // ------------------- Touches ----------------------
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
//            print("touch - began")
//            currentTouches.insert(touch)
            for directional in self.directionals {
                
                if closeEnough(directional, touch) {
//                    print("touched the directional")
                    touchesToDirectionals[touch] = directional
                }
            }
        }
    }
    
    func closeEnough(_ target: SKSpriteNode, _ touch: UITouch) -> Bool {
        
        let targetPosition = target.position
        let touchPosition = touch.location(in: self)

        let closeInX = abs(targetPosition.x - touchPosition.x) <= Constants.TOUCH_TOLERANCE
        let closeInY = abs(targetPosition.y - touchPosition.y) <= Constants.TOUCH_TOLERANCE
        
        return closeInX && closeInY
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touch - moved")
    touchLoop:
        for touch in touches {
            if let directional = touchesToDirectionals[touch] {
                // print("touch in touches to directionals")
                if !closeEnough(directional, touch) {
                  
                    ball.stopMovement()
                    
                    touchesToDirectionals.removeValue(forKey: touch)

                    
                }
            }
            else {
                for directional in self.directionals {
                    if closeEnough(directional, touch) {
                      touchesToDirectionals[touch] = directional
                      continue touchLoop
                    }
                }
            }
        }
        

    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("touch - ended")
        for touch in touches {
            if let touchIndex = touchesToDirectionals.index(forKey: touch) {
                touchesToDirectionals.remove(at: touchIndex)
            }
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
                collectablesCurrentSpeed += Constants.DELTA_OBJECT_SPEED
                for collectable in collectables {
                    collectable.updateSpeed(to: collectablesCurrentSpeed)
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
