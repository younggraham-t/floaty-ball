//
//  Goody.swift
//  FloatyBall
//
//  Created by Graham on 4/18/23.
//

import SpriteKit


class Goody: CollectableObject {
    init(moveDirection: Direction) {
        super.init()
        createPath(moveDirection: moveDirection)
        initPhysicsBody()
        
        self.moveDirection = moveDirection
        setColorParams(strokeColor: .white, fillColor: .green)
        
        self.name = NodeNames.goody.rawValue
    }
    
    func createPath(moveDirection: Direction) {
        switch moveDirection {
        case .north, .south:
            self.path = UIBezierPath(ovalIn: Constants.VERTICAL_COLLECTABLE_BOUNDING_BOX).cgPath
        case .east, .west:
            self.path = UIBezierPath(ovalIn: Constants.HORIZONTAL_COLLECTABLE_BOUNDING_BOX).cgPath
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func update(screen: CGRect) {
//        
//        self.physicsBody?.velocity = self.velocity
//    }
    
    
}
