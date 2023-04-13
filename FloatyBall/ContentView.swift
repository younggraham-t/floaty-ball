//
//  ContentView.swift
//  FloatyBall
//
//  Created by Graham on 4/13/23.
//

import SwiftUI

struct ContentView: View {
    @State private var isGameplayViewPresented = false
    var body: some View {
        VStack {
            Button("Play Floaty Ball") {
                isGameplayViewPresented = true
            }
        }
        .font(.title)
        .padding()
        .fullScreenCover(isPresented: $isGameplayViewPresented) {
            GameplayView()
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
