//
//  GameScene.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SpriteKit

class SceneWithDirectional: SKScene {
    
    
    var directionals: Set<Directional> = Set()
    var controlManager: ControlManager? = nil
    
    func addDirectional(_ directional: Directional) {
        directionals.insert(directional)
    }
    func removeDirectionals() {
        for directional in directionals {
            directional.removeFromParent()
        }
        directionals.removeAll()
        
    }
    func setControlPosition(for newControlPosition: ControlMenuActions) {
        removeDirectionals()
        print("after remove \(directionals)")
        print("after remove \(children)")
        controlManager?.changeControls(to: newControlPosition)
        controlManager?.createDirectionals(in: self)
        print(" after add \(directionals)")
    }
}

class GameScene : SceneWithDirectional, SKPhysicsContactDelegate {

    
    //------------------ Variables -------------------
    
    
    
    var presentingView: GameplayView? = nil
    
    var ballSpeed: BallSpeed? = nil
    
    var ball: Ball = Ball()
    
    var collectables = Set<CollectableObject>() //uses set to make removal easier (for memory management)
    
    var touchesToDirectionals = [UITouch: Directional]()
    
    
//    var score = 0
    var scoreLabel: SKLabelNode = SKLabelNode(text: "Score: 0")
    
    var collectablesCurrentSpeed = 0.0
    
    var collectableTime = 0.0
    
    var highScore: ScoreManager? = nil
    
    var settings: Settings? = nil
    
    var controlScene: ControlSettingsScene? = nil
    
    
    var pauseMenu = PauseMenu()
        
    var pauseButton: PauseButton = PauseButton()
    
    var settingsMenu = SettingsMenu()
    
    var controlMenu = ControlMenu()

    // ------------------- Updates --------------------
    
    
    
