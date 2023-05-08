//
//  ControlSettingsView.swift
//  FloatyBall
//
//  Created by Graham on 5/2/23.
//

import SpriteKit


class ControlSettingsScene: SceneWithDirectional {
    
    private var controlMenu: ControlMenu = ControlMenu()
    
    var controlManager: ControlManager = ControlManager()
    
    
    var presentingView: ControlView? {
        didSet {
            controlMenu.presentingView = presentingView
        }
    }
    
    override func didMove(to view: SKView) {
        
        print("control scene - didMove")
        self.name = "control scene"
        controlMenu.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        controlMenu.presentingView = presentingView
        controlMenu.displayTo(scene: self)
        
        controlManager.createDirectionals(in: self)
        
        //        print("control menu displayed \(controlMenu.isDisplayed)")
        //        print("control menu parent \(controlMenu.parent)")
    }
    
    
    
    func setControlPosition(for newControlPosition: ControlMenuActions) {
        removeDirectionals()
        print("after remove \(directionals)")
        print("after remove \(children)")
        controlManager.changeControls(to: newControlPosition)
        controlManager.createDirectionals(in: self)
        print(" after add \(directionals)")
    }
    

}


