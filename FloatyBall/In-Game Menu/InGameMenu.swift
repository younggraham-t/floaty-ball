//
//  InGameMunu.swift
//  FloatyBall
//
//  Created by Graham on 5/2/23.
//


import SpriteKit

protocol MenuItemAction {
    func preformAction(displayingScene: SKScene)
}

class MenuItem<T>: SKLabelNode where T:MenuItemAction, T:RawRepresentable, T.RawValue == String {
    
    var itemType: T
    
    init(_ itemType: T) {
        self.itemType = itemType
        super.init()
        self.text = itemType.rawValue
    }
   
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}


//types E for enum and I for Item
class InGameMenu<E, I>: SKNode where E:MenuItemAction, I:MenuItem<E> {
   
    private var menuItems = Set<I>()
    
    private var _isDisplayed: Bool = false
    
    var isDisplayed: Bool {
        get {
            return _isDisplayed
        }
    }
    
    private var displayingScene: SKScene? = nil
    
    
    override init() {
        super.init()
        
        setupMenuItems()
        
        isUserInteractionEnabled = true
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    //should be implemented by subclasses
    func setupMenuItems() {
        return
    }
    
    func addToMenuItems(item: I) {
//        print("add to menu items")
        menuItems.insert(item)
    }
    
//    //does nothing
//    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        print("menu touch - began")
//    }
    
    // checks if a touch is close enough to an item and calls the action for that item
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        print("menu touch - ended")
        for menuItem in menuItems {
            if closeEnough(menuItem, touches.first!) {
                if let gameScene = displayingScene {
                    menuItem.itemType.preformAction(displayingScene: gameScene)
                }
                else {
                    print("displaying scene doesn't exist")
                }
            }
        }
    }
    
    func displayTo(scene: SKScene) {
        print("display to \(scene)")
        self.displayingScene = scene
        scene.addChild(self)
        self._isDisplayed = true
    }
    
    func stopDisplayingIn(scene: SKScene) {
        if self.parent == scene {
            self.removeFromParent()
            self._isDisplayed = false
        }
    }
    
    
    //checks if a UITouch is within a tolerance of a given SKNode
    func closeEnough(_ target: SKNode, _ touch: UITouch) -> Bool {
        
        let targetPosition = target.position
        let touchPosition = touch.location(in: self)

        let closeInX = abs(targetPosition.x - touchPosition.x) <= 150
        let closeInY = abs(targetPosition.y - touchPosition.y) <= 25
        
        return closeInX && closeInY
    }
}