    override func update(_ currentTime: TimeInterval) {
//        print("update \(pauseMenu.isDisplayed)")
        if pauseMenu.isDisplayed {
            for collectable in collectables {
                collectable.stopMovement()
            }
            return
        }
//        print("update \(pauseMenu.isDisplayed)")
        
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
        let isGoody = Double.random(in: 0...1) > settings!.percentBaddies
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
        case _:
            print("shouldn't happen in spawn collectable")
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
        case _:
            print("shouldn't happen in randomize spawn location in side")
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
            if closeEnough(pauseButton, touch) {
                pauseGame()
                return
            }
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
    
//    func closeEnough(_ target: SKSpriteNode, _ touch: UITouch) -> Bool {
//
//        let targetPosition = target.position
//        let touchPosition = touch.location(in: self)
//
//        let closeInX = abs(targetPosition.x - touchPosition.x) <= Constants.TOUCH_TOLERANCE
//        let closeInY = abs(targetPosition.y - touchPosition.y) <= Constants.TOUCH_TOLERANCE
//
//        return closeInX && closeInY
//    }
    
    func closeEnough(_ target: SKNode, _ touch: UITouch) -> Bool {
        
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
                if collectablesCurrentSpeed < Constants.COLLECTABLE_MAX_SPEED {
                    collectablesCurrentSpeed += settings!.deltaMoveSpeed
                    for collectable in collectables {
                        collectable.updateSpeed(to: collectablesCurrentSpeed)
                    }
                }
                
                highScore?.increaseScore()
                scoreLabel.text = "Score: \(highScore!.getCurrentScore())"
                highScore?.updateLifeTimeHighScore()
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
        if node.parent != nil {
            node.removeFromParent()
        }
        
    }

    
    
    // ---------------- Game Start/ End -------------

    override func didMove(to view: SKView) {
        print("did move")
        self.name = "game scene"
        view.isMultipleTouchEnabled = true
        setupGame()
        

    }
    
    func setupGame() {
        setupVariables()
        self.collectablesCurrentSpeed = settings!.collectableMoveSpeed
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        
        scoreLabel.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        scoreLabel.zPosition = 1
        addChild(scoreLabel)
        
        controlManager?.createDirectionals(in: self)
        
        pauseButton.position = CGPoint(x: frame.minX + 50, y: frame.maxY - 50)
        pauseButton.name = NodeNames.button.rawValue
        pauseButton.zPosition = 1
        pauseButton.gameScene = self
        addChild(pauseButton)
        
//        pauseMenu.displayingScene = self
        pauseMenu.position = CGPoint(x: frame.midX, y: frame.midY)
        pauseMenu.zPosition = 1
//        pauseMenu.scaleMode = .resizeFill
//        settingsMenu.displayingScene = self
        settingsMenu.position = CGPoint(x: frame.midX, y: frame.midY)
        settingsMenu.zPosition = 1
        
        controlMenu.position = CGPoint(x: frame.midX, y: frame.midY)
        controlMenu.zPosition = 1
    }
    
//    func addDirectional(_ directional: Directional) {
//        directionals.append(directional)
//    }
//
//    func removeDirectionals() {
//        for directional in directionals {
//            directional.removeFromParent()
//        }
//        directionals.removeAll()
//    }

    
    func setupVariables() {
        
        pauseMenu.stopDisplayingIn(scene: self)
        for child in children {
            child.removeFromParent()
        }
        if let ballSpeed = ballSpeed {
            ball = Ball(speed: ballSpeed)
        }
        else {
            ball = Ball()
        }
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(ball)
        
        collectables = Set<CollectableObject>() //uses set to make removal easier (for memory management)
        
        touchesToDirectionals = [UITouch: Directional]()
        
        directionals = Set<Directional>()
        
    //    var score = 0
        scoreLabel = SKLabelNode(text: "Score: 0")
        
        collectablesCurrentSpeed = 0.0
        
        collectableTime = 0.0
        
        
        
        print(pauseMenu.isDisplayed)
    }
    
    func restart() {
//        resumeGame()
        setupGame()
    }
   
    func stopGame() {
        highScore?.updateLifeTimeHighScore()
        presentingView?.dismiss()
    }
    
    //-------------------- IN GAME MENUS -------------------------
    
   
    
    
    func pauseGame() {
        print("pause game")
        remove(node: pauseButton)
        
//        print(pauseMenu.parent)
//        pauseMenu.move(toParent: self)
        pauseMenu.displayTo(scene: self)
        
        for directional in directionals {
            remove(node: directional)
        }
        for collectable in collectables {
            collectable.setColorParams(strokeColor: .gray, fillColor: .gray)
        }
        ball.strokeColor = .gray
        ball.fillColor = .gray
    }
    
    func resumeGame() {
//        remove(node: pauseButton)
        addChild(pauseButton)
        
        pauseMenu.stopDisplayingIn(scene: self)
        
        for directional in directionals {
            addChild(directional)
        }
        
        for collectable in collectables {
            if collectable is Goody {
                collectable.setColorParams(strokeColor: .white, fillColor: .green)
            }
            else {
                collectable.setColorParams(strokeColor: .black, fillColor: .red)
            }
        }
        ball.strokeColor = .white
        ball.fillColor = .blue
        print("resume \(pauseMenu.isDisplayed)")
    }
    
    func displaySettingsMenu() {
        guard pauseMenu.isDisplayed else { return }
        
        remove(node: pauseMenu)
        settingsMenu.displayTo(scene: self)
    }
    
    func returnFromSettingsToPauseMenu() {
        guard settingsMenu.isDisplayed else { return }
        
        remove(node: settingsMenu)
        addChild(pauseMenu)
        settingsMenu.stopDisplayingIn(scene: self)
    }
    
    func displayControlMenu() {
        guard settingsMenu.isDisplayed else { return }
        controlMenu.presentingView = nil
        controlMenu.gameScene = self
        
        remove(node: settingsMenu)
        addChild(controlMenu)
        for directional in directionals {
            addChild(directional)
        }
//        print(controlMenu.parent)
        controlMenu.displayTo(scene: self)
    }
    
    func returnFromControlMenuToSettingsMenu() {
        guard controlMenu.isDisplayed else { return }
        remove(node: controlMenu)
        addChild(settingsMenu)

        for directional in directionals {
            remove(node: directional)
        }
        controlMenu.stopDisplayingIn(scene: self)
    }
}
