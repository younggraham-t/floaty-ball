//
//  PauseMenu.swift
//  FloatyBall
//
//  Created by Graham on 4/29/23.
//

import Foundation
import SpriteKit

enum PauseMenuItemAction: String, CaseIterable, MenuItemAction {
    
    case resume = "Resume"
    case restart = "Restart"
    case settings = "Settings"
    case mainMenu = "Main Menu"
    
    
    
    
    func preformAction(displayingScene: SKScene) {
        print("preform action")
        let gameScene = displayingScene as! GameScene
        switch self {
        case .resume:
            print("touch resume")
            gameScene.resumeGame()
        case .restart:
            print("touch restart")
//            gameScene.resumeGame()
            gameScene.restart()
        case .mainMenu:
            print("touch main menu")
            gameScene.stopGame()
        case .settings:
            print("touch settings")
            gameScene.displaySettingsMenu()
        case _:
            //do nothing
            return
        }

    }
}

class PauseMenuItem: MenuItem<PauseMenuItemAction> {}

class PauseMenu: InGameMenu<PauseMenuItemAction, PauseMenuItem> {
   
    override init() {
        super.init()
        print("pause menu - didLoad")
        self.name = "pause menu"
        
        
    }
    
    override func setupMenuItems() {
        let menuItemStartPositionX = frame.midX
        var menuItemPositionY = frame.midY
        let menuItemPositionYOffset = 50.0
        
        for menuItemAction in PauseMenuItemAction.allCases {
            let menuItem = PauseMenuItem(menuItemAction)
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
