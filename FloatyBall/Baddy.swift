//
//  Baddy.swift
//  FloatyBall
//
//  Created by Graham on 4/18/23.
//

import SpriteKit

class Baddy: CollectableObject {
    init(moveDirection: Direction) {
        super.init()
        createPath(moveDirection: moveDirection)
        initPhysicsBody()
        
        self.moveDirection = moveDirection
        
        setColorParams(strokeColor: .black, fillColor: .red)
        
        self.name = NodeNames.baddy.rawValue
    }
    
    func createPath(moveDirection: Direction) {
        switch moveDirection {
        case .north, .south:
            self.path = UIBezierPath(rect: Constants.VERTICAL_COLLECTABLE_BOUNDING_BOX).cgPath
        case .east, .west:
            self.path = UIBezierPath(rect: Constants.HORIZONTAL_COLLECTABLE_BOUNDING_BOX).cgPath
        }
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
//    override func update(screen: CGRect) {
//        
//    }
}
