//
//  ControlView.swift
//  FloatyBall
//
//  Created by Graham on 5/4/23.
//

import Foundation
import SwiftUI
import SpriteKit

struct ControlView: View {
    
    @Environment(\.dismiss) var dismiss
    var controlManager: ControlManager
   
    init(controlManager: ControlManager) {
        self.controlManager = controlManager
    }
    
    var controlScene: ControlSettingsScene {
        let controlSettingsScene = ControlSettingsScene()
        controlSettingsScene.scaleMode = .resizeFill
        controlSettingsScene.presentingView = self
        controlSettingsScene.controlManager = controlManager
        return controlSettingsScene
    }
    var body: some View {
        SpriteView(scene: controlScene)
    }
}
