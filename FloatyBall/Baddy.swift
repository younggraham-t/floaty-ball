//
//  Baddy.swift
//  FloatyBall
//
//  Created by Graham on 4/18/23.
//

import SpriteKit

class Baddy: CollectableObject {
    
    override init(moveDirection: Direction, speed: Double) {
        super.init(moveDirection: moveDirection, speed: speed)
        
        setColorParams(strokeColor: .black, fillColor: .red)
        
        self.name = NodeNames.baddy.rawValue
    }
    
    override func createPath(moveDirection: Direction) {
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
    

}
