//
//  Goody.swift
//  FloatyBall
//
//  Created by Graham on 4/18/23.
//

import SpriteKit


class Goody: CollectableObject {
    
    override init(moveDirection: Direction, speed: Double) {
        super.init(moveDirection: moveDirection, speed: speed)

        setColorParams(strokeColor: .white, fillColor: .green)
        
        self.name = NodeNames.goody.rawValue
    }
    
    override func createPath(moveDirection: Direction) {
        switch moveDirection {
        case .north, .south:
            self.path = UIBezierPath(ovalIn: Constants.VERTICAL_COLLECTABLE_BOUNDING_BOX).cgPath
        case .east, .west:
            self.path = UIBezierPath(ovalIn: Constants.HORIZONTAL_COLLECTABLE_BOUNDING_BOX).cgPath
        case _:
            print("shouldn't happen")
        }
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
