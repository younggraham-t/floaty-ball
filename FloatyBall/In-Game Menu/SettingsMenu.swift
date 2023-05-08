//
//  SettingsMenu.swift
//  FloatyBall
//
//  Created by Graham on 5/2/23.
//

import Foundation
import SpriteKit

enum SettingsMenuItemAction: String, CaseIterable, MenuItemAction {
    
    case back = "Back"
    case controls = "Controls (Not Implemented)"
    
    
    
    func preformAction(displayingScene: SKScene) {
        let gameScene = displayingScene as! GameScene
        switch self {
        case .back:
            print("touch - settings back")
            gameScene.returnFromSettingsToPauseMenu()
        case .controls:
            print("touch - settings controls")
            gameScene.displayControlScene()
        case _:
            return
        }
    }
}

class SettingsMenuItem: MenuItem<SettingsMenuItemAction> {}

class SettingsMenu: InGameMenu<SettingsMenuItemAction, SettingsMenuItem> {
    
    override init() {
        super.init()
        print("settings menu - didLoad")
        self.name = "settings menu"
        
        
    }
    
    override func setupMenuItems() {
        let menuItemStartPositionX = frame.midX
        var menuItemPositionY = frame.midY
        let menuItemPositionYOffset = 50.0
        
        for menuItemAction in SettingsMenuItemAction.allCases {
            let menuItem = SettingsMenuItem(menuItemAction)
            menuItemPositionY -= menuItemPositionYOffset
            let menuItemStartPosition = CGPoint(x: menuItemStartPositionX, y: menuItemPositionY)
            menuItem.position = menuItemStartPosition
            addToMenuItems(item: menuItem)
            addChild(menuItem)
            
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
