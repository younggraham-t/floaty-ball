//
//  ContentView.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SwiftUI

struct StartView: View {
    @State private var isGameplayViewPresented = false
    @ObservedObject var highScore = ScoreManager()
    
    var body: some View {
        VStack {
            Text("High Score: \(highScore.lifeTimeHighScore)")
                .padding()
            Button("Play Floaty Ball") {
                isGameplayViewPresented = true
            }
        }
        .font(.title)
        .padding()
        .fullScreenCover(isPresented: $isGameplayViewPresented) {
            GameplayView(highScore: highScore)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        StartView()
    }
}
