//
//  ContentView.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SwiftUI
import SpriteKit

struct StartView: View {
    @State private var isGameplayViewPresented = false
    @State private var isControlViewPresented = false
    
    @State var difficulty: Difficulty = .Normal
    @ObservedObject var highScore: ScoreManager = ScoreManager()
    


    var controlView = ControlView()


//    var body: some View {
//        ControlView()
//
//    }
    var body: some View {
        
        VStack {
            Text("High Score: \(highScore.lifeTimeHighScore)")
                .padding()
            Picker("Difficulty", selection: $difficulty) {
                ForEach(Difficulty.allCases) { difficulty in
                    Text(difficulty.rawValue.capitalized)
                }
            }
            .onChange(of: difficulty) { _ in
                highScore.setDifficulty(newDifficulty: difficulty)
            }
            .padding()
            Button("Change Controls") {
                isControlViewPresented = true
            }
            .padding()
            Button("Play Floaty Ball") {
                isGameplayViewPresented = true
            }
        }
        .font(.title)
        .padding()
        .fullScreenCover(isPresented: $isGameplayViewPresented) {
            GameplayView(highScore: highScore, difficulty: highScore.difficulty, controlScene: controlView.controlScene)
            
        }
        .fullScreenCover(isPresented: $isControlViewPresented) {
            controlView
        }
        .pickerStyle(.segmented)

    }
}



//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        StartView()
//    }
//}
