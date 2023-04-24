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
    
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
}
