//
//  GameRulesView.swift
//  Gates of Olympus
//
//  Created by Nandini Vithlani on 06/10/23.
//

import SwiftUI

struct GameRulesView: View {
    var body: some View {
        VStack(spacing: 40) {
            
            Text("Game Rules")
                .font(.title)
                .foregroundColor(.white)
            
            Text("1. Tap to pop items")
                .font(.system(size: 18, weight: .regular, design: .rounded))
                .foregroundColor(.white)
            
            Text("2. Don’t let them reach the line")
                .font(.system(size: 18, weight: .regular, design: .rounded)) // Change font and apply italic style
                .foregroundColor(.white)
            
            Text("3. You have 3 lives")
                .font(.system(size: 18, weight: .regular, design: .rounded)) // Change font and apply italic style
                .foregroundColor(.white)
            
            Text("4. Try to get the BEST SCORE")
                .font(.system(size: 18, weight: .regular, design: .rounded)) // Change font and apply italic style
                .foregroundColor(.white)
        }
        .padding()
        .background(Color.gray) // Gray background
        .cornerRadius(10) // Optional: add corner radius for rounded corners
    }
}

struct BackgroundView: View {
    var body: some View {
        Image("mainscreen") // Replace "backgroundImage" with the name of your background image
            .resizable()
            .edgesIgnoringSafeArea(.all)
            .overlay(
                GameRulesView()
            )
    }
}

