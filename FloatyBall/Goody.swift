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
        createPath()
        initPhysicsBody()
        
        self.moveDirection = moveDirection
        setColorParams(strokeColor: .white, fillColor: .green)
        
        self.name = NodeNames.goody.rawValue
    }
    
    func createPath() {
        self.path = UIBezierPath(ovalIn: Constants.collectableBounds).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(screen: CGRect) {
        
        self.physicsBody?.velocity = self.velocity
    }
    
    
}
