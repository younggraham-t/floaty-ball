//
//  ControlsMenu.swift
//  FloatyBall
//
//  Created by Graham on 5/3/23.
//

import Foundation
import SpriteKit
import SwiftUI

enum ControlMenuActions: String, MenuItemAction, CaseIterable, Codable {
    case dPadLeft = "D-Pad on Left"
    case dPadRight = "D-Pad on Right"
    case horizontalLeft = "Horizontal on Left"
    case horizontalRight = "Horizontal on Right"
    
    func preformAction(displayingScene: SKScene) {
        print("preform control menu action")
        let controlScene = displayingScene as! SceneWithDirectional
        
        switch self {
        case _:
            controlScene.setControlPosition(for: self)
        }
        
    }
    
    
}

class ControlMenuItem: MenuItem<ControlMenuActions> {}

class ControlMenu: InGameMenu<ControlMenuActions, ControlMenuItem> {
   
    private var backButton = SKLabelNode(text: "Back")
    
    var presentingView: ControlView? = nil
    var gameScene: GameScene? = nil
    
    override init() {
        super.init()
        print("controls menu - didLoad")
        self.name = "controls menu"
       
        backButton.position = CGPoint(x: frame.minX, y: frame.maxY)
        addChild(backButton)
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)
        if let touch = touches.first {
            if closeEnough(backButton, touch) {
                print("touch back control menu")
//                print("presenting view \(presentingView)")
                if let presentingView = presentingView {
                    presentingView.dismiss()
                }
                else if let gameScene = gameScene {
                    gameScene.returnFromControlMenuToSettingsMenu()
                }
            }
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func setupMenuItems() {
        let menuItemStartPositionX = frame.midX
        var menuItemPositionY = frame.midY
        let menuItemPositionYOffset = 50.0
        
        for menuItemAction in ControlMenuActions.allCases {
            let menuItem = ControlMenuItem(menuItemAction)
            menuItemPositionY -= menuItemPositionYOffset
            let menuItemStartPosition = CGPoint(x: menuItemStartPositionX, y: menuItemPositionY)
            menuItem.position = menuItemStartPosition
            addToMenuItems(item: menuItem)
            addChild(menuItem)
            
        }

    }
    
}
