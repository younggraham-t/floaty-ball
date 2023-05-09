//
//  ControlSettingsView.swift
//  FloatyBall
//
//  Created by Graham on 5/2/23.
//

import SpriteKit


class ControlSettingsScene: SceneWithDirectional {
    
    var controlMenu: ControlMenu = ControlMenu()
    
    
    
  
    var gameScene: GameScene? {
        didSet {
            controlMenu.gameScene = gameScene
        }
    }
    
    var presentingView: ControlView? {
        didSet {
            controlMenu.presentingView = presentingView
        }
    }
    
    override func didMove(to view: SKView) {
        
        print("control scene - didMove")
        self.name = "control scene"
        for child in children {
            child.removeFromParent()
        }
        controlMenu.position = CGPoint(x: frame.midX, y: frame.midY + 50)
        controlMenu.presentingView = presentingView
        controlMenu.displayTo(scene: self)
        
        controlManager?.createDirectionals(in: self)
        
        //        print("control menu displayed \(controlMenu.isDisplayed)")
        //        print("control menu parent \(controlMenu.parent)")
    }
    
    
    
    
    

}


