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
        createPath()
        initPhysicsBody()
        
        self.moveDirection = moveDirection
        
        setColorParams(strokeColor: .black, fillColor: .red)
        
        self.name = NodeNames.baddy.rawValue
    }
    
    func createPath() {
        self.path = UIBezierPath(rect: Constants.collectableBounds).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(screen: CGRect) {
        self.physicsBody?.velocity = CGVector(dx: moveSpeed, dy: 0)
    }
}
