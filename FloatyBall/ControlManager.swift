//
//  ControlManager.swift
//  FloatyBall
//
//  Created by Graham on 5/2/23.
//

import Foundation
import SpriteKit

protocol SceneWithDirectional {
    func addDirectional(_ directional: Directional)
    func removeDirectionals()
}

enum ControlPositionCasesNonDPad {
    case leftLeft, leftRight, leftUp, leftDown, rightLeft, rightRight, rightUp, rightDown
}

struct ControlPossiblePositionsNonDPad<T> where T:SKScene, T:SceneWithDirectional{
    
    var scene: T
    
    func getPointFor(case controlPositionCase: ControlPositionCasesNonDPad) -> CGPoint {
        switch controlPositionCase {
        case .leftLeft:
            return leftLeft
        case .leftRight:
            return leftRight
        case .leftUp:
            return leftUp
        case .leftDown:
            return leftLeft
        case .rightLeft:
            return rightLeft
        case .rightRight:
            return rightRight
        case .rightUp:
            return rightUp
        case .rightDown:
            return rightRight
        }
    }
    
    var leftLeft: CGPoint {
        get {
            return CGPoint(x: scene.frame.minX + 50, y: scene.frame.minY + 50)
        }
    }
    var leftRight: CGPoint {
        get {
            return CGPoint(x: scene.frame.minX + 150, y: scene.frame.minY + 50)
        }
    }
    var leftUp: CGPoint {
        get {
            return CGPoint(x: scene.frame.minX + 50, y: scene.frame.minY + 150)
        }
    }
    var rightLeft: CGPoint {
        get {
            return CGPoint(x: scene.frame.maxX - 150, y: scene.frame.minY + 50)
        }
    }
    var rightRight: CGPoint {
        get {
            return CGPoint(x: scene.frame.maxX - 50, y: scene.frame.minY + 50)
        }
    }
    var rightUp: CGPoint {
        get {
            return CGPoint(x: scene.frame.maxX - 50, y: scene.frame.minY + 150)
        }
    }
}

enum ControlPositionCasesDPad {
    case left, right
}

struct ControlPossiblePositionsDPad<T> where T:SKScene, T:SceneWithDirectional {
    var scene: T
    func getPointDictionary(for controlPosition: ControlPositionCasesDPad) -> [Direction: CGPoint] {
        var output = [Direction: CGPoint]()
        switch controlPosition {
        case .right:
            output[.south] = CGPoint(x: scene.frame.maxX - 125, y: scene.frame.minY + 50)
            output[.north] = CGPoint(x: scene.frame.maxX - 125, y: scene.frame.minY + 200)
            output[.west] = CGPoint(x: scene.frame.maxX - 200, y: scene.frame.minY + 125)
            output[.east] = CGPoint(x: scene.frame.maxX - 50, y: scene.frame.minY + 125)
            output[.southeast] = CGPoint(x: scene.frame.maxX - 50, y: scene.frame.minY + 50)
            output[.northeast] = CGPoint(x: scene.frame.maxX - 50, y: scene.frame.minY + 200)
            output[.southwest] = CGPoint(x: scene.frame.maxX - 200, y: scene.frame.minY + 50)
            output[.northwest] = CGPoint(x: scene.frame.maxX - 200, y: scene.frame.minY + 200)
        case .left:
            output[.south] = CGPoint(x: scene.frame.minX + 125, y: scene.frame.minY + 50)
            output[.north] = CGPoint(x: scene.frame.minX + 125, y: scene.frame.minY + 200)
            output[.east] = CGPoint(x: scene.frame.minX + 200, y: scene.frame.minY + 125)
            output[.west] = CGPoint(x: scene.frame.minX + 50, y: scene.frame.minY + 125)
            output[.southwest] = CGPoint(x: scene.frame.minX + 50, y: scene.frame.minY + 50)
            output[.northwest] = CGPoint(x: scene.frame.minX + 50, y: scene.frame.minY + 200)
            output[.southeast] = CGPoint(x: scene.frame.minX + 200, y: scene.frame.minY + 50)
            output[.northeast] = CGPoint(x: scene.frame.minX + 200, y: scene.frame.minY + 200)
        }
        
        return output
    }
    
}

