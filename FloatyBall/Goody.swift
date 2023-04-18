//
//  Goody.swift
//  FloatyBall
//
//  Created by Graham on 4/18/23.
//

import SpriteKit


class Goody: CollectableObject {
    override init() {
        super.init()
        createPath()
        initPhysicsBody()
        
        self.fillColor = .green
        self.strokeColor = .white
        self.glowWidth = 1.0
        self.isAntialiased = true
        self.name = NodeNames.goody.rawValue
    }
    
    func createPath() {
        self.path = UIBezierPath(ovalIn: Constants.collectableBounds).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(screen: CGRect) {
        
        self.physicsBody?.velocity = CGVector(dx: -moveSpeed, dy: 0)
    }
    
    
}
