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
    }
    
    func createPath() {
        let goodySize = CGRect(x: 0, y: 0, width: 10, height: 15)
        self.path = UIBezierPath(ovalIn: goodySize).cgPath
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func update(screen: CGRect) {
        self.position.x = self.position.x - CGFloat(moveSpeed)
    }
    
    
}