class ControlManager {
    
    static let userDefaultControlKey = "control key"
   
    var controlPosition: ControlMenuActions
    
    var directionalPositions: [Direction: CGPoint] = Dictionary()
    
    init() {
        controlPosition = .horizontalLeft
        decodePosition()
    }
    
    func changeControls(to control: ControlMenuActions) {
        controlPosition = control
        encodePosition(for: control)
    }
    
    
    // encoding and decoding info found here: https://cocoacasts.com/ud-5-how-to-store-a-custom-object-in-user-defaults-in-swift
    func encodePosition(for controlPosition: ControlMenuActions) {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(controlPosition)

            // Write/Set Data
            UserDefaults.standard.set(data, forKey: Self.userDefaultControlKey)

        } catch {
            print("Unable to Encode Note (\(error))")
        }
    }
    
    func decodePosition() {
        if let data = UserDefaults.standard.data(forKey: Self.userDefaultControlKey) {
            do {
                // Create JSON Decoder
                let decoder = JSONDecoder()

                // Decode Note
                controlPosition = try decoder.decode(ControlMenuActions.self, from: data)

            } catch {
                print("Unable to Decode Note (\(error))")
            }
        }
    }
    
    func createDirectionals<T>(in scene: T) where T:SKScene, T:SceneWithDirectional{
       
        directionalPositions.removeAll()
        scene.removeDirectionals()
        let controlPossibleNonDPad = ControlPossiblePositionsNonDPad(scene: scene)
        let controlPossibleDPad = ControlPossiblePositionsDPad(scene: scene)
        switch controlPosition {
        case .dPadLeft:
            directionalPositions = controlPossibleDPad.getPointDictionary(for: .left)
        case .dPadRight:
            directionalPositions = controlPossibleDPad.getPointDictionary(for: .right)
        case .horizontalLeft:
            directionalPositions[.east] = controlPossibleNonDPad.getPointFor(case: .leftRight)
            directionalPositions[.west] = controlPossibleNonDPad.getPointFor(case: .leftLeft)
            directionalPositions[.north] = controlPossibleNonDPad.getPointFor(case: .rightUp)
            directionalPositions[.south] = controlPossibleNonDPad.getPointFor(case: .rightDown)
        case .horizontalRight:
            directionalPositions[.east] = controlPossibleNonDPad.getPointFor(case: .rightRight)
            directionalPositions[.west] = controlPossibleNonDPad.getPointFor(case: .rightLeft)
            directionalPositions[.north] = controlPossibleNonDPad.getPointFor(case: .leftUp)
            directionalPositions[.south] = controlPossibleNonDPad.getPointFor(case: .leftDown)
        }
        for direction in directionalPositions.keys {
            let newDirectional = Directional(direction: direction)
            newDirectional.position = directionalPositions[direction]!
//            switch direction {
//            case .east:
//                newDirectional.position = CGPoint(x: gameScene.frame.minX + 150, y: gameScene.frame.minY + 50)
//            case .west:
//                newDirectional.position = CGPoint(x: gameScene.frame.minX + 50, y: gameScene.frame.minY + 50)
//            case .north:
//                newDirectional.position = CGPoint(x: gameScene.frame.maxX - 50, y: gameScene.frame.minY + 150)
//            case .south:
//                newDirectional.position = CGPoint(x: gameScene.frame.maxX - 50, y: gameScene.frame.minY + 50)
//            }
            switch direction {
            case .north, .south, .east, .west:
                newDirectional.zPosition = 2
            case _:
                newDirectional.setScale(0.75)
                newDirectional.zPosition = 1
            }
            
            scene.addDirectional(newDirectional)
            scene.addChild(newDirectional)

        }
    
    }

}
