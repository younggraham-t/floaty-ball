//
//  ContentView.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SwiftUI
import SpriteKit

struct GameplayViewParameters {
    var highScore: ScoreManager
    var difficulty: Difficulty
    var ballSpeed: BallSpeed
    var controlManager: ControlManager
}

struct StartView: View {
    @State private var isGameplayViewPresented = false
    @State private var isControlViewPresented = false
    
    @State var difficulty: Difficulty = .Normal
    @State var ballSpeed: BallSpeed = .med
    @ObservedObject var highScore: ScoreManager = ScoreManager()
    
    var controlManager = ControlManager()

    

    

//    var body: some View {
//        ControlView()
//
//    }
    var body: some View {
        
        VStack {
            Spacer()
            HStack {
                Text("High Score: \(highScore.lifeTimeHighScore)\t")
                    .padding()
                
                Picker("Difficulty", selection: $difficulty) {
                    ForEach(Difficulty.allCases) { difficulty in
                        Text(difficulty.rawValue.capitalized)
                    }
                }
                .fixedSize()
                .onChange(of: difficulty) { _ in
                    highScore.setDifficulty(newDifficulty: difficulty)
                }
                .padding()
            }
            
            HStack {
                Text("Ball Speed\t")
                    .padding()
               
                Picker("Ball Speed", selection: $ballSpeed) { // in game the initial ball speed is affected by this, but the ball also changes speed based on size, samller = faster, bigger = slower.
                    ForEach(BallSpeed.allCases) { speed in
                        Text(speed.rawValue.capitalized)
                    }
                }
                .fixedSize()
                
                .onChange(of: ballSpeed) { _ in
                    print(ballSpeed)
                }
                .padding()
            }
            
            VStack {
                Button("Change Controls") {
                    isControlViewPresented = true
                }
                .padding()
                Button("Play Floaty Ball") {
                    isGameplayViewPresented = true
                }
                .padding()
            }
            Spacer()
        }
        .font(.title)
        .padding()
        .fullScreenCover(isPresented: $isGameplayViewPresented) {
            GameplayView(GameplayViewParameters(highScore: highScore, difficulty: highScore.difficulty, ballSpeed: ballSpeed, controlManager: controlManager))
            
        }
        .fullScreenCover(isPresented: $isControlViewPresented) {
            ControlView(controlManager: controlManager)
        }
        .pickerStyle(.segmented)

        
    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
