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
    
    

    // ------------------- Updates --------------------
    
    
    
    override func update(_ currentTime: TimeInterval) {
        
        
        for collectable in collectables {
//            print(collectable)
            collectable.update(screen: self.frame)
        }
        
    }
    
    
    
    // ------------------- Touches ----------------------
    
    
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        
    }
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        
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
            // TODO: increase ball size or increase score
            return
            
        case NodeNames.baddy.rawValue: // if nonBallNode is a ghost remove the ball and lower ball size/ end game
            remove(node: ballNode)
            // TODO: lower ball size and or end game
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
        
        physicsWorld.gravity = .zero
        physicsWorld.contactDelegate = self
        
        ball.position = CGPoint(x: frame.midX, y: frame.midY)
        self.addChild(ball)
        
        let newGoody = Goody()
        newGoody.position = CGPoint(x: self.frame.maxX, y: self.frame.midY)
        collectables.insert(newGoody)
        self.addChild(newGoody)
        
        let newGoody1 = Goody()
        newGoody1.position = CGPoint(x: self.frame.maxX - 50, y: self.frame.midY)
        collectables.insert(newGoody1)
        self.addChild(newGoody1)
//        let newBaddy = Baddy()
//        newBaddy.position = CGPoint(x: self.frame.minX, y: self.frame.midY)
//        collectables.append(newBaddy)
//        self.addChild(newBaddy)
    }
    
    func stopGame() {
        presentingView?.dismiss()
    }
}
