//
//  Baddy.swift
//  FloatyBall
//
//  Created by Graham on 4/18/23.
//

import SpriteKit

class Baddy: CollectableObject {
    override init() {
        super.init()
        createPath()
        initPhysicsBody()
        
        self.fillColor = .red
        self.strokeColor = .black
        self.glowWidth = 1.0
        self.isAntialiased = true
    }
    
    func createPath() {
        self.path = UIBezierPath(rect: Constants.collectableBounds).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(screen: CGRect) {
        self.physicsBody?.velocity = CGVector(dx: -moveSpeed, dy: 0)
    }
}
